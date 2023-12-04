local Types = require(script.Parent.Parent:WaitForChild("Types"))
local Names = require(script.Parent.Parent:WaitForChild("Names"))

return {
	ValidateTarget = true,

	Run = function(context: Types.CallContext)
		local target = context.target :: Instance
		task.defer(target.RemoveTag, target, Names.Tags.Link)
	end,
} :: Types.ActionModule
