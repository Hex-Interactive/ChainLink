local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))

return {
	target = true,

	call = function(context)
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

		return nil
	end,
} :: Chain.CallDefinition
