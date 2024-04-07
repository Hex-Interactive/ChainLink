---
sidebar_position: 2
---

# Actions

Actions are the lowest level of an instructional unit. Actions are programmed in Luau and defined by the developer of the game, for use through ChainLink in maps. Specifically, Actions are called when [Chain](chain) is being executed.

## Built-In

ChainLink comes with default Actions you can choose to register. Below is a list of what they all are.

| Action Name | Use Case |
| :-- | :-- |
| Wait | Will yield Chain execution like `task.wait()` |
| Once | If you want a Link to be triggered only once, deferring removal of the Link tag to next resumption cycle |
| Force | Applies a force of a certain magnitude in a direction to an assembly |
| EmitParticles | Emits a certain amount of particles by ParticleEmitter name and amount |
| SetColor | Changes the color of BaseParts using an attribute for the color |
| PlaySounds | Plays any number of sound instances by name |
| StopSounds | Stops any number of sound instances by name |
| Unanchor | Can unanchor BaseParts |
| SetAttribute | Can assign attributes on instances |
| SetProperty | Can assign properties on instances |

It is recommended to read the default Actions entry on the [security](../implementation/security#built-in) page before registing any.

## Custom

Creating custom Actions is very important to a [featureful implementation](../implementation/practices#implementing-custom-actions) of ChainLink. To define a custom Action, you'll need to write an ActionModule and then register it during [configuration](../getting-started/configuration). If you use Luau types, you can use the exported ActionModule type to assist with this process. A good resource for writing Actions is the source code of ChainLink where the default Actions are defined.

To understand, the ActionModule definition precisely, the types are below.

```lua title="Types related to ActionModule"
type Action = (context: CallContext) -> ()
type CallContext = {
	target: Instance?,
	args: { ASTData? },
	validatedParam: ValidatedParam?,
}

type ValidateTargetFunc = (target: Instance) -> (boolean, ValidatedParam?)
type ValidatedParam = any

type ActionModule = {
	ValidateArgs: { [number]: string },
	ValidateTarget: (ValidateTargetFunc | boolean)?,
	Run: Action,
}
```

In this example above, `ASTData` represents the [currently supported datatypes](chain#supported-datatypes) of Chain, see the [Chain](chain) page for more information. The return types of `ValidateTargetFunc` are 1. a boolean indicating a successful validation and 2. the developer-defined `validatedParam`.

It is important to keep [security](../implementation/security#custom) in mind when creating your own Actions.
