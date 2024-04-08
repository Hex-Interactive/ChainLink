---
sidebar_position: 4
---

# Triggers

Triggers are much like the triggering aspect of [Links](links), but for when [player characters](https://create.roblox.com/docs/reference/engine/classes/Player#Character) touch a BasePart. Triggers are represented as a [tag](https://create.roblox.com/docs/reference/engine/classes/CollectionService) called `Trigger` on a given BasePart.

## Setup

Triggers require two attributes of type `string`. They are "TriggerMode" for how the Trigger should activate and "TriggerChain" for the [Chain](chain) script to execute when successfully activated.

The "TriggerMode" attribute has to match a valid mode:

| Mode | Functionality |
| --- | --- |
| Player | Will trigger when a direct BasePart child of a player character [touches](https://create.roblox.com/docs/reference/engine/classes/BasePart#Touched) the Trigger |

## Validators

By default, Triggers don't have any game-specific validation on what and when they can activate on. Thus, on the game developer's end, you need to define the conditions where Triggers can activate. To do this, utilize [Validators](validators).
