<div align = "center">

<h1>fim.nvim</h1>

<p align="center">
  <img src="https://img.shields.io/github/stars/dpi0/fim.nvim?style=flat-square&color=yellow" alt="Stars">
  <img src="https://img.shields.io/github/forks/dpi0/fim.nvim?style=flat-square" alt="Forks">
  <img src="https://img.shields.io/github/contributors/dpi0/fim.nvim?style=flat-square&color=pink" alt="Contributors">
  <img src="https://img.shields.io/github/license/dpi0/fim.nvim?style=flat-square" alt="License">
</p>

<h4>A simple Neovim plugin for managing floating terminal instances.</h4>

![screenshot-fim](https://github.com/user-attachments/assets/89109a36-19d7-45ee-92e1-dec4ce13b5cc)

</div>

## ⚡ Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "dpi0/fim.nvim",
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

## ⚙️ Configuration

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

**Default keybinds:**

```lua
keys = {
  t1 = "<leader>t1",  -- Toggle terminal 1
  t2 = "<leader>t2",  -- Toggle terminal 2
  t3 = "<leader>t3",  -- Toggle terminal 3
  -- Add more as needed
}
```

**My preferred way of toggling terminals:**

```lua
-- Helper function for mappings
local function bind(mode, lhs, rhs, opts)
  opts = opts or { noremap = true, silent = true }
  vim.keymap.set(mode, lhs, rhs, opts)
end

bind("n", "<A-y>", ":FimTerm 1<CR>")
bind("t", "<A-y>", "<C-\\><C-n>:FimTerm 1<CR>")
bind("i", "<A-y>", "<Esc>:FimTerm 1<CR>")

bind("n", "<A-i>", ":FimTerm 2<CR>")
bind("t", "<A-i>", "<C-\\><C-n>:FimTerm 2<CR>")
bind("i", "<A-i>", "<Esc>:FimTerm 2<CR>")
```

## 💡 Usage

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

## Contributing

Contributions are welcome! If you have any ideas, suggestions, or bug reports, please open an issue or submit a pull request.
