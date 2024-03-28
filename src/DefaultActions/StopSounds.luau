local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	ValidateTarget = true,
	ValidateArgs = { [1] = "string" },

	Run = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string

		for _, instance in target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("Sound") then
				continue
			end

			instance:Stop()
		end
	end,
} :: ChainTypes.ActionModule
