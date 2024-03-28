local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	ValidateTarget = true,
	ValidateArgs = { [1] = "string", [2] = "number" },

	Run = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string
		local number = context.args[2] :: number

		for _, instance in target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("ParticleEmitter") then
				continue
			end

			instance:Emit(number)
		end
	end,
} :: ChainTypes.ActionModule
