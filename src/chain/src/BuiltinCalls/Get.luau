local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	parameters = { [1] = "string" },
	target = false,

	call = function(context)
		local name = context.args[1] :: string
		return context.process.memRead(name)
	end,
} :: Types.CallDefinition
