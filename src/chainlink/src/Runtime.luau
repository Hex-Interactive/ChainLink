local RoutineSer = require(script.Parent:WaitForChild("ChainBindings"):WaitForChild("RoutineSer"))
local ChainRunner = require(script.Parent:WaitForChild("ChainRunner"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Triggers = require(script.Parent:WaitForChild("Triggers"))
local Logger = require(script.Parent:WaitForChild("Logger"))
local State = require(script.Parent:WaitForChild("State"))
local Names = require(script.Parent:WaitForChild("Names"))

local Runtime = {}

function Runtime.TriggerLink(link: Instance)
	if not link:HasTag(Names.Tags.Link) or not CurrentMap.HasDescendant(link) then
		return
	end

	local chain = link:GetAttribute(Names.Attr.LinkChain)
	if not chain then
		return
	end

	task.spawn(ChainRunner.Execute, chain)
end

function Runtime.Init()
	Logger.Assert(State.initialized == false, "already initialized")
	State.initialized = true

	CurrentMap.GetDirectory() -- Validate map directory getter is defined

	Triggers.Init()
	RoutineSer.Init()
end

return Runtime
