local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.BehaviorContext)
		assert(context.target, "no target")

		local name = context.parameter.GetInput(1, "string")
		local number = context.parameter.GetInput(2, "number")

		for _, instance in context.target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("ParticleEmitter") then
				continue
			end

			instance:Emit(number)
		end
	end,
}
