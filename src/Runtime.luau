local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local ValidatorRegistry = require(script.Parent:WaitForChild("ValidatorRegistry"))
local ChainInterpreter = require(script.Parent:WaitForChild("ChainInterpreter"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Routines = require(script.Parent:WaitForChild("Routines"))
local Types = require(script.Parent:WaitForChild("Types"))

local initialized = false
local triggers = {}

local Runtime = {}

local function triggerAdded(trigger: BasePart)
	if not CurrentMap.HasDescendant(trigger) or not trigger:IsA("BasePart") then
		return
	end

	triggers[trigger] = trigger.Touched:Connect(function(hit: BasePart)
		local mode = trigger:GetAttribute("TriggerMode")
		local triggerChain = trigger:GetAttribute("TriggerChain")
		local triggerSource = trigger:GetAttribute("TriggerSource")
		assert(triggerChain, "trigger missing chain!")
		assert(triggerSource, "trigger missing source!")

		if not ValidatorRegistry.Validate("CanTrigger") then
			return
		end

		if mode == "Player" then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if not player or not ValidatorRegistry.Validate("CanTriggerPlayer", player) then
				return
			end

			ChainInterpreter.Execute(triggerChain, triggerSource, {
				Player = player,
			})
		end
	end)
end

local function triggerRemoved(trigger: BasePart)
	local conn = triggers[trigger]
	if not conn then
		return
	end

	conn:Disconnect()
	triggers[trigger] = nil
end

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

	CollectionService:GetInstanceAddedSignal("Trigger"):Connect(triggerAdded)
	CollectionService:GetInstanceRemovedSignal("Trigger"):Connect(triggerRemoved)

	CollectionService:GetInstanceAddedSignal("Routine"):Connect(Routines.Added)
	CollectionService:GetInstanceRemovedSignal("Routine"):Connect(Routines.Removed)
end

return Runtime
