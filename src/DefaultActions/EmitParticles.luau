local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

return {
	parameters = { [1] = "string", [2] = "number" },
	target = true,

	call = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string
		local number = context.args[2] :: number

		for _, instance in target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("ParticleEmitter") then
				continue
			end

			instance:Emit(number)
		end

		return nil
	end,
} :: ChainTypes.CallDefinition
