local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))

return {
	Run = function(context: Types.ActionContext)
		local target = context.target
		assert(target, "no target")
		task.defer(target.RemoveTag, target, Names.Tags.Link)
	end,
}
