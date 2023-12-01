local CollectionService = game:GetService("CollectionService")

local Routines = require(script.Parent:WaitForChild("Chain"):WaitForChild("Routines"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Triggers = require(script.Parent:WaitForChild("Triggers"))
local Chain = require(script.Parent:WaitForChild("Chain"))
local Types = require(script.Parent:WaitForChild("Types"))
local State = require(script.Parent:WaitForChild("State"))
local Names = require(script.Parent:WaitForChild("Names"))

local Runtime = {}

function Runtime.TriggerLink(link: Instance, _source: string, _extraData: Types.ExtraData?)
	if not link:HasTag(Names.Tags.Link) or not CurrentMap.HasDescendant(link) then
		return
	end

	local instructions = link:GetAttribute("LinkTrigger")
	if not instructions then
		return
	end

	task.spawn(Chain.Execute, instructions) -- source, extraData
end

function Runtime.Init()
	assert(State.initialized == false, "already initialized")
	State.initialized = true

	CurrentMap.GetDirectory() -- Validate map directory getter is defined

	CollectionService:GetInstanceAddedSignal(Names.Tags.Trigger):Connect(Triggers.Added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Trigger):Connect(Triggers.Removed)

	CollectionService:GetInstanceAddedSignal(Names.Tags.Routine):Connect(Routines.Added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Routine):Connect(Routines.Removed)
end

return Runtime
