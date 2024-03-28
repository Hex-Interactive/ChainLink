local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	ValidateArgs = { [1] = "number" },

	Run = function(context)
		local duration = context.args[1] :: number
		task.wait(duration)
	end,
} :: ChainTypes.ActionModule
