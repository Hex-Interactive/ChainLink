---
sidebar_position: 1
slug: /
---

# Introduction

ChainLink is a DataModel-driven logic and control system that empowers map designers and builders in Roblox. The goal is to keep map-specific logic in the map itself, while avoiding nested and unorganized scripts. This concept has many benefits, notably for games which rely upon maps as a major form of content. Maps with unique features and logic to them are easier to create and are able to be worked on by those not familiar with Luau scripting.

ChainLink also practices sandboxing, which you can read about [below](#community-contributions).

## Conceptually

The key features of ChainLink primarily come from two things, as the name suggests: [Chain](docs/concepts/chain) and [Links](docs/concepts/links).

Chain is a custom list-based scripting language. It's intentionally simple, lacking common programming features such as if-statements or functions. The singluar goal of Chain is to be a list of definitive instructions to execute. Achieving more complex logic with Chain comes from the usage of features like Links, [Actions](docs/concepts/actions), and [Routines](docs/concepts/routines).

Links are what tie your maps's presence in the [Roblox DOM](https://create.roblox.com/docs/reference/engine/classes/DataModel) to the world of ChainLink. In other words, ChainLink, and by extension its scripting language, Chain, are not able to access your game's hierarchy without a Link explicitly denoting that a given instance can be accessed.

The instructions that Chain executes are Actions and Routines. Actions are the lowest level of an instructional unit. Actions are programmed in Luau and defined by the developer of the game, for use through ChainLink in maps. Routines are groupings of Chain in an ordered structure. They allow you to achieve more complexity through being able to reuse a Chain script in other Chain scripts, but not being rooted in Chain themselves.

## The Golden Rule

ChainLink can be a very powerful tool for map development. When [implementing](docs/implementation/practices) ChainLink in your game there is one key concept to ensure you get maximum usage out of the system, however.

:::info[The Golden Rule of ChainLink]
ChainLink can only do what you, the developer, give it the capabilities to do.
:::

By default, ChainLink only has a handful of Actions and nothing to trigger Links. To get the most out of the system, integrate your game's systems with ChainLink as much as reasonably possible. The scope of what is possible is up to how deep you integrate ChaihLink, and the map developer's usage of ChainLink's native and developer-defined features.

## Use Cases

ChainLink has a variety of use cases to fit many kinds of games.

### Community Contributions

Implementing community-created content could never be easier with ChainLink. Instead of developing your own map scripting or event language/system, you could integrate ChainLink. For community contributors this can be helpful as it might be something they are already familar with, but also that they're able to utilize the ChainLink documentation to make maps for your game. Of course, you'll still want to provide some of your own documenation for things like Actions specific to your implementation of ChainLink.

If your implementation of ChainLink is up to security standards, you could even take it a step further and automate the process due to ChainLink's practice of [sandboxing](https://en.wikipedia.org/wiki/Sandbox_(computer_security)). In other words, it protects your game from malicious code running or affecting your game, notably in the case of community-created content. The behavior that users specify while using ChainLink to create maps can only affect Roblox instances within the map's directory, specified by you and you only. In addition, any instances affected must be a Link.

### Empower Your Builders

Many builders don't know how to script in Luau but would like to give their maps unique features. ChainLink is perfect for this to be able to give them a way to create unique logic all within their map, no scripts or unneeded complexity. Giving your builders access to ChainLink breathes life into your game's maps, allowing each one to be a more unique and fun experience for players.
