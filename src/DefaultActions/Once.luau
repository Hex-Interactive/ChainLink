local CollectionService = game:GetService("CollectionService")
local Types = require(script.Parent.Parent:WaitForChild("Types"))

return {
	Run = function(context: Types.BehaviorContext)
		assert(context.target, "no target")
		task.defer(CollectionService.RemoveTag, CollectionService, context.target, "Link")
	end,
}
