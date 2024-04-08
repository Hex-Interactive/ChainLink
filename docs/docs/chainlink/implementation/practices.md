---
sidebar_position: 1
---

# Practices

As the [Golden Rule](..#the-golden-rule) states, ChainLink is only able to do as much as the game developer gives it capabilities to do. Because of this, creating a robust implementation of ChainLink for map developers relies on considerate practices from the game developer.

The purpose of this page is to guide developers to implementing ChainLink so that map developers can take full advantage of ChainLink's and your game's systems.

## Keep Security In Mind

As a general practice, it's important to keep your game's security in mind. This is especially the case if you are integrating community-created content, manual or automatic. You can read more about ChainLink security practices on [this page](security).

## Triggering Links

This is one of the most important aspects about implementing ChainLink well, but unfortunately one of the most abstract. [Links](../concepts/links) are a key element of ChainLink on the developer side because of their capability to be triggered and execute [Chain](../concepts/chain) scripts. Triggering a Link, however, is done manually on the game's developer side of things. This means that to have a featureful implementation for map developers to use when making maps for your game, you need to have many places in your game where you trigger Links.

It's helpful to think about the action of triggering a Link as a sort of "game-specific event" that map developers can hook onto and use through ChainLink. Making as many game-specific events trigger Links will give more options to map developers to make their maps unique and functionally interesting. To understand how exactly to go about doing this, an example can be helpful.

### Example

Say you have a round-based game where players walk around maps scavenging for items they need to collect for some goal. To determine your game-specific events, you need to break down your game concept into a list of what players can "interact" with. You already have various interactions programmed into your game, so you've listed out what they are.

- Opening and closing doors
- Picking up an item
- Breaking a glass case

This is essentially your list of which you want to trigger Links on. In code, you'd go to where you implemented these interactions and call `ChainLink.TriggerLink()` by passing in the instance as an argument - door, item, or glass case. On the map developer's side, if they place a door in their map, they know they could add a Link to it which, when trigger, will execute a Chain script to do something specific in their map. For example, picking up a specialty item on a pedestal will trigger an alarm with sounds and lights.

## Utilizing Chain In Code

Another powerful way of implementing ChainLink can be directly executing Chain scripts through the ChainLink API. You can do this with the function `ChainLink.ExecuteChain()` by passing in a Chain script as a string. You should use the same logic of deciding when to use this as [triggering links](#triggering-links), but deattached from Links and their respective instance.

Maybe you have multiple "phases" during a round of your game where players do different activities. To provide map developers with a way to make something unique happen when these phases change, you could utilize directly executing Chain to "call" a [Routine](../concepts/routines) created by the map developer which holds their custom logic.

## Implementing Custom Actions

Adding more [Actions](../concepts/actions), especially ones that relate closely to your game's systems, is critical to give more power to your map developers. Simply using ChainLink's default Actions doesn't provide many features for map developers to take advantage of. At this point you should get creative and add more Actions of things you want to see in your maps. Alternatively, you can implement Actions that mirror the API of some of your game systems. Some examples of custom Actions specific to a game can be seen below.

- Giving a player an amount of coins
- Adding more time to the current round
- Spawning in a tornado entity

:::warning
It's important to keep security in mind when implementing Actions (such as ones that extend the round time or give coins), as there's no restrictions on calling Actions besides what you implement in their definition. See the [security](security#custom) page for more information.
:::

You can read more about how to register custom actions on the [configuration](../getting-started/configuration#registering-actions) page.

## Documenting Your Implementation

Due to how much of ChainLink's power comes from its implementation, this means that map developers will need to know as many details as possible about your implementation in order to utilize ChainLink. Below are some key subjects to clearly document as a resource for map developers regarding your game.

- Where and when Links are triggered
- Where and when you directly execute Chain
- All the details about your custom Actions
- The conditions of your [Validators](../concepts/validators)
- A link to ChainLink's documentation (one that corresponds to the version of ChainLink you use)
- Any other specifics about map development in regards to your game (and maybe some advice too!)
