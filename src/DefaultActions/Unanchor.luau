local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	ValidateTarget = true,

	Run = function(context)
		local target = context.target :: Instance

		for _, instance in target:GetDescendants() do
			if not instance:IsA("BasePart") then
				continue
			end

			instance.Anchored = false

			if instance:CanSetNetworkOwnership() then
				instance:SetNetworkOwner(nil)
			end
		end
	end,
} :: Types.ActionModule
