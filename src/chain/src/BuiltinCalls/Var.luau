local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	parameters = { [1] = "string", [2] = "any" },
	target = false,

	call = function(context)
		local name = context.args[1] :: string
		local value = context.args[2] :: any

		context.process.memDef(name, value)
		return nil
	end,
} :: Types.CallDefinition
