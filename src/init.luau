local Validators = require(script:WaitForChild("Validators"))
local ChainInterpreter = require(script:WaitForChild("ChainInterpreter"))
local Actions = require(script:WaitForChild("Actions"))
local CurrentMap = require(script:WaitForChild("CurrentMap"))
local Runtime = require(script:WaitForChild("Runtime"))
local Types = require(script:WaitForChild("Types"))

export type ActionContext = Types.ActionContext

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
	ExecuteChain = ChainInterpreter.Execute,
}
