local ASTNodeIds = require(script.Parent:WaitForChild("ASTNodeIds"))
local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))
local LexemeIds = require(script.Parent:WaitForChild("LexemeIds"))

local LEXEME_LIMIT = 800
local THUNK_LIMIT = 30

local PREC = table.freeze({
	[LexemeIds.Pow] = 40,
	[LexemeIds.Mod] = 30,
	[LexemeIds.Mul] = 30,
	[LexemeIds.Div] = 30,
	[LexemeIds.Add] = 20,
	[LexemeIds.Sub] = 20,
	[LexemeIds.Eq] = 10,
	[LexemeIds.LessEq] = 10,
	[LexemeIds.Less] = 10,
	[LexemeIds.GreatEq] = 10,
	[LexemeIds.Great] = 10,
	[LexemeIds.NotEq] = 10,
})

local ASSOC = table.freeze({
	[LexemeIds.Pow] = 0,
	[LexemeIds.Mod] = 1,
	[LexemeIds.Mul] = 1,
	[LexemeIds.Div] = 1,
	[LexemeIds.Add] = 1,
	[LexemeIds.Sub] = 1,
	[LexemeIds.Eq] = 1,
	[LexemeIds.LessEq] = 1,
	[LexemeIds.Less] = 1,
	[LexemeIds.GreatEq] = 1,
	[LexemeIds.Great] = 1,
	[LexemeIds.NotEq] = 1,
})

local RESOLVE_ID = table.freeze({
	["true"] = table.freeze({
		id = ASTNodeIds.Bool,
		value = true,
	}),
	["false"] = table.freeze({
		id = ASTNodeIds.Bool,
		value = false,
	}),
})

local classPrototype = {}
local classMetatable = { __index = classPrototype }
export type Identity = typeof(setmetatable(
	{} :: {
		_lexemes: ChainTypes.Lexemes,
		_len: number,
		_pos: number,
	},
	classMetatable
))

local function node(id: string, data: ChainTypes.ASTData, children: ChainTypes.ASTChildren?): ChainTypes.ASTNode
	return {
		id = id,
		data = data,
		children = children,
	}
end

local function nodeUnexp(lexeme: ChainTypes.Lexeme?): ChainTypes.ASTNode
	local id = if lexeme then lexeme.id else "__UnexpEof"
	local data = if lexeme then lexeme.data else ""
	return node(ASTNodeIds.Unexp, `{id} ({data})`)
end

local function constructor(lexemes: ChainTypes.Lexemes): Identity
	local self = setmetatable({}, classMetatable)

	self._lexemes = lexemes
	self._len = #lexemes
	self._pos = 1

	return self
end

function classPrototype.Peek(self: Identity, amount: number): string
	local lexeme = self:Look(amount)
	if not lexeme then
		return LexemeIds.Eof
	end

	return lexeme.id
end

function classPrototype.Look(self: Identity, amount: number): ChainTypes.Lexeme?
	local nextPos = self._pos + amount
	if nextPos > self._len then
		return nil
	end

	return self._lexemes[nextPos]
end

function classPrototype.Consume(self: Identity)
	self._pos += 1
end

function classPrototype.ParseFactor(self: Identity): ChainTypes.ASTNode
	local id = self:Peek(0)

	if id == LexemeIds.LParen then
		self:Consume()
		local res = self:ParseBinExp(0)

		if self:Peek(0) ~= LexemeIds.RParen then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()

		return res
	elseif id == LexemeIds.Num then
		local lexeme = self:Look(0) :: ChainTypes.Lexeme
		self:Consume()
		return node(ASTNodeIds.Num, tonumber(lexeme.data) :: number)
	elseif id == LexemeIds.Id then
		local lexeme = self:Look(0) :: ChainTypes.Lexeme
		local resolved = RESOLVE_ID[lexeme.data]

		if resolved then
			self:Consume()
			return node(resolved.id, resolved.value)
		end

		return nodeUnexp(lexeme)
	end

	return nodeUnexp(self:Look(0))
end

function classPrototype.ParseBinExp(self: Identity, min: number): ChainTypes.ASTNode
	local result = self:ParseFactor()
	local id = self:Peek(0)

	while PREC[id] and PREC[id] >= min do
		local nextMin = PREC[id] + ASSOC[id]
		local operator = self:Peek(0)
		self:Consume()

		result = node(ASTNodeIds.BinExp, operator, {
			left = result,
			right = self:ParseBinExp(nextMin),
		})

		id = self:Peek(0)
	end

	return result
end

function classPrototype.ParseExpression(self: Identity): ChainTypes.ASTNode
	local id = self:Peek(0)
	if id == LexemeIds.Eof then
		return nodeUnexp(nil) -- We know the lexeme will be nil here, UnexpEof
	end

	local lexeme = self:Look(0) :: ChainTypes.Lexeme
	if id == LexemeIds.Str then
		self:Consume()
		return node(ASTNodeIds.Str, lexeme.data)
	elseif id == LexemeIds.Num or id == LexemeIds.LParen then
		return self:ParseBinExp(0)
	end

	if id == LexemeIds.LBrack then
		self:Consume()

		local children = {}
		while true do
			if self:Peek(0) == LexemeIds.RBrack then
				self:Consume()
				return node(ASTNodeIds.Thunk, "", children)
			end

			local nextNode = self:ParseGeneralContext()
			if not nextNode then
				return nodeUnexp(nil) -- We know the lexeme will be nil here, UnexpEof
			end

			table.insert(children, nextNode)
		end

		return nodeUnexp(self:Look(0))
	end

	if id == LexemeIds.Id then
		-- TODO: Could be binexp or call

		return self:ParseBinExp(0)
	end

	return nodeUnexp(lexeme)
end

function classPrototype.ParseCall(self: Identity, callTarget: ChainTypes.Lexeme?): ChainTypes.ASTNode
	local target = if callTarget then node(ASTNodeIds.Str, callTarget.data) else nil

	local callName = self:Look(0) :: ChainTypes.Lexeme
	self:Consume()

	self:Consume() -- Starting parenthesis

	local earlyExitId = self:Peek(0)
	if earlyExitId == LexemeIds.RParen then
		self:Consume()

		local id = self:Peek(0)
		if id ~= LexemeIds.Semicolon then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()

		return node(ASTNodeIds.Call, callName.data, {
			target = target,
			args = {},
		})
	end

	local args = { self:ParseExpression() }
	while self:Peek(0) == LexemeIds.Comma do
		self:Consume()
		table.insert(args, self:ParseExpression())
	end

	local exitId = self:Peek(0)
	if exitId ~= LexemeIds.RParen then
		return nodeUnexp(self:Look(0))
	end
	self:Consume()

	local nextCallId = self:Peek(0)
	if nextCallId ~= LexemeIds.Semicolon then
		return nodeUnexp(self:Look(0))
	end
	self:Consume()

	return node(ASTNodeIds.Call, callName.data, {
		target = target,
		args = args,
	})
end

function classPrototype.ParseTargetedCall(self: Identity): ChainTypes.ASTNode
	local targetName = self:Look(0) :: ChainTypes.Lexeme
	self:Consume()

	self:Consume() -- Arrow

	local id = self:Peek(0)
	if id == LexemeIds.Id then
		local nextId = self:Peek(1)

		if nextId == LexemeIds.LParen then
			return self:ParseCall(targetName)
		end

		return nodeUnexp(self:Look(1))
	end

	return nodeUnexp(self:Look(0))
end

function classPrototype.ParseGeneralContext(self: Identity): ChainTypes.ASTNode?
	local id = self:Peek(0)

	if id == LexemeIds.Eof then
		return nil
	elseif id == LexemeIds.Id then
		local nextId = self:Peek(1)

		if nextId == LexemeIds.Arrow then
			return self:ParseTargetedCall()
		elseif nextId == LexemeIds.LParen then
			return self:ParseCall(nil)
		end

		return nodeUnexp(self:Look(1))
	end

	return nodeUnexp(self:Look(0))
end

function classPrototype.Begin(self: Identity): ChainTypes.Result<ChainTypes.ASTNode>
	if self._len > LEXEME_LIMIT then
		return {
			ok = false,
			err = `parser received more than {LEXEME_LIMIT} maximum input lexemes`,
		}
	end

	local numBrackets = 0
	for _, lexeme in self._lexemes do
		if lexeme.id == LexemeIds.LBrack or LexemeIds.RBrack then
			numBrackets += 1
		end
	end

	if numBrackets * 0.5 > THUNK_LIMIT then
		return {
			ok = false,
			err = `parser received more than {THUNK_LIMIT} maximum thunks`,
		}
	end

	local children = {}
	while true do
		local nextNode = self:ParseGeneralContext()
		if not nextNode then
			break
		end

		if nextNode.id == ASTNodeIds.Unexp then
			return {
				ok = false,
				err = `parsed unexpected lexeme "{nextNode.data}"`,
			}
		end

		table.insert(children, nextNode)
	end

	return {
		ok = true,
		data = node(ASTNodeIds.Root, "", children),
	}
end

return {
	new = constructor,
}
