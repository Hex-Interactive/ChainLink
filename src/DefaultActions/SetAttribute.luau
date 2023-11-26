local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.ActionContext)
		assert(context.target, "no target")

		local name = context.parameter.GetInput(1, "string")
		local desiredType = context.parameter.GetInput(2, "string")
		local value = context.parameter.GetInput(3, desiredType)
		context.target:SetAttribute(name, value)
	end,
}
