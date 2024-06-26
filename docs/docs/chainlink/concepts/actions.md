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

Creating custom Actions is very important to a [featureful implementation](../implementation/practices#implementing-custom-actions) of ChainLink. To define a custom Action, you'll need to write an Chain Call and then register it during [configuration](../getting-started/configuration). If you use Luau types, you can use the exported `CallDefinition` type to assist with this process. A good resource for writing Actions is the source code of ChainLink where the default Actions are defined.

To learn more about Chain Calls, see the [Chain page](chain). It is important to keep [security](../implementation/security#custom) in mind when creating your own Actions.
