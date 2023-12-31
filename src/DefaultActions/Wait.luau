local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	ValidateArgs = { [1] = "number" },

	Run = function(context)
		local duration = context.args[1] :: number
		task.wait(duration)
	end,
} :: Types.ActionModule
