---
sidebar_position: 2
---

# Syntax

The syntax of Chain is quite simple. Generally, it is a list of calls separated by semicolons. Calls can have a target, denoted by an arrow (`->`) to target a certain identifier. Some Actions require a target to be provided and would be documented as such. Arguments should be passed into calls, if required.

Chain is able to evaluate basic math expressions (addition, multiplication, etc.) as well as boolean logic (and, or, not) within call arguments. Calls that do not have a target are capable of returning values to be used in expressions, although this depends on whether what you are actually calling returns a value or not.

## Builtin Calls

Chain comes with some calls regardless of the implementation of Chain.

| Call | Functionality |
| --- | --- |
| `If` | Conditional evaluation |
| `Var` | Defines a variable |
| `Get` | Reads a defined variable |

## Examples

An example of a Chain script can be seen below.

```cpp
Trapdoor->Drop();
Trapdoor->Force();
ActivateAlarm();
```

This this example, the first two statements are calls which both target the identifier `Trapdoor`. The last call would be a Routine that would have some instructions to activate an alarm, turning on red lights and playing sounds.

```cpp
AlarmLight->PlaySounds("AlarmSFX");
AlarmLight->SetAttribute("IsActive", true);
```

This next example is part of the Chain that executes in the Routine `ActivateAlarm` from the last example. This shows that adding arguments to calls is as simple as adding them inside the call parenthesis. In the case of multiple arguments, add a comma to separate them.

```cpp
Var("shouldOpen", RandomBool());
If(Get("shouldOpen"), {
	Door->Open();
}, {
	Door->Close();
});
```

In this example, the variable and if-statement calls are shown off. The brackets passed as arguments of the `If` call are known as [thunks](types).
