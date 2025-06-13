# `fim.nvim`

<img alt="GitHub Actions Workflow Status" src="https://img.shields.io/github/actions/workflow/status/dpi0/fim.nvim/ci.yml?label=ci">

Simple floating terminal window. Preserves state and allows UI configuration.

![screenshot](https://github.com/user-attachments/assets/ca13f653-7371-4635-a672-218345bb1472)

<p align="center"><em>Fim running in kitty terminal with tmux running inside it</em></p>

## Requirements

[Neovim](https://github.com/neovim/neovim) 0.8.0+

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'dpi0/fim.nvim',
  opts = {}, -- empty opts table must be present to call setup
}
```

## Usage

Call the toggle function to open/close the floating terminal:

```lua
require("fim").toggle()
```

The terminal state is preserved when toggled. Your processes also remain intact.

Plugin provides the default keybind `<A-i>` (Alt+i) to toggle the terminal. Leader based keybinds like `<leader>t` will also work, but you have to disable `launch_with_insert` option.

My recommendation to use this plugin is with a terminal multiplexer like [tmux](https://github.com/tmux/tmux). This allows persistent terminal sessions with multiple terminal windows (or even panes) right inside of fim!

## Configuration

### Options

```lua
opts = {
  launch_with_insert = false, -- Launch in insert mode (default: true)
  width = 0.8, -- Width can be decimal (0.8), percentage (80%) of range b/w 1-100 (80) (default: 0.8)
  height = 70, -- Height can be decimal (0.7), percentage (70%) of range b/w 1-100 (70) (default: 0.8)
  position = "center", -- defines which side to "stick" - 'center', 'top', 'bottom', 'left', 'right' (default: center)
}
```

### Keybinds

```lua
keys = {
  {
    "<A-i>", -- leader based keybinds don't work properly when launch_with_insert is enabled
    function()
      require("fim").toggle()
    end,
    desc = "Toggle floating terminal",
  },
}
```

Below is a keybind i always add to toggle out of insert mode when terminal is launched.

When `<Esc><Esc>` is hit, you will exit insert mode and enter normal mode in the terminal. To go back to insert mode, hit `i`.

```lua
keys = {
  {
    "<Esc><Esc>",
    "<C-\\><C-n>",
    mode = "t",
    desc = "Exit terminal's insert mode",
  },
}
```

### Example config i use

[source](https://github.com/dpi0/nvim/blob/main/lua/plugins/terminal.lua#L1-L1)

```lua
{
  'dpi0/fim.nvim',
  opts = {
    launch_with_insert = true,
    height = 90,
    width = 90,
    position = 'center',
  },
  keys = {
    {
      '<A-i>',
      function()
        require('fim').toggle()
      end,
      desc = 'Toggle floating terminal',
    },
    {
      "<Esc><Esc>",
      "<C-\\><C-n>",
      mode = "t",
      desc = "Exit terminal's insert mode",
    },
  },
}
```
