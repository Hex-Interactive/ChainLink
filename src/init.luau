--[[
	ChainLink
	v0.1.2
]]

local Actions = require(script:WaitForChild("ChainBindings"):WaitForChild("Actions"))
local ChainTypes = require(script:WaitForChild("Chain"):WaitForChild("ChainTypes"))
local Validators = require(script:WaitForChild("Validators"))
local CurrentMap = require(script:WaitForChild("CurrentMap"))
local Runtime = require(script:WaitForChild("Runtime"))
local Chain = require(script:WaitForChild("Chain"))

export type CallDefinition = ChainTypes.CallDefinition

return {
	-- Setup
	RegisterAction = Actions.Register,
	RegisterActionsIn = Actions.RegisterIn,
	RegisterDefaultActions = Actions.RegisterDefaults,
	RegisterValidators = Validators.Register,
	SetMapDirectory = CurrentMap.SetDirectory,
	Init = Runtime.Init,

	-- Usage
	TriggerLink = Runtime.TriggerLink,
	ExecuteChain = Chain.Execute,
}
