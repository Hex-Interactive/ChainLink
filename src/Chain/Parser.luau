local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (tokens: { Types.Token }) -> Parser,

	tokens: { Types.Token },
	len: number,
	pos: number,

	Peek: (self: Parser, amount: number) -> Types.Token?,
	Consume: (self: Parser) -> (),
	GenerateInstructions: (self: Parser) -> Types.Result<Types.Instructions>,
}

local Parser = {} :: Parser
Parser.__index = Parser

function Parser.new(tokens: { Types.Token }): Parser
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

function Parser:GenerateInstructions(): Types.Result<Types.Instructions>
	-- TODO

	return {
		ok = false,
		err = "not implemented",
	}
end

return Parser
