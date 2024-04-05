local ChainTypes = require(script.Parent.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))

type thunk = ChainTypes.thunk

return {
	parameters = { [1] = "boolean", [2] = "thunk", [3] = "thunk?" },
	validateTarget = false,

	call = function(context)
		local condition = context.args[1] :: boolean
		local trueBranch = context.args[2] :: thunk
		local falseBranch = context.args[3] :: thunk?

		if condition then
			trueBranch()
		elseif falseBranch then
			falseBranch()
		end
	end,
} :: ChainTypes.CallDefinition<nil>
