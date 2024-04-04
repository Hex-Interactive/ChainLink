local ChainTypes = require(script.Parent:WaitForChild("ChainTypes"))
local LexemeIds = require(script.Parent:WaitForChild("LexemeIds"))

local CHARACTER_LIMIT = 1000

local NUMBERS = table.freeze({
	["0"] = true,
	["1"] = true,
	["2"] = true,
	["3"] = true,
	["4"] = true,
	["5"] = true,
	["6"] = true,
	["7"] = true,
	["8"] = true,
	["9"] = true,
})

local WHITESPACE = table.freeze({
	[""] = true,
	[" "] = true,
	["\n"] = true,
	["\t"] = true,
})

local classPrototype = {}
local classMetatable = { __index = classPrototype }
export type Identity = typeof(setmetatable(
	{} :: {
		_source: string,
		_len: number,
		_pos: number,
	},
	classMetatable
))

local function isWhitespace(input: string?): boolean
	return WHITESPACE[input] == true
end

local function isNumerical(input: string?): boolean
	return NUMBERS[input] == true
end

local function isIdentifier(input: string?): boolean
	return string.match(input or "", "%a") ~= nil or input == "_"
end

local function new(id: string, data: string?): ChainTypes.Lexeme
	return {
		id = id,
		data = data or "",
	}
end

local function constructor(source: string): Identity
	local self = setmetatable({}, classMetatable)

	self._source = source
	self._len = string.len(source)
	self._pos = 1

	return self
end

function classPrototype.Peek(self: Identity, amount: number): string?
	local nextPos = self._pos + amount
	if nextPos > self._len then
		return nil
	end

	return string.sub(self._source, nextPos, nextPos)
end

function classPrototype.Consume(self: Identity)
	self._pos += 1
end

function classPrototype.ReadString(self: Identity): ChainTypes.Lexeme
	local final = ""

	local prev = nil
	self:Consume()
	local current = self:Peek(0)

	while true do
		if not current or (current == '"' and prev ~= "\\") then
			break
		end

		local nextChar = self:Peek(1)
		if not (current == "\\" and nextChar == '"') then
			final ..= current :: string
		end

		prev = current
		self:Consume()
		current = nextChar
	end

	self:Consume()
	return new(LexemeIds.Str, final)
end

function classPrototype.ReadNumber(self: Identity, negative: boolean): ChainTypes.Lexeme
	local final = if negative then "-" else ""
	if negative then
		self:Consume()
	end

	while true do
		local char = self:Peek(0)
		if not char or not (isNumerical(char) or char == ".") then
			break -- Will never happen on first iteration
		end

		final ..= char
		self:Consume()
	end

	return new(LexemeIds.Num, final)
end

function classPrototype.ReadIdentifier(self: Identity): ChainTypes.Lexeme
	local final = ""

	while true do
		local char = self:Peek(0)
		if not char or not isIdentifier(char) then
			break -- Will never happen on first iteration
		end

		final ..= char
		self:Consume()
	end

	return new(LexemeIds.Id, final)
end

function classPrototype.ReadNext(self: Identity): ChainTypes.Lexeme
	local char = self:Peek(0)

	if char == nil then
		return new(LexemeIds.Eof)
	elseif char == "-" then
		local nextChar = self:Peek(1)

		if nextChar == ">" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.Arrow, char .. nextChar)
		elseif isNumerical(nextChar) then
			return self:ReadNumber(true)
		end

		self:Consume()
		return new(LexemeIds.Sub, char)
	elseif char == "=" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.Eq, char .. nextChar)
		end

		return new(LexemeIds.UnexpChar, char)
	elseif char == "<" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.LessEq, char .. nextChar)
		end

		self:Consume()
		return new(LexemeIds.Less, char)
	elseif char == ">" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.GreatEq, char .. nextChar)
		end

		self:Consume()
		return new(LexemeIds.Great, char)
	elseif char == "~" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.NotEq, char .. nextChar)
		end

		return new(LexemeIds.UnexpChar, char)
	elseif char == "&" then
		local nextChar = self:Peek(1)

		if nextChar == "&" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.And, char .. nextChar)
		end

		return new(LexemeIds.UnexpChar, char)
	elseif char == "|" then
		local nextChar = self:Peek(1)

		if nextChar == "|" then
			self:Consume()
			self:Consume()
			return new(LexemeIds.Or, char .. nextChar)
		end

		return new(LexemeIds.UnexpChar, char)
	elseif char == "!" then
		self:Consume()
		return new(LexemeIds.Not, char)
	elseif char == '"' then
		return self:ReadString()
	elseif char == "+" then
		self:Consume()
		return new(LexemeIds.Add, char)
	elseif char == "/" then
		self:Consume()
		return new(LexemeIds.Div, char)
	elseif char == "*" then
		self:Consume()
		return new(LexemeIds.Mul, char)
	elseif char == "%" then
		self:Consume()
		return new(LexemeIds.Mod, char)
	elseif char == "^" then
		self:Consume()
		return new(LexemeIds.Pow, char)
	elseif char == ";" then
		self:Consume()
		return new(LexemeIds.Semicolon, char)
	elseif char == "," then
		self:Consume()
		return new(LexemeIds.Comma, char)
	elseif char == "(" then
		self:Consume()
		return new(LexemeIds.LParen, char)
	elseif char == ")" then
		self:Consume()
		return new(LexemeIds.RParen, char)
	elseif char == "[" then
		self:Consume()
		return new(LexemeIds.LBrack, char)
	elseif char == "]" then
		self:Consume()
		return new(LexemeIds.RBrack, char)
	elseif isNumerical(char) then
		return self:ReadNumber(false)
	elseif isIdentifier(char) then
		return self:ReadIdentifier()
	elseif isWhitespace(char) then
		self:Consume()
		return new(LexemeIds.None, char)
	end

	return new(LexemeIds.UknChar, char)
end

function classPrototype.Begin(self: Identity): ChainTypes.Result<ChainTypes.Lexemes>
	if self._len > CHARACTER_LIMIT then
		return {
			ok = false,
			err = `lexer received more than {CHARACTER_LIMIT} maximum input characters`,
		}
	end

	local lexemes = {}

	while true do
		local lexeme = self:ReadNext()

		if lexeme.id == LexemeIds.None then
			continue
		elseif lexeme.id == LexemeIds.UnexpChar then
			return {
				ok = false,
				err = `unexpected character "{lexeme.data}"`,
			}
		elseif lexeme.id == LexemeIds.UknChar then
			return {
				ok = false,
				err = `unknown character "{lexeme.data}"`,
			}
		end

		table.insert(lexemes, lexeme)

		if lexeme.id == LexemeIds.Eof then
			break
		end
	end

	return {
		ok = true,
		data = lexemes,
	}
end

return {
	new = constructor,
}
