local Players = game:GetService("Players")

local ValidatorRegistry = require(script.Parent:WaitForChild("ValidatorRegistry"))
local ChainInterpreter = require(script.Parent:WaitForChild("ChainInterpreter"))
local CurrentMap = require(script.Parent:WaitForChild("CurrentMap"))

local index = {}

local Triggers = {}

function Triggers.Added(trigger: BasePart)
	if not CurrentMap.HasDescendant(trigger) or not trigger:IsA("BasePart") then
		return
	end

	index[trigger] = trigger.Touched:Connect(function(hit: BasePart)
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

function Triggers.Removed(trigger: BasePart)
	local conn = index[trigger]
	if not conn then
		return
	end

	conn:Disconnect()
	index[trigger] = nil
end

return Triggers
