local LexemeDefs = require(script.Parent:WaitForChild("LexemeDefs"))
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
	Begin: (self: Lexer) -> Types.Result<{ Types.Lexeme }>,
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

local function canParseString(current: string?, prev: string?): boolean
	if not current then
		return false
	end

	if current == '"' then
		return prev == "\\"
	end

	return true
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

	local prev = self:Peek(0)
	self:Consume()
	local current = self:Peek(0)

	while canParseString(current, prev) do
		final ..= current :: string
		prev = current
		self:Consume()
		current = self:Peek(0)
	end

	self:Consume()
	return { LexemeDefs.String, final }
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

	return { LexemeDefs.Number, final }
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

	return { LexemeDefs.Identifier, final }
end

function Lexer:ReadNext(): Types.Lexeme
	local char = self:Peek(0)

	if char == nil then
		return { LexemeDefs.Eof, "" }
	elseif char == "-" then
		local nextChar = self:Peek(1)

		if nextChar == ">" then
			self:Consume()
			self:Consume()
			return { LexemeDefs.Arrow, char .. nextChar }
		elseif isNumerical(nextChar) then
			return self:ReadNumber(true)
		end

		self:Consume()
		return { LexemeDefs.Subtract, char }
	elseif char == "=" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { LexemeDefs.Equal, char .. nextChar }
		end

		return { LexemeDefs.UnexpectedChar, char }
	elseif char == "<" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { LexemeDefs.LessEqual, char .. nextChar }
		end

		self:Consume()
		return { LexemeDefs.Less, char }
	elseif char == ">" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { LexemeDefs.GreaterEqual, char .. nextChar }
		end

		self:Consume()
		return { LexemeDefs.Greater, char }
	elseif char == "~" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { LexemeDefs.NotEqual, char .. nextChar }
		end

		return { LexemeDefs.UnexpectedChar, char }
	elseif char == '"' then
		return self:ReadString()
	elseif char == "+" then
		self:Consume()
		return { LexemeDefs.Add, char }
	elseif char == "/" then
		self:Consume()
		return { LexemeDefs.Divide, char }
	elseif char == "*" then
		self:Consume()
		return { LexemeDefs.Multiply, char }
	elseif char == "%" then
		self:Consume()
		return { LexemeDefs.Mod, char }
	elseif char == "^" then
		self:Consume()
		return { LexemeDefs.Pow, char }
	elseif char == ";" then
		self:Consume()
		return { LexemeDefs.NextExp, char }
	elseif char == "," then
		self:Consume()
		return { LexemeDefs.NextArg, char }
	elseif char == "(" then
		self:Consume()
		return { LexemeDefs.StartParen, char }
	elseif char == ")" then
		self:Consume()
		return { LexemeDefs.EndParen, char }
	elseif isNumerical(char) then
		return self:ReadNumber(false)
	elseif isIdentifier(char) then
		return self:ReadIdentifier()
	elseif isWhitespace(char) then
		self:Consume()
	end

	return { LexemeDefs.UnknownChar, char }
end

function Lexer:Begin(): Types.Result<{ Types.Lexeme }>
	local lexemes = {}

	while true do
		local lexeme = self:ReadNext()

		if lexeme[1] == LexemeDefs.Eof then
			break
		elseif lexeme[1] == LexemeDefs.UnexpectedChar then
			return {
				ok = false,
				err = `unexpected character "{lexeme[2]}"`,
			}
		elseif lexeme[1] == LexemeDefs.UnknownChar then
			return {
				ok = false,
				err = `unknown character "{lexeme[2]}"`,
			}
		end

		table.insert(lexemes, lexeme)
	end

	return {
		ok = true,
		data = lexemes,
	}
end

return Lexer
