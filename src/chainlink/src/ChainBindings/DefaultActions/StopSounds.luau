local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))

return {
	parameters = { [1] = "string" },
	target = true,

	call = function(context)
		local target = context.target :: Instance
		local name = context.args[1] :: string

		for _, instance in target:GetDescendants() do
			if instance.Name ~= name or not instance:IsA("Sound") then
				continue
			end

			instance:Stop()
		end

		return nil
	end,
} :: Chain.CallDefinition
