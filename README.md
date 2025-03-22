# fim.nvim

A simple Neovim plugin for managing floating terminal instances with persistent processes.

## Features

- Create and toggle multiple floating terminal instances
- **Preserve terminal content and running processes** when toggling
- Assign different keybindings for different terminal instances
- Customize terminal appearance (size, border, position)
- Automatically enter insert mode in terminals
- Easy to configure

## Installation

### Using lazy.nvim

```lua
{
  "yourusername/fim.nvim",
  config = function()
    require("fim").setup({
      opts = {
        width = 0.75,
        height = 0.5,
        border = "single",
        position = 'center',
        shell = vim.o.shell,
        auto_insert = true,
        auto_close = false
      },
      keys = {
        t1 = "<leader>t1",
        t2 = "<leader>t2",
        t3 = "<leader>t3",
      },
    })
  end
}
```

## Configuration

### Options

| Option        | Default       | Description                                                                         |
| ------------- | ------------- | ----------------------------------------------------------------------------------- |
| `width`       | `0.75`        | Width as a fraction of the screen width                                             |
| `height`      | `0.5`         | Height as a fraction of the screen height                                           |
| `border`      | `"single"`    | Border style (`"single"`, `"double"`, `"rounded"`, `"solid"`, `"shadow"`, `"none"`) |
| `position`    | `"center"`    | Position on screen (`"center"`, `"top"`, `"bottom"`)                                |
| `shell`       | `vim.o.shell` | Shell to use for terminals                                                          |
| `auto_insert` | `true`        | Whether to automatically enter insert mode when opening a terminal                  |
| `auto_close`  | `false`       | Whether to close terminal when the process exits                                    |

### Keybindings

Define keybindings for different terminal instances:

```lua
keys = {
  t1 = "<leader>t1",  -- Toggle terminal 1
  t2 = "<leader>t2",  -- Toggle terminal 2
  t3 = "<leader>t3",  -- Toggle terminal 3
  -- Add more as needed
}
```

## Usage

- Use your configured keybindings (like `<leader>t1`, `<leader>t2`, etc.) to toggle different terminal instances
- Use `:FimTerm [id]` command to toggle a terminal with a specific ID
- Use `:FimCloseAll` to close all terminal windows (but preserve processes)
- Use `:FimKillAll` to completely kill all terminals and their processes
- Press `<ESC>` to exit insert mode in terminals

Each terminal instance maintains its state and running processes even when hidden. This makes it perfect for:

- Running multiple development servers
- Monitoring log outputs
- Running database clients
- Any task that requires a persistent terminal

## License

MIT
