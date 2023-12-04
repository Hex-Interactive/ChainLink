local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.CallContext)
		local target = context.target :: Instance

		local name = context.args[1] :: string
		local color = target:GetAttribute("_Color" .. name) :: Color3

		for _, instance in target:GetDescendants() do
			if instance.Name ~= "_Color" or not instance:IsA("BasePart") then
				continue
			end

			instance.Color = color
		end
	end,
}
