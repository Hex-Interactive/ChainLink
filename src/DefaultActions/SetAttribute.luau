local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.CallContext)
		local target = context.target :: Instance
		local name = context.args[1] :: string
		local value = context.args[2]
		target:SetAttribute(name, value)
	end,
}
