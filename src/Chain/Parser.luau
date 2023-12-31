local ASTNodeIDs = require(script.Parent:WaitForChild("ASTNodeIDs"))
local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

local PREC = table.freeze({
	[LexemeIDs.Pow] = 40,
	[LexemeIDs.Mod] = 30,
	[LexemeIDs.Mul] = 30,
	[LexemeIDs.Div] = 30,
	[LexemeIDs.Add] = 20,
	[LexemeIDs.Sub] = 20,
	[LexemeIDs.Eq] = 10,
	[LexemeIDs.LessEq] = 10,
	[LexemeIDs.Less] = 10,
	[LexemeIDs.GreatEq] = 10,
	[LexemeIDs.Great] = 10,
	[LexemeIDs.NotEq] = 10,
})
local ASSOC = table.freeze({
	[LexemeIDs.Pow] = 0,
	[LexemeIDs.Mod] = 1,
	[LexemeIDs.Mul] = 1,
	[LexemeIDs.Div] = 1,
	[LexemeIDs.Add] = 1,
	[LexemeIDs.Sub] = 1,
	[LexemeIDs.Eq] = 1,
	[LexemeIDs.LessEq] = 1,
	[LexemeIDs.Less] = 1,
	[LexemeIDs.GreatEq] = 1,
	[LexemeIDs.Great] = 1,
	[LexemeIDs.NotEq] = 1,
})
local RESOLVE_ID = table.freeze({
	["true"] = table.freeze({
		id = ASTNodeIDs.Bool,
		value = true,
	}),
	["false"] = table.freeze({
		id = ASTNodeIDs.Bool,
		value = false,
	}),
})

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
	return node(ASTNodeIDs.Unexp, `{id} ({data})`)
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
		return LexemeIDs.UnexpEof
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

	if id == LexemeIDs.LParen then
		self:Consume()
		local res = self:ParseBinExp(0)

		if self:Peek(0) ~= LexemeIDs.RParen then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()

		return res
	elseif id == LexemeIDs.Num then
		local lexeme = self:Look(0) :: Types.Lexeme
		self:Consume()
		return node(ASTNodeIDs.Num, tonumber(lexeme.data) :: number)
	elseif id == LexemeIDs.Id then
		local lexeme = self:Look(0) :: Types.Lexeme
		local resolved = RESOLVE_ID[lexeme.data]
		if resolved then
			self:Consume()
			return node(resolved.id, resolved.value)
		end
	end

	return nodeUnexp(self:Look(0))
end

function Parser:ParseBinExp(min: number): Types.ASTNode
	local result = self:ParseFactor()
	local id = self:Peek(0)

	while PREC[id] and PREC[id] >= min do
		local nextMin = PREC[id] + ASSOC[id]
		local operator = self:Peek(0)
		self:Consume()

		result = node(ASTNodeIDs.BinExp, operator, {
			left = result,
			right = self:ParseBinExp(nextMin),
		})

		id = self:Peek(0)
	end

	return result
end

function Parser:ParseExpression(): Types.ASTNode
	local id = self:Peek(0)
	if id == LexemeIDs.UnexpEof then
		return nodeUnexp(nil) -- We know this will be nil here
	end

	local lexeme = self:Look(0) :: Types.Lexeme
	if id == LexemeIDs.Str then
		self:Consume()
		return node(ASTNodeIDs.Str, lexeme.data)
	elseif id == LexemeIDs.Num or id == LexemeIDs.Id or id == LexemeIDs.LParen then
		return self:ParseBinExp(0)
	end

	return nodeUnexp(lexeme)
end

function Parser:ParseCall(callTarget: Types.Lexeme?): Types.ASTNode
	local target = if callTarget then node(ASTNodeIDs.Str, callTarget.data) else nil

	local callName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Starting parenthesis

	local earlyExitId = self:Peek(0)
	if earlyExitId == LexemeIDs.RParen then
		self:Consume()

		local id = self:Peek(0)
		if id ~= LexemeIDs.NxCall then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()

		return node(ASTNodeIDs.Call, callName.data, {
			target = target,
			args = {},
		})
	end

	local args = { self:ParseExpression() }
	while self:Peek(0) == LexemeIDs.NxArg do
		self:Consume()
		table.insert(args, self:ParseExpression())
	end

	local exitId = self:Peek(0)
	if exitId ~= LexemeIDs.RParen then
		return nodeUnexp(self:Look(0))
	end
	self:Consume()

	local nextCallId = self:Peek(0)
	if nextCallId ~= LexemeIDs.NxCall then
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
	if id == LexemeIDs.Id then
		local nextId = self:Peek(1)

		if nextId == LexemeIDs.LParen then
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
	elseif id == LexemeIDs.Id then
		local nextId = self:Peek(1)

		if nextId == LexemeIDs.Arr then
			return self:ParseTargetedCall()
		elseif nextId == LexemeIDs.LParen then
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

		if nextNode.id == ASTNodeIDs.Unexp then
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
