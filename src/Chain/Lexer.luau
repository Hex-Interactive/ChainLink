local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Lexemes = require(script.Parent:WaitForChild("Lexemes"))

local WHITESPACE = table.freeze({
	"",
	" ",
	"\n",
	"\t",
})

local Lexer = {}
Lexer.__index = Lexer

function Lexer.new(source: string)
	local self = setmetatable({}, Lexer)

	self.source = source
	self.len = string.len(source)
	self.pos = 1

	return self
end

function Lexer:Peek(amount: number): string?
	local pos = self.pos :: number
	local nextPos = pos + amount
	if nextPos > self.len then
		return nil
	end

	return string.sub(self.source, nextPos, nextPos)
end

function Lexer:Consume()
	local pos = self.pos :: number
	self.pos = pos + 1
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
		end

		-- TODO: Could be number
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
	elseif table.find(WHITESPACE, char) then
		self:Consume()
	end

	return { Lexemes.Unknown, char }
end

function Lexer:GenerateTokens(): {
	ok: boolean,
	err: string?,
	tokens: { [number]: Types.Token }?,
}
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
