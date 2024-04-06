local ChainTypes = require(script.Parent.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	parameters = { [1] = "string", [2] = "any" },
	target = false,

	call = function(context)
		local name = context.args[1] :: string
		local value = context.args[2] :: any

		context.process.memDef(name, value)
		return nil
	end,
} :: ChainTypes.CallDefinition
