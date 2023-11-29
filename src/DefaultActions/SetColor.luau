local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.BehaviorContext)
		assert(context.target, "no target")

		local name = context.parameter.GetInput(1, "string")
		local color = context.target:GetAttribute("_Color" .. name)
		assert(color, "color not found!")

		for _, instance in context.target:GetDescendants() do
			if instance.Name ~= "_Color" or not instance:IsA("BasePart") then
				continue
			end

			instance.Color = color
		end
	end,
}
