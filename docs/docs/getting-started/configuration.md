---
sidebar_position: 2
---

# Configuration

Configuring ChainLink is required in order to use the system. During the configuration process is also where you extend the native functionality in order to integrate it with your game's systems.

During the configuration process you can:

1. [Define the map directory](#defining-the-map-directory)
2. [Register Actions](#registering-actions)
3. [Register Validators](#registering-validators)
4. [Call the `Init` function](#initializing)

The first step and last step are the only required steps, but registering game-specific [Actions](../concepts/actions) are recommended. You should register [Validators](../concepts/validators) only as you need them.

## Steps

### Defining the Map Directory

ChainLink needs to know what part of your game is the map. This is for sandboxing/security reasons, but also helpful for organization. The map directory shouldn't contain any important elements to the game's function, such as scripts.

Use the function `SetMapDirectory` and pass a function that, when called, will return the map directory.

```lua
local ChainLink = require(...)

ChainLink.SetMapDirectory(function()
	return workspace:FindFirstChild("CurrentMap")
end)
```

### Registering Actions

To extend the native functionality of ChainLink and integrate better with your game systems, you should register Actions. This must be done before the `Init` function is called. There are 3 functions to register Actions.

- `RegisterAction` registers a single ActionModule, and thus it takes a ModuleScript as an argument.
- `RegisterActionsIn` registers descendant ActionModules (only ModuleScripts) of the passed in parent argument.
	- There is an optional second argument of an array of strings for Action names to ignore.
- `RegisterDefaultActions` registers all the default ChainLink Actions.
	- There is an optional second argument of an array of strings for Action names to ignore.

The name property of registered ModuleScripts (ActionModules) is used for the Action name. Action names must not match; they all have to be unique. It is recommended to store your custom ActionModules in a folder hierarchy and use `RegisterActionsIn` to register them. Both `RegisterActionsIn` and `RegisterDefaultActions` will ignore non-ModuleScript instances, allowing you to organize your Actions into nested folders for organization, if you so choose.

```lua
local ChainLink = require(...)

ChainLink.RegisterAction(script.Parent:WaitForChild("ImportantAction"))
ChainLink.RegisterActionsIn(script:WaitForChild("Actions"), { "UnusedAction" })
ChainLink.RegisterDefaultActions()
```

### Registering Validators

To customize functionality of built-in features such as [Triggers](../concepts/triggers), you'll want to register Validators. Using the function `RegisterValidators`, you pass in a table with the names of the Validators and the Validator functions themselves. You're only able to register Validators defined internally in ChainLink, and you only have to register the Validators you need, otherwise they will default to a function that always returns true.

```lua
local ChainLink = require(...)

ChainLink.RegisterValidators({
	CanTrigger = function(): boolean
		return script:GetAttribute("TriggersEnabled")
	end,
	CanTriggerPlayer = function(subject: Player): boolean
		return subject.UserId ~= 1
	end,
})
```

### Initializing

To "enable" or "turn on" ChainLink, you need to call the `Init` function. This must be called separately for each runtime you are using ChainLink with: server and/or client. In the vast majority of cases, you will just be initializing on the server. Before calling this function, make sure you have registered all Actions and Validators you will be using. Additionally, it will error if called more than once or if the map directory wasn't defined.

```lua
local ChainLink = require(...)

ChainLink.Init()
```

## Full Example

Below is a full example of a potential configuration.

```lua
local ChainLink = require(...)

ChainLink.SetMapDirectory(function()
	return workspace:FindFirstChild("MainMap")
end)

ChainLink.RegisterActionsIn(script:WaitForChild("Actions"), { "OldAction" })
ChainLink.RegisterDefaultActions()

ChainLink.RegisterValidators({
	CanTriggerPlayer = function(subject: Player): boolean
		return subject.UserId % 2 == 0
	end,
})

ChainLink.Init()
```
