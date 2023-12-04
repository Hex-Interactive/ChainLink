local ASTNodeIDs = require(script.Parent:WaitForChild("ASTNodeIDs"))
local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

local PREC = {
	[LexemeIDs.Pow] = 40,
	[LexemeIDs.Mod] = 30,
	[LexemeIDs.Multiply] = 30,
	[LexemeIDs.Divide] = 30,
	[LexemeIDs.Add] = 20,
	[LexemeIDs.Subtract] = 20,
	[LexemeIDs.Equal] = 10,
	[LexemeIDs.LessEqual] = 10,
	[LexemeIDs.Less] = 10,
	[LexemeIDs.GreaterEqual] = 10,
	[LexemeIDs.Greater] = 10,
	[LexemeIDs.NotEqual] = 10,
}
local ASSOC = {
	[LexemeIDs.Pow] = 0,
	[LexemeIDs.Mod] = 1,
	[LexemeIDs.Multiply] = 1,
	[LexemeIDs.Divide] = 1,
	[LexemeIDs.Add] = 1,
	[LexemeIDs.Subtract] = 1,
	[LexemeIDs.Equal] = 1,
	[LexemeIDs.LessEqual] = 1,
	[LexemeIDs.Less] = 1,
	[LexemeIDs.GreaterEqual] = 1,
	[LexemeIDs.Greater] = 1,
	[LexemeIDs.NotEqual] = 1,
}

type Parser = {
	__index: Parser,
	new: (lexemes: Types.Lexemes) -> Parser,

	lexemes: Types.Lexemes,
	len: number,
	pos: number,

	Peek: (self: Parser, amount: number) -> string,
	Look: (self: Parser, amount: number) -> Types.Lexeme?,
	Consume: (self: Parser) -> (),
	ParseFactor: (self: Parser) -> Types.ASTNode,
	ParseBinExp: (self: Parser, min: number) -> Types.ASTNode,
	ParseExpression: (self: Parser) -> Types.ASTNode,
	ParseCall: (self: Parser, callTarget: Types.Lexeme?) -> Types.ASTNode,
	ParseTargetedCall: (self: Parser) -> Types.ASTNode,
	ParseNext: (self: Parser) -> Types.ASTNode?,
	Begin: (self: Parser) -> Types.Result<Types.ASTNode>,
}

local Parser = {} :: Parser
Parser.__index = Parser

local function node(id: string, data: Types.ASTData, children: Types.ASTChildren?): Types.ASTNode
	return {
		id = id,
		data = data,
		children = children,
	}
end

local function nodeUnexp(lexeme: Types.Lexeme?): Types.ASTNode
	local id = if lexeme then lexeme.id else "__Missing"
	local data = if lexeme then lexeme.data else ""
	return node(ASTNodeIDs.Unexpected, `{id} ({data})`)
end

function Parser.new(lexemes: Types.Lexemes): Parser
	local self = (setmetatable({}, Parser) :: any) :: Parser

	self.lexemes = lexemes
	self.len = #lexemes
	self.pos = 1

	return self
end

function Parser:Peek(amount: number): string
	local lexeme = self:Look(amount)
	if not lexeme then
		return LexemeIDs.UnexpectedEof
	end

	return lexeme.id
end

function Parser:Look(amount: number): Types.Lexeme?
	local nextPos = self.pos + amount
	if nextPos > self.len then
		return nil
	end

	return self.lexemes[nextPos]
end

function Parser:Consume()
	self.pos += 1
end

function Parser:ParseFactor(): Types.ASTNode
	local id = self:Peek(0)

	if id == LexemeIDs.StartParen then
		self:Consume()
		local res = self:ParseBinExp(0)

		if self:Peek(0) ~= LexemeIDs.EndParen then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()

		return res
	elseif id == LexemeIDs.Number then
		local lexeme = self:Look(0) :: Types.Lexeme
		self:Consume()
		return node(ASTNodeIDs.Number, tonumber(lexeme.data) :: number)
	end

	return nodeUnexp(self:Look(0))
end

function Parser:ParseBinExp(min: number): Types.ASTNode
	local res = self:ParseFactor()
	local id = self:Peek(0)

	while PREC[id] and PREC[id] >= min do
		local nextMin = PREC[id] + ASSOC[id]
		local operator = self:Peek(0)
		self:Consume()
		id = self:Peek(0)
		res = node(ASTNodeIDs.BinExp, operator, {
			left = res,
			right = self:ParseBinExp(nextMin),
		})
	end

	return res
end

function Parser:ParseExpression(): Types.ASTNode
	local id = self:Peek(0)
	if id == LexemeIDs.UnexpectedEof then
		return nodeUnexp(nil) -- We know this will be nil here
	end

	local lexeme = self:Look(0) :: Types.Lexeme
	if id == LexemeIDs.String then
		self:Consume()
		return node(ASTNodeIDs.String, lexeme.data)
	elseif id == LexemeIDs.Identifier then
		local isTrue = lexeme.data == "true"
		if isTrue or lexeme.data == "false" then -- TODO: Handle BinExp with booleans
			self:Consume()
			return node(ASTNodeIDs.Bool, isTrue)
		end
	elseif id == LexemeIDs.Number then
		return self:ParseBinExp(0)
	end

	return nodeUnexp(lexeme)
end

function Parser:ParseCall(callTarget: Types.Lexeme?): Types.ASTNode
	local target = if callTarget then node(ASTNodeIDs.String, callTarget.data) else nil

	local callName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Starting parenthesis

	local earlyExitId = self:Peek(0)
	if earlyExitId == LexemeIDs.EndParen then
		self:Consume()

		local id = self:Peek(0)
		if id ~= LexemeIDs.NextCall then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()

		return node(ASTNodeIDs.Call, callName.data, {
			target = target,
			args = {},
		})
	end

	local args = { self:ParseExpression() }
	while self:Peek(0) == LexemeIDs.NextArg do
		self:Consume()
		table.insert(args, self:ParseExpression())
	end

	local exitId = self:Peek(0)
	if exitId ~= LexemeIDs.EndParen then
		return nodeUnexp(self:Look(0))
	end
	self:Consume()

	local nextCallId = self:Peek(0)
	if nextCallId ~= LexemeIDs.NextCall then
		return nodeUnexp(self:Look(0))
	end
	self:Consume()

	return node(ASTNodeIDs.Call, callName.data, {
		target = target,
		args = args,
	})
end

function Parser:ParseTargetedCall(): Types.ASTNode
	local targetName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Arrow

	local id = self:Peek(0)
	if id == LexemeIDs.Identifier then
		local nextId = self:Peek(1)

		if nextId == LexemeIDs.StartParen then
			return self:ParseCall(targetName)
		end

		return nodeUnexp(self:Look(1))
	end

	return nodeUnexp(self:Look(0))
end

function Parser:ParseNext(): Types.ASTNode?
	local id = self:Peek(0)

	if id == LexemeIDs.Eof then
		return nil
	elseif id == LexemeIDs.Identifier then
		local nextId = self:Peek(1)

		if nextId == LexemeIDs.Arrow then
			return self:ParseTargetedCall()
		elseif nextId == LexemeIDs.StartParen then
			return self:ParseCall(nil)
		end

		return nodeUnexp(self:Look(1))
	end

	return nodeUnexp(self:Look(0))
end

function Parser:Begin(): Types.Result<Types.ASTNode>
	local children = {}

	while true do
		local nextNode = self:ParseNext()
		if not nextNode then
			break
		end

		if nextNode.id == ASTNodeIDs.Unexpected then
			return {
				ok = false,
				err = `parsed unexpected lexeme "{nextNode.data}"`,
			}
		end

		table.insert(children, nextNode)
	end

	return {
		ok = true,
		data = node(ASTNodeIDs.Root, "", children),
	}
end

return Parser
