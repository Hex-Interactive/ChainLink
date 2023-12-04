local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local Validators = require(script.Parent:WaitForChild("Validators"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))
local Chain = require(script.Parent:WaitForChild("Chain"))
local Names = require(script.Parent:WaitForChild("Names"))
local Util = require(script.Parent:WaitForChild("Util"))

local VALID_MODES = table.freeze({
	Player = true,
})

local index = {}

local Triggers = {}

function Triggers.Added(trigger: BasePart)
	if not trigger:IsA("BasePart") then
		Util.LogWarn(`invalid trigger "{trigger.Name}"`)
		return
	end

	local mode = trigger:GetAttribute(Names.Attr.TriggerMode)
	if not mode or not VALID_MODES[mode] then
		Util.LogWarn("trigger lacking valid mode!")
		return
	end

	local chain = trigger:GetAttribute(Names.Attr.TriggerChain)
	if not chain or typeof(chain) ~= "string" then
		Util.LogWarn("trigger lacking valid chain!")
		return
	end

	index[trigger] = trigger.Touched:Connect(function(hit: BasePart)
		if not CurrentMap.HasDescendant(trigger) or not Validators.Check(Names.Vals.CanTrigger) then
			return
		end

		if mode == "Player" then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if not player or not Validators.Check(Names.Vals.CanTriggerPlayer, player) then
				return
			end

			Chain.Execute(chain)
		end
	end)
end

function Triggers.Removed(trigger: BasePart)
	local conn = index[trigger]
	if not conn then
		return
	end

	conn:Disconnect()
	index[trigger] = nil
end

function Triggers.Init()
	for _, trigger in CollectionService:GetTagged(Names.Tags.Trigger) do
		Triggers.Added(trigger)
	end
end

return Triggers
