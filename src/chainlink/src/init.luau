--[[
	ChainLink
	v0.2.0
]]

local Actions = require(script:WaitForChild("ChainBindings"):WaitForChild("Actions"))
local ChainRunner = require(script:WaitForChild("ChainRunner"))
local Validators = require(script:WaitForChild("Validators"))
local CurrentMap = require(script:WaitForChild("CurrentMap"))
local Chain = require(script.Parent:WaitForChild("Chain"))
local Runtime = require(script:WaitForChild("Runtime"))

export type CallDefinition = Chain.CallDefinition

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
	ExecuteChain = ChainRunner.Execute,
}
