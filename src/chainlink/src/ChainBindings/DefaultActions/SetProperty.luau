local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))
local Logger = require(script.Parent.Parent.Parent:WaitForChild("Logger"))

return {
	parameters = { [1] = "string", [2] = "any" },
	target = true,

	call = function(context)
		local target = context.target :: any -- Allow dynamic property read/assign
		local propName = context.args[1] :: string
		local propValue = context.args[2] :: any

		if typeof(target[propName]) ~= typeof(propValue) then
			Logger.Warn(`action "SetProperty" property value types need to match`)
			return
		end

		target[propName] = propValue
		return nil
	end,
} :: Chain.CallDefinition
