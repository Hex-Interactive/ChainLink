---
sidebar_position: 2
---

# Security

Due to how ChainLink is targeted to be used in scenarios where community-created content can be integrated easily into games, it's important to maintain the [sandbox](..#community-contributions) that ChainLink creates when implementing it into your game.

## Map Directory

Most things key to the game's function should not be in the defined [map directory](../getting-started/configuration#defining-the-map-directory). This would be something like scripts. If you need to have something related to the game's function in the map directory, make sure it's not tagged as a Link - this will make it safe from being referenced directly. Make sure to guard against indirect references (referencing or modifying instances which are not Links) by ensuring its not the child of a Link either (in regards to [built-in Actions](#built-in)). Make sure your [custom Actions](#custom) are also careful with indirect references.

## Actions

[Actions](../concepts/actions) are part of what make ChainLink so powerful for map developers, but it's important to ensure they are secure.

### Custom

For Actions like giving players coins or adding time to the round (as seen in the example [here](practices#implementing-custom-actions)), implement restrictions (likely on a per-round basis) to your Actions that prevent the map developer from using it too much. Taking the time to implement restrictions like this allows map developers to have impactful control of their map's features while staying within the bounds you, as the game's developer, define.

When dealing with instances with your custom Actions, ensure you are very careful with what you access and modify, especially if it is indirect (not an instance with a Link).

### Built-In

Not all of the default Actions provided are recommended to be registered when [configuring](../getting-started/configuration) ChainLink. Certain Actions you might not want used in your game, so make sure to add them to the ignore list if registering any default Actions at all. Below is a list of potential dangers with the default Actions.

Keep in mind Actions can only affect instances that have a [Link](../concepts/links#referencing) within the current map directory and a known Link Id (and by extension identifier targeted via Chain). Certain Actions can also affect descendants of instances that meet the above criteria.

| Risk | Action Name | Potential Danger |
| :--: | :-- | :-- |
| 🟢 | Wait | Will yield Chain execution |
| 🟢 | Once | Can remove Link tags |
| 🟢 | Force | Could apply a lot of force on an unanchored assembly |
| 🟢 | EmitParticles | Can emit a lot of particles, causing local FPS lag to some extent |
| 🟢 | SetColor | Can change the color of BaseParts, but depends on a Color3 attribute being present |
| 🟡 | PlaySounds | Can play sound instances, even arbitrary ones created by the map developer |
| 🟡 | StopSounds | Can stop sound instances |
| 🟡 | Unanchor | Can unanchor BaseParts, possibly breaking maps or causing lag |
| 🔴 | SetAttribute | Can assign attributes on instances |
| 🔴 | SetProperty | Can assign properties on instances |

:::info[Risk Key]
🟢 Not much risk <br/>
🟡 Moderately risky <br/>
🔴 Could be quite risky
:::

If you want to use a built-in Action, but want to further secure it for use in your game, copy that Action's source code, and implement it again with more restrictions. Make sure to add the old one to a registration ignore list in your configuration. It's also recommended to [document](practices#documenting-your-implementation) any reimplementations of default Actions if they use the same name. Otherwise, you could give it a new name, but still make sure to document it!

