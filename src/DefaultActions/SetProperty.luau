local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.CallContext)
		local target = context.target :: any -- Allow dynamic property read/assign
		local propName = context.args[1] :: string
		local propValue = context.args[2]

		if typeof(target[propName]) == typeof(propValue) then
			target[propName] = propValue
		end
	end,
}
