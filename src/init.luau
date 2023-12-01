local Validators = require(script:WaitForChild("Validators"))
local CurrentMap = require(script:WaitForChild("CurrentMap"))
local Actions = require(script:WaitForChild("Actions"))
local Runtime = require(script:WaitForChild("Runtime"))
local Chain = require(script:WaitForChild("Chain"))
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
	ExecuteChain = Chain.Execute,
}
