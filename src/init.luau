local ValidatorRegistry = require(script:WaitForChild("ValidatorRegistry"))
local ChainInterpreter = require(script:WaitForChild("ChainInterpreter"))
local ActionRegistry = require(script:WaitForChild("ActionRegistry"))
local CurrentMap = require(script:WaitForChild("CurrentMap"))
local Runtime = require(script:WaitForChild("Runtime"))
local Types = require(script:WaitForChild("Types"))

export type BehaviorContext = Types.BehaviorContext

return {
	-- Setup
	RegisterAction = ActionRegistry.Register,
	RegisterActionsIn = ActionRegistry.RegisterIn,
	RegisterDefaultActions = ActionRegistry.RegisterDefaults,
	RegisterValidators = ValidatorRegistry.Register,
	SetMapDirectory = CurrentMap.SetDirectory,
	Init = Runtime.Init,

	-- Usage
	TriggerLink = Runtime.TriggerLink,
	ExecuteChain = ChainInterpreter.Execute,
}
