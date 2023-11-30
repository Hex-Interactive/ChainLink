local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Lexemes = require(script.Parent:WaitForChild("Lexemes"))

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

type Result = {
	ok: boolean,
	err: string?,
	tokens: { [number]: Types.Token }?,
}

type Lexer = {
	__index: Lexer,
	new: (source: string) -> Lexer,

	source: string,
	len: number,
	pos: number,

	Peek: (self: Lexer, amount: number) -> string?,
	Consume: (self: Lexer) -> (),
	ReadString: (self: Lexer) -> Types.Token,
	ReadNumber: (self: Lexer, negative: boolean) -> Types.Token,
	ReadIdentifier: (self: Lexer) -> Types.Token,
	ReadNext: (self: Lexer) -> Types.Token,
	GenerateTokens: (self: Lexer) -> Result,
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

function Lexer:ReadString(): Types.Token
	return { Lexemes.Unknown, self:Peek(1) :: string } -- TODO: Handle strings
end

function Lexer:ReadNumber(negative: boolean): Types.Token
	local final = if negative then "-" else ""
	if negative then
		self:Consume()
	end

	while true do
		local char = self:Peek(0)
		if not char or not isNumerical(char) then
			break -- Will never happen on first iteration
		end

		final ..= char
		self:Consume()
	end

	return { Lexemes.Number, final }
end

function Lexer:ReadIdentifier(): Types.Token
	return { Lexemes.Unknown, self:Peek(1) :: string } -- TODO: Handle identifiers
end

function Lexer:ReadNext(): Types.Token
	local char = self:Peek(0)

	if char == nil then
		return { Lexemes.Eof, "" }
	elseif char == "-" then
		local nextChar = self:Peek(1)

		if nextChar == ">" then
			self:Consume()
			self:Consume()
			return { Lexemes.Arrow, char .. nextChar }
		elseif isNumerical(nextChar) then
			return self:ReadNumber(true)
		end

		self:Consume()
		return { Lexemes.Subtract, char }
	elseif char == "=" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { Lexemes.Equal, char .. nextChar }
		end

		return { Lexemes.OutOfOrder, char }
	elseif char == "<" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { Lexemes.LessEqual, char .. nextChar }
		end

		self:Consume()
		return { Lexemes.Less, char }
	elseif char == ">" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { Lexemes.GreaterEqual, char .. nextChar }
		end

		self:Consume()
		return { Lexemes.Greater, char }
	elseif char == "~" then
		local nextChar = self:Peek(1)

		if nextChar == "=" then
			self:Consume()
			self:Consume()
			return { Lexemes.NotEqual, char .. nextChar }
		end

		return { Lexemes.OutOfOrder, char }
	elseif char == '"' then
		return self:ReadString()
	elseif char == "+" then
		self:Consume()
		return { Lexemes.Add, char }
	elseif char == "/" then
		self:Consume()
		return { Lexemes.Divide, char }
	elseif char == "*" then
		self:Consume()
		return { Lexemes.Multiply, char }
	elseif char == "%" then
		self:Consume()
		return { Lexemes.Mod, char }
	elseif char == "^" then
		self:Consume()
		return { Lexemes.Pow, char }
	elseif char == ";" then
		self:Consume()
		return { Lexemes.NextExp, char }
	elseif char == "," then
		self:Consume()
		return { Lexemes.NextArg, char }
	elseif char == "(" or char == ")" then
		self:Consume()
		return { Lexemes.Paren, char }
	elseif isNumerical(char) then
		return self:ReadNumber(false)
	elseif isIdentifier(char) then
		return self:ReadIdentifier()
	elseif isWhitespace(char) then
		self:Consume()
	end

	return { Lexemes.Unknown, char }
end

function Lexer:GenerateTokens(): Result
	local tokens = {}

	while true do
		local token = self:ReadNext()

		if token[1] == Lexemes.Eof then
			break
		elseif token[1] == Lexemes.OutOfOrder then
			return {
				ok = false,
				err = `out of order character "{token[2]}"`,
			}
		elseif token[1] == Lexemes.Unknown then
			return {
				ok = false,
				err = `unknown character "{token[2]}"`,
			}
		end

		table.insert(tokens, token)
	end

	return {
		ok = true,
		tokens = tokens,
	}
end

return Lexer
