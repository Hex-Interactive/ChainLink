local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	ValidateTarget = true,
	ValidateArgs = { [1] = "string", [2] = "any" },

	Run = function(context: Types.CallContext)
		local target = context.target :: Instance
		local name = context.args[1] :: string
		local value = context.args[2] :: any
		target:SetAttribute(name, value)
	end,
} :: Types.ActionModule
