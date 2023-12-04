local LexemeIDs = require(script.Parent:WaitForChild("LexemeIDs"))
local Types = require(script.Parent.Parent:WaitForChild("Types"))

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

type Lexer = {
	__index: Lexer,
	new: (source: string) -> Lexer,

	source: string,
	len: number,
	pos: number,

	Peek: (self: Lexer, amount: number) -> string?,
	Consume: (self: Lexer) -> (),
	ReadString: (self: Lexer) -> Types.Lexeme,
	ReadNumber: (self: Lexer, negative: boolean) -> Types.Lexeme,
	ReadIdentifier: (self: Lexer) -> Types.Lexeme,
	ReadNext: (self: Lexer) -> Types.Lexeme,
	Begin: (self: Lexer) -> Types.Result<Types.Lexemes>,
}

local Lexer = {} :: Lexer
Lexer.__index = Lexer

local function isWhitespace(input: string?): boolean
	return WHITESPACE[input] == true
end

local function isNumerical(input: string?): boolean
	return NUMBERS[input] == true
end

local function isIdentifier(input: string?): boolean
	return string.match(input or "", "%a") ~= nil or input == "_"
end

local function new(id: string, data: string?): Types.Lexeme
	return {
		id = id,
		data = data or "",
	}
end

function Lexer.new(source: string): Lexer
	local self = (setmetatable({}, Lexer) :: any) :: Lexer

	self.source = source
	self.len = string.len(source)
	self.pos = 1

	return self
end

function Lexer:Peek(amount: number): string?
	local nextPos = self.pos + amount
	if nextPos > self.len then
		return nil
	end

	return string.sub(self.source, nextPos, nextPos)
end

function Lexer:Consume()
	self.pos += 1
end

function Lexer:ReadString(): Types.Lexeme
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
	return new(LexemeIDs.Str, final)
end

function Lexer:ReadNumber(negative: boolean): Types.Lexeme
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

	return new(LexemeIDs.Num, final)
end

function Lexer:ReadIdentifier(): Types.Lexeme
	local final = ""

	while true do
		local char = self:Peek(0)
		if not char or not isIdentifier(char) then
			break -- Will never happen on first iteration
		end

		final ..= char
		self:Consume()
	end

	return new(LexemeIDs.Id, final)
end

function Lexer:ReadNext(): Types.Lexeme
	local char = self:Peek(0)

	if char == nil then
		return new(LexemeIDs.Eof)
	elseif char == "-" then
		local nextChar = self:Peek(1)

		if nextChar == ">" then
			self:Consume()
			self:Consume()
			return new(LexemeIDs.Arr, char .. nextChar)
		elseif isNumerical(nextChar) then
			return self:ReadNumber(true)
		end

		self:Consume()
		return new(LexemeIDs.Sub, char)
	elseif char == "=" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIDs.Eq, char .. nextChar)
		end

		return new(LexemeIDs.UnexpChar, char)
	elseif char == "<" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIDs.LessEq, char .. nextChar)
		end

		self:Consume()
		return new(LexemeIDs.Less, char)
	elseif char == ">" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIDs.GreatEq, char .. nextChar)
		end

		self:Consume()
		return new(LexemeIDs.Great, char)
	elseif char == "~" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return new(LexemeIDs.NotEq, char .. nextChar)
		end

		return new(LexemeIDs.UnexpChar, char)
	elseif char == '"' then
		return self:ReadString()
	elseif char == "+" then
		self:Consume()
		return new(LexemeIDs.Add, char)
	elseif char == "/" then
		self:Consume()
		return new(LexemeIDs.Div, char)
	elseif char == "*" then
		self:Consume()
		return new(LexemeIDs.Mul, char)
	elseif char == "%" then
		self:Consume()
		return new(LexemeIDs.Mod, char)
	elseif char == "^" then
		self:Consume()
		return new(LexemeIDs.Pow, char)
	elseif char == ";" then
		self:Consume()
		return new(LexemeIDs.NxCall, char)
	elseif char == "," then
		self:Consume()
		return new(LexemeIDs.NxArg, char)
	elseif char == "(" then
		self:Consume()
		return new(LexemeIDs.LParen, char)
	elseif char == ")" then
		self:Consume()
		return new(LexemeIDs.RParen, char)
	elseif isNumerical(char) then
		return self:ReadNumber(false)
	elseif isIdentifier(char) then
		return self:ReadIdentifier()
	elseif isWhitespace(char) then
		self:Consume()
		return new(LexemeIDs.None, char)
	end

	return new(LexemeIDs.UknChar, char)
end

function Lexer:Begin(): Types.Result<Types.Lexemes>
	local lexemes = {}

	while true do
		local lexeme = self:ReadNext()

		if lexeme.id == LexemeIDs.None then
			continue
		elseif lexeme.id == LexemeIDs.UnexpChar then
			return {
				ok = false,
				err = `unexpected character "{lexeme.data}"`,
			}
		elseif lexeme.id == LexemeIDs.UknChar then
			return {
				ok = false,
				err = `unknown character "{lexeme.data}"`,
			}
		end

		table.insert(lexemes, lexeme)

		if lexeme.id == LexemeIDs.Eof then
			break
		end
	end

	return {
		ok = true,
		data = lexemes,
	}
end

return Lexer
