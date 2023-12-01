local CollectionService = game:GetService("CollectionService")

local Routines = require(script.Parent:WaitForChild("Chain"):WaitForChild("Routines"))
local ChainInterpreter = require(script.Parent:WaitForChild("ChainInterpreter"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Triggers = require(script.Parent:WaitForChild("Triggers"))
local Types = require(script.Parent:WaitForChild("Types"))

local initialized = false

local Runtime = {}

function Runtime.TriggerLink(link: Instance, source: string, extraData: Types.ExtraData?)
	if not CollectionService:HasTag(link, "Link") or not CurrentMap.HasDescendant(link) then
		return
	end

	local instructions = link:GetAttribute("LinkTrigger")
	if not instructions then
		return
	end

	task.spawn(ChainInterpreter.Execute, instructions, source, extraData)
end

function Runtime.Init()
	assert(initialized == false, "already initialized")
	initialized = true

	CurrentMap.GetDirectory() -- Validate map directory getter is defined

	CollectionService:GetInstanceAddedSignal("Trigger"):Connect(Triggers.Added)
	CollectionService:GetInstanceRemovedSignal("Trigger"):Connect(Triggers.Removed)

	CollectionService:GetInstanceAddedSignal("Routine"):Connect(Routines.Added)
	CollectionService:GetInstanceRemovedSignal("Routine"):Connect(Routines.Removed)
end

return Runtime
