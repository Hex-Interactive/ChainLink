---
sidebar_position: 1
---

# Syntax

The syntax of Chain is quite simple. Generally, it is a list of calls separated by semicolons. Calls can be [Actions](../actions) or [Routines](../routines). Calls can have a target, denoted by an arrow (`->`) to [target a certain identifier](../links#referencing), part of Link Ids. Some Actions require a target to be provided and would be documented as such. Arguments can be passed into calls, if needed.

Some Actions might have a certain number of arguments of certain types required. The arguments themselves can be one of the [supported Chain datatypes](../chain#supported-dataypes), and [binary expressions](https://en.wikipedia.org/wiki/Binary_expression_tree) (math and boolean evaluation) are allowed.

## Examples

An example of a Chain script can be seen below.

```
Trapdoor->Drop();Trapdoor->Force();ActivateAlarm();
```

This this example, the first two statements are calls which both target the identifier `Trapdoor`. The last call would be a Routine that would have some instructions to activate an alarm, turning on red lights and playing sounds.

```
AlarmLight->PlaySounds("AlarmSFX");AlarmLight->SetAttribute("IsActive", true);
```

This next example is part of the Chain that executes in the Routine `ActivateAlarm` from the last example. This shows that adding arguments to calls is as simple as adding them inside the call parenthesis. In the case of multiple arguments, add a comma to separate them.
