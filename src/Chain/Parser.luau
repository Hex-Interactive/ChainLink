local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (tokens: { [number]: Types.Token }) -> Parser,

	tokens: { [number]: Types.Token },
	len: number,
	pos: number,

	Peek: (self: Parser, amount: number) -> Types.Token?,
	Consume: (self: Parser) -> (),
	GenerateInstructions: (self: Parser) -> (),
}

local Parser = {} :: Parser
Parser.__index = Parser

function Parser.new(tokens: { [number]: Types.Token }): Parser
	local self = (setmetatable({}, Parser) :: any) :: Parser

	self.tokens = tokens
	self.len = #tokens
	self.pos = 1

	return self
end

function Parser:Peek(amount: number): Types.Token?
	local nextPos = self.pos + amount
	if nextPos > self.len then
		return nil
	end

	return self.tokens[nextPos]
end

function Parser:Consume()
	self.pos += 1
end

function Parser:GenerateInstructions()
	-- TODO
end

return Parser
