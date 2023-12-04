local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.CallContext)
		local duration = context.args[1] :: number
		task.wait(duration)
	end,
}
