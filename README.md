# color-compiler.nvim

A simple utility to precompile your current theme to improve startup times

![startup w/o color-compiler](https://i.imgur.com/FmK0LbX.png)

![color-compiler startup times](https://i.imgur.com/3VVB9JL.png)

# Overview

color-compiler is perfect for those who heavily modify their colorscheme, setting multiple custom overrides of highlight groups.

If this is you, you know that doing this comes with a price... *valuable milliseconds*

The goal of this plugin is to precompile your current theme to avoid the tax in startup times.

Although this feature is packaged in popular themes, such as [catppuccin](https://github.com/catppuccin/nvim) or [kanagawa](https://github.com/rebelot/kanagawa.nvim), this project allows any custom confiuration to be compiled and saved for later use.

The code has been heavily based off of [catppuccin's implementation](https://github.com/catppuccin/nvim/blob/f8a155ab5891c5d2fb709b7e85627f1783d5a5d9/lua/catppuccin/lib/compiler.lua) and adapted to work with any currently set colorscheme

# Installation

```lua
-- lazy
return {
  {
    "paradoxical-dev/color-compiler.nvim",
    lazy = false,
    priority = 1000
    opts = {
      -- Check 'Usage' section
    }
  }
}
```

# Usage

## Commands

### `ColorCompiler`

The :ColorCompiler command provides the base utility for compiling your current colorscheme.

It takes 2 main arguments:

  - `theme` The name to save the compiled theme under (required)
  - `bg` The background color (if not provided the current background color will be used)

Any further arguments will be passed as group names to include in the compiled theme.

> [!TIP]
> If you need to include custom groups the bg argument cannot be omitted.

**Example**
```
:ColorCompiler my_theme dark FzfNormal AlphaHeader
```

Simply have your theme setup to how you like and run the command. The compiled theme will then be saved to the default save location in `~/.local/share/nvim/color-compiler/` under the passed in theme name

## Setup

The main `setup` function is used to define the used plugins and their hl groups. See [Supported Plugins](#Supported-Plugins) for more information.

> [!NOTE]
> The plugin includes the following extenstions by default: cmp, treesitter, lsp

The desired theme may also be passed in under the `theme` key but will return an error if no file is present with this name.

**Example**
```lua
opts = {
  extenstions = {
    "harpoon",
    "telescope",
    -- ...
  }
  theme = "my_theme"
}
```

# Supported Plugins

Add the corresponding Extension Name to the extenstions key when calling the `setup` function.

| **Plugin**         | **Extension Name**       |
|--------------------|--------------------------|
| aerial             | "aerial"                 |
| cmp                | "cmp"                    |
| dap/dap-ui         | "dap"                    |
| gitsigns           | "gitsigns"               |
| harpoon            | "harpoon"                |
| Heirline           | "heirline"               |
| illiminate         | "illiminate"             |
| lazy               | "lazy"                   |
| LSP                | "lsp"                    |
| mason              | "mason"                  |
| neotest            | "neotest"                |
| neo-tree           | "neotree"                |
| noice              | "noice"                  |
| NormalNvim         | "normalnvim"             |
| render-markdown    | "render-md"              |
| Semantic Highlights | "semantic"              |
| snacks             | "snacks"                 |
| telescope          | "telescope"              |
| treesitter         | "treesitter"             |
| ufo                | "ufo"                    |
| which-key          | "which-key"              |

> [!NOTE]
> If a plugin you use is not supported and adding the custom groups to the command is too cumbersome, consider forking and creating a pull request.
> 
> Simply update the [extenstions](lua/color-compiler/groups/extenstions) list with the desired plugin and corresponding groups and I will approve the PR asap
