local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))

return {
	parameters = { [1] = "string", [2] = "any" },
	target = true,

	call = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string
		local value = context.args[2] :: any

		target:SetAttribute(name, value)
		return nil
	end,
} :: Chain.CallDefinition
