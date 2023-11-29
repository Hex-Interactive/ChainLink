local Types = require(script.Parent.Parent:WaitForChild("Types"))

local Parser = {}
Parser.__index = Parser

function Parser.new(_tokens: { [number]: Types.Token })
	local self = setmetatable({}, Parser)

	-- TODO

	return self
end

return Parser
