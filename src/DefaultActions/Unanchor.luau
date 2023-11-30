local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.ActionContext)
		assert(context.target, "no target")

		for _, instance in context.target:GetDescendants() do
			if not instance:IsA("BasePart") then
				continue
			end

			instance.Anchored = false

			if instance:CanSetNetworkOwnership() then
				instance:SetNetworkOwner(nil)
			end
		end
	end,
}
