local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (tokens: { [number]: Types.Token }) -> Parser,

	tokens: { [number]: Types.Token },
	pos: number,

	Advance: (self: Parser) -> (),
}

local Parser = {} :: Parser
Parser.__index = Parser

function Parser.new(tokens: { [number]: Types.Token }): Parser
	local self = (setmetatable({}, Parser) :: any) :: Parser

	self.tokens = tokens
	self.pos = 0

	return self
end

function Parser:Advance()
	-- TODO
end

return Parser
