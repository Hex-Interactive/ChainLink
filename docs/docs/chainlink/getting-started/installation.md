---
sidebar_position: 1
---

# Installation

ChainLink is available for Rojo-based and Studio workflows.

### With Wally (Recommended)

1. Ensure you have [Wally](https://github.com/UpliftGames/wally) installed
2. Add ChainLink to your `wally.toml` file:

```
ChainLink = "hex-interactive/chainlink@0.1.2"
```

3. Run the command `wally install` to install your packages

If you're using ChainLink only on the server (the most common implementation), place it in `[server-dependencies]`. Otherwise, place it in `[dependencies]`.

### From GitHub Releases

1. Navigate to the [latest release](https://github.com/Hex-Interactive/ChainLink/releases/latest) page
2. Download the attached file, `ChainLink.rbxm`
3. Place the file into your project

If you're using ChainLink only on the server (the most common implementation), place it somewhere inside `ServerScriptService`. Otherwise, place it somewhere inside `ReplicatedStorage`.
