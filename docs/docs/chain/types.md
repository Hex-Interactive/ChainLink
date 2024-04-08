---
sidebar_position: 3
---

# Types

Chain has its own runtime type system. In certain cases, notably with call definitions and defining parameters, you can supply optional types by appending a `?`, but the Luau `nil` type is otherwise not allowed.

| Type | Functionality |
| --- | --- |
| string | Any string (from Luau) |
| boolean | Any bool (from Luau) |
| number | Any number (from Luau) |
| thunk | An unevaluated call (Luau function) |
