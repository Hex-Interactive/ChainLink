local Types = require(script.Parent.Parent:WaitForChild("Types"))

type Parser = {
	__index: Parser,
	new: (_tokens: { [number]: Types.Token }) -> Parser,
}

local Parser = {} :: Parser
Parser.__index = Parser

function Parser.new(_tokens: { [number]: Types.Token }): Parser
	local self = (setmetatable({}, Parser) :: any) :: Parser

	-- TODO

	return self
end

return Parser
