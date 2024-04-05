local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	parameters = { [1] = "number" },

	call = function(context)
		local duration = context.args[1] :: number
		task.wait(duration)
	end,
} :: ChainTypes.CallDefinition<nil>
