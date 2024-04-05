local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

return {
	parameters = { [1] = "string" },
	validateTarget = true,

	call = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string

		local color = target:GetAttribute("_Color" .. name)
		if typeof(color) ~= "Color3" then
			Util.LogWarn(`action "SetColor" target needs Color3 type attribute "_Color"`)
			return
		end

		for _, instance in target:GetDescendants() do
			if instance.Name ~= "_Color" or not instance:IsA("BasePart") then
				continue
			end

			instance.Color = color
		end
	end,
} :: ChainTypes.CallDefinition<nil>
