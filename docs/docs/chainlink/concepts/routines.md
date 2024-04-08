---
sidebar_position: 3
---

# Routines

Routines are groupings of [Chain](chain) in an ordered structure. They allow you to achieve more complexity through being able to reuse a Chain script in other Chain scripts, but not being rooted in Chain themselves. Instead, they are rooted in the [Roblox DOM](https://create.roblox.com/docs/reference/engine/classes/DataModel) with instances.

Routines themselves are Models tagged with the `Routine` tag. They have nested children of Configuration instances with attributes on them that represent the steps of the routine. Steps are named with a number that represents their order. Each step must have a `string` attribute "Class" and a "Data" attribute of a type that depends on the chosen class.

| Step Name | Data | Data Type | Functionality |
| --- | --- | --- | --- |
| Chain | A Chain script | `string` | Runs a Chain script

Routines can be ran through Chain by calling the Routine's name. Routines are executed synchronously through all the steps in order.
