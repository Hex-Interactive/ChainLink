local ChainTypes = require(script.Parent.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	parameters = { [1] = "string" },
	target = false,

	call = function(context)
		local name = context.args[1] :: string
		return context.process.memRead(name)
	end,
} :: ChainTypes.CallDefinition
