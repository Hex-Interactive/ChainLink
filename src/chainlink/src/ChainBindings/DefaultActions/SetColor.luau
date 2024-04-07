local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))
local Logger = require(script.Parent.Parent.Parent:WaitForChild("Logger"))

return {
	parameters = { [1] = "string" },
	target = true,

	call = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string

		local color = target:GetAttribute("_Color" .. name)
		if typeof(color) ~= "Color3" then
			Logger.Warn(`action "SetColor" target needs Color3 type attribute "_Color"`)
			return
		end

		for _, instance in target:GetDescendants() do
			if instance.Name ~= "_Color" or not instance:IsA("BasePart") then
				continue
			end

			instance.Color = color
		end

		return nil
	end,
} :: Chain.CallDefinition
