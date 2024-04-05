local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	parameters = { [1] = "string" },
	validateTarget = true,

	call = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string

		for _, instance in target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("Sound") then
				continue
			end

			instance:Play()
		end
	end,
} :: ChainTypes.CallDefinition<nil>
