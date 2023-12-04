local CollectionService = game:GetService("CollectionService")

local Routines = require(script.Parent:WaitForChild("Chain"):WaitForChild("Routines"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Triggers = require(script.Parent:WaitForChild("Triggers"))
local Chain = require(script.Parent:WaitForChild("Chain"))
local State = require(script.Parent:WaitForChild("State"))
local Names = require(script.Parent:WaitForChild("Names"))
local Util = require(script.Parent:WaitForChild("Util"))

local Runtime = {}

function Runtime.TriggerLink(link: Instance)
	if not link:HasTag(Names.Tags.Link) or not CurrentMap.HasDescendant(link) then
		return
	end

	local chain = link:GetAttribute(Names.Attr.LinkChain)
	if not chain then
		return
	end

	task.spawn(Chain.Execute, chain)
end

function Runtime.Init()
	Util.Assert(State.initialized == false, "already initialized")
	State.initialized = true

	CurrentMap.GetDirectory() -- Validate map directory getter is defined

	Triggers.Init()
	CollectionService:GetInstanceAddedSignal(Names.Tags.Trigger):Connect(Triggers.Added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Trigger):Connect(Triggers.Removed)

	Routines.Init()
	CollectionService:GetInstanceAddedSignal(Names.Tags.Routine):Connect(Routines.Added)
	CollectionService:GetInstanceRemovedSignal(Names.Tags.Routine):Connect(Routines.Removed)
end

return Runtime
