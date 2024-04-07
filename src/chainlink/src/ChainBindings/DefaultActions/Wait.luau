local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))

return {
	parameters = { [1] = "number" },
	target = false,

	call = function(context)
		local duration = context.args[1] :: number
		task.wait(duration)
		return nil
	end,
} :: Chain.CallDefinition
