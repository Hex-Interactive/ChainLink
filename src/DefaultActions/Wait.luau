local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.BehaviorContext)
		local duration = context.parameter.GetInput(1, "number")
		task.wait(duration)
	end,
}
