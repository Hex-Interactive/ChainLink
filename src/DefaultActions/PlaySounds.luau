local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.ActionContext)
		assert(context.target, "no target")

		local name = context.parameter.GetInput(1, "string")
		for _, instance in context.target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("Sound") then
				continue
			end

			instance:Play()
		end
	end,
}
