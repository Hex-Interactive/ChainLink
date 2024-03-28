local ChainTypes = require(script.Parent.Parent:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))

return {
	ValidateTarget = true,

	Run = function(context)
		local target = context.target :: Instance
		task.defer(target.RemoveTag, target, Names.Tags.Link)
	end,
} :: ChainTypes.ActionModule
