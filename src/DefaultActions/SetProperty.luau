local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.BehaviorContext)
		assert(context.target, "no target")

		local target = context.target :: any -- Allow dynamic property read/assign
		local propName = context.parameter.GetInput(1, "string")
		local desiredPropValueType = typeof(target[propName])
		local propValue = context.parameter.GetInput(2, desiredPropValueType)
		target[propName] = propValue
	end,
}
