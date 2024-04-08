---
sidebar_position: 5
---

# Validators

Validators are used by the game developer to customize the internal logic of ChainLink by providing a place for game-specific logic. For example, Validators are used to customize the activation logic of [Triggers](triggers). To register/define a Validator, see the [configuration](../getting-started/configuration#registering-validators) page.

A Validator is a function that passes in a subject of a specific type (depends on the Validator) and returns a boolean. For example, defining a given Validator in the configuration table could look like something along these lines:

```lua
ValidatorName = function(subject)
	return -- Insert conditional logic
end
```

## Available Validators

Only Validators from the table below are able to be registered:

| Name | Subject Type | Purpose | Example Use Case |
| --- | --- | --- | --- |
| CanTrigger | nil | Returns true if any Trigger is able to activate | Disabling all Triggers during a cutscene |
| CanTriggerPlayer | Player | Returns true if the player can activate Triggers | Making Triggers ignore dead players |
