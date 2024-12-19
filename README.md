# color-compiler.nvim

A simple utility to precompile your current theme to improve startup times

![startup w/o color-compiler](https://imgur.com/Abpgu2X)

![color-compiler startup times](https://imgur.com/fO2473p)

# Overview

color-compiler is perfect for those who heavily modify their colorscheme, setting multiple custom overrides of highlight groups.

If this is you, you know that doing this comes with a price... *valuable milliseconds*

The goal of this plugin is to precompile your current theme to avoid the tax in startup times.

Although this feature is packaged in many popular plugins, such as [catppuccin](https://github.com/catppuccin/nvim) or [kanagawa](https://github.com/rebelot/kanagawa.nvim), this project allows any custom confiuration to be compiled and saved for later use.

The code has been heavily based off of [catppuccin's implementation](https://github.com/catppuccin/nvim/blob/f8a155ab5891c5d2fb709b7e85627f1783d5a5d9/lua/catppuccin/lib/compiler.lua) and adapted to work with any currently set colorscheme

# Installation

```lua
-- lazy
return {
  {
    "paradoxical-dev/color-compiler.nvim",
    lazy = false,
    priority = 1000
    config = function()
      -- Check 'Usage' section
    end
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

The `load` function is used within the config of the plugin setup, passing in the desired theme name.

> [!NOTE]
> If the passed in name is not present in the cache directory, the current colorscheme will be compiled under this name. In this case a restart of the editor will be required for the colorscheme to become active

> [!TIP]
> When configuring your desired theme, ensure this line is either removed or commented out

**Example**
```lua
config = function()
  require('color-compiler').load('theme')
end
```

# Supported Plugins

- aerial
- cmp
- dap/dap-ui
- gitsigns
- harpoon
- Heirline
- illiminate
- lazy
- LSP
- mason
- neo-tree
- neotest
- noice
- NormalNvim
- render-markdown
- snacks
- telescope
- treesitter
- ufo
- which-key

> [!NOTE]
> If a plugin you use is not supported and adding the custom groups to the command is too cumbersome, consider forking and creating a pull request.
> 
> Simply update [groups.lua](lua/color-compiler/groups.lua) with the desired groups and I will approve the PR asap
