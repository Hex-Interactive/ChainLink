local ASTNodeIds = require(script.Parent:WaitForChild("ASTNodeIds"))
local LexemeIds = require(script.Parent:WaitForChild("LexemeIds"))
local Types = require(script.Parent:WaitForChild("Types"))

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
	[LexemeIds.And] = 10,
	[LexemeIds.Or] = 10,
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
	[LexemeIds.And] = 1,
	[LexemeIds.Or] = 1,
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

local Parser = {}
local metatable = { __index = Parser }
export type Identity = typeof(setmetatable(
	{} :: {
		_lexemes: Types.Lexemes,
		_len: number,
		_pos: number,
	},
	metatable
))

local function node(id: string, data: Types.Type?, children: Types.ASTChildren?): Types.ASTNode
	return {
		id = id,
		data = if data == nil then "" else data, -- Empty string used for "no data"
		children = children,
	}
end

local function nodeUnexp(lexeme: Types.Lexeme?): Types.ASTNode
	local id = if lexeme then lexeme.id else "__UnexpEof"
	local data = if lexeme then lexeme.data else "__Err"
	return node(ASTNodeIds.Unexp, `{id} ({data})`)
end

local function constructor(lexemes: Types.Lexemes): Identity
	local self = setmetatable({}, metatable)

	self._lexemes = lexemes
	self._len = #lexemes
	self._pos = 1

	return self
end

function Parser.Peek(self: Identity, amount: number): string
	local lexeme = self:Look(amount)
	if not lexeme then
		return LexemeIds.Eof
	end

	return lexeme.id
end

function Parser.Look(self: Identity, amount: number): Types.Lexeme?
	local nextPos = self._pos + amount
	if nextPos > self._len then
		return nil
	end

	return self._lexemes[nextPos]
end

function Parser.Consume(self: Identity)
	self._pos += 1
end

function Parser.ParseFactor(self: Identity): Types.ASTNode
	local preOpId = self:Peek(0)
	if preOpId == LexemeIds.Not then
		self:Consume()
		return node(ASTNodeIds.Not, nil, self:ParseFactor())
	end

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
		local lexeme = self:Look(0) :: Types.Lexeme
		self:Consume()
		return node(ASTNodeIds.Num, tonumber(lexeme.data) :: number)
	elseif id == LexemeIds.Id then
		local result = self:ParseCallLike(true)
		if result.id == ASTNodeIds.Call then
			return result
		end

		local lexeme = self:Look(0) :: Types.Lexeme
		local resolved = RESOLVE_ID[lexeme.data]
		if resolved then
			self:Consume()
			return node(resolved.id, resolved.value)
		end

		return nodeUnexp(lexeme)
	end

	return nodeUnexp(self:Look(0))
end

function Parser.ParseBinExp(self: Identity, min: number): Types.ASTNode
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

function Parser.ParseExpression(self: Identity): Types.ASTNode
	local id = self:Peek(0)
	if id == LexemeIds.Eof then
		return nodeUnexp(nil) -- We know the lexeme will be nil here, UnexpEof
	end

	local lexeme = self:Look(0) :: Types.Lexeme
	if id == LexemeIds.Str then
		self:Consume()
		return node(ASTNodeIds.Str, lexeme.data)
	elseif id == LexemeIds.Num or id == LexemeIds.Id or id == LexemeIds.LParen or id == LexemeIds.Not then
		return self:ParseBinExp(0)
	elseif id == LexemeIds.LBrack then
		self:Consume()

		local children = {}
		while true do
			if self:Peek(0) == LexemeIds.RBrack then
				self:Consume()
				return node(ASTNodeIds.Thunk, nil, children)
			end

			local nextNode = self:ParseGeneralContext()
			if not nextNode then
				return nodeUnexp(nil) -- We know the lexeme will be nil here, UnexpEof
			end

			table.insert(children, nextNode)
		end

		return nodeUnexp(self:Look(0))
	end

	return nodeUnexp(lexeme)
end

function Parser.ParseCall(self: Identity, expr: boolean, callTarget: Types.Lexeme?): Types.ASTNode
	local target = if callTarget then node(ASTNodeIds.Str, callTarget.data) else nil

	local callName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Starting parenthesis

	local earlyExitId = self:Peek(0)
	if earlyExitId == LexemeIds.RParen then
		self:Consume()

		if not expr then
			local id = self:Peek(0)
			if id ~= LexemeIds.Semicolon then
				return nodeUnexp(self:Look(0))
			end
			self:Consume()
		end

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

	if not expr then
		local semicolonId = self:Peek(0)
		if semicolonId ~= LexemeIds.Semicolon then
			return nodeUnexp(self:Look(0))
		end
		self:Consume()
	end

	return node(ASTNodeIds.Call, callName.data, {
		target = target,
		args = args,
	})
end

function Parser.ParseTargetedCall(self: Identity, expr: boolean): Types.ASTNode
	local targetName = self:Look(0) :: Types.Lexeme
	self:Consume()

	self:Consume() -- Arrow

	local id = self:Peek(0)
	if id == LexemeIds.Id then
		local nextId = self:Peek(1)

		if nextId == LexemeIds.LParen then
			return self:ParseCall(expr, targetName)
		end

		return nodeUnexp(self:Look(1))
	end

	return nodeUnexp(self:Look(0))
end

function Parser.ParseCallLike(self: Identity, expr: boolean): Types.ASTNode
	local nextId = self:Peek(1)

	if nextId == LexemeIds.Arrow then
		return self:ParseTargetedCall(expr)
	elseif nextId == LexemeIds.LParen then
		return self:ParseCall(expr)
	end

	return nodeUnexp(self:Look(1))
end

function Parser.ParseGeneralContext(self: Identity): Types.ASTNode?
	local id = self:Peek(0)

	if id == LexemeIds.Eof then
		return nil
	elseif id == LexemeIds.Id then
		return self:ParseCallLike(false)
	end

	return nodeUnexp(self:Look(0))
end

function Parser.Begin(self: Identity): Types.Result<Types.ASTNode>
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
		data = node(ASTNodeIds.Root, nil, children),
	}
end

return {
	new = constructor,
}
