local Chain = require(script.Parent.Parent.Parent.Parent:WaitForChild("Chain"))
local Names = require(script.Parent.Parent.Parent:WaitForChild("Names"))

return {
	target = true,

	call = function(context)
		local target = context.target :: Instance
		task.defer(target.RemoveTag, target, Names.Tags.Link)
		return nil
	end,
} :: Chain.CallDefinition
