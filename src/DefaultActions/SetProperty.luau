local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

return {
	parameters = { [1] = "string", [2] = "any" },
	target = true,

	call = function(context)
		local target = context.target :: any -- Allow dynamic property read/assign
		local propName = context.args[1] :: string
		local propValue = context.args[2] :: any

		if typeof(target[propName]) ~= typeof(propValue) then
			Util.LogWarn(`action "SetProperty" property value types need to match`)
			return
		end

		target[propName] = propValue
		return nil
	end,
} :: ChainTypes.CallDefinition
