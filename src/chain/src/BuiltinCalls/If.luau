local Types = require(script.Parent.Parent:WaitForChild("Types"))

type thunk = Types.thunk

return {
	parameters = { [1] = "boolean", [2] = "thunk", [3] = "thunk?" },
	target = false,

	call = function(context)
		local condition = context.args[1] :: boolean
		local trueBranch = context.args[2] :: thunk
		local falseBranch = context.args[3] :: thunk?

		if condition then
			trueBranch()
		elseif falseBranch then
			falseBranch()
		end

		return nil
	end,
} :: Types.CallDefinition
