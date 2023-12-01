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
	if not CurrentMap.HasDescendant(trigger) then
		return
	end

	Util.Assert(trigger:IsA("BasePart"), `invalid trigger "{trigger.Name}"`)

	local mode = trigger:GetAttribute(Names.Attr.TriggerMode)
	local chain = trigger:GetAttribute(Names.Attr.TriggerChain)
	Util.Assert(mode, "trigger missing mode!")
	Util.Assert(chain, "trigger missing chain!")
	Util.Assert(VALID_MODES[mode], `invalid trigger mode "{mode}"`)

	index[trigger] = trigger.Touched:Connect(function(hit: BasePart)
		if not Validators.Check("CanTrigger") then
			return
		end

		if mode == "Player" then
			local player = Players:GetPlayerFromCharacter(hit.Parent)
			if not player or not Validators.Check("CanTriggerPlayer", player) then
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

return Triggers
