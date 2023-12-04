local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.CallContext)
		local target = context.target :: Instance
		local name = context.args[1] :: string

		for _, instance in target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("Sound") then
				continue
			end

			instance:Play()
		end
	end,
}
