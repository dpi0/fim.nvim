-- Main module file for fim.nvim plugin
local M = {}

-- Store the module's config
local default_config = {
  opts = {
    -- Default terminal dimensions (percentage of screen)
    width = 0.75,
    height = 0.5,
    -- Border style: 'single', 'double', 'rounded', 'solid', 'shadow', or 'none'
    border = "single",
    -- Default position
    position = "center",
    -- Shell to use (defaults to user's shell)
    shell = vim.o.shell,
    -- Whether to automatically enter insert mode when opening terminal
    auto_insert = true,
    -- Whether to close terminal when process exits
    auto_close = false,
  },
  keys = {
    t1 = "<leader>t1",
    t2 = "<leader>t2",
    t3 = "<leader>t3",
  },
}

-- Plugin state
local config = {}
local terminals = {}

-- Function to create the floating window
local function create_float_window()
  local opts = config.opts
  local width = math.floor(vim.o.columns * opts.width)
  local height = math.floor(vim.o.lines * opts.height)

  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Adjust position if not center
  if opts.position == "top" then
    row = 3
  elseif opts.position == "bottom" then
    row = vim.o.lines - height - 3
  end

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = opts.border,
  }

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")

  -- Create the window
  local win = vim.api.nvim_open_win(buf, true, win_opts)

  -- Apply some window settings
  vim.api.nvim_win_set_option(win, "winblend", 0)
  vim.api.nvim_win_set_option(win, "winhl", "Normal:Normal")

  return { buf = buf, win = win }
end

-- Function to create a new terminal
local function create_terminal(id)
  -- Create window and buffer
  local float = create_float_window()

  -- Open terminal in the buffer
  vim.fn.termopen(config.opts.shell)

  -- Set buffer options for terminal
  vim.api.nvim_buf_set_option(float.buf, "buflisted", false)

  -- Store the terminal info
  terminals[id] = float

  -- Add buffer-local mappings
  vim.api.nvim_buf_set_keymap(float.buf, "t", "<ESC>", "<C-\\><C-n>", { noremap = true, silent = true })

  -- Automatically enter insert mode when opening terminal
  if config.opts.auto_insert then
    vim.cmd("startinsert")
  end

  -- Auto-close handler - only if enabled
  if config.opts.auto_close then
    vim.api.nvim_buf_attach(float.buf, false, {
      on_detach = function()
        -- This will only be triggered if the buffer is completely detached
        -- (which happens if you :bdelete the buffer)
        if terminals[id] then
          terminals[id] = nil
        end
      end,
    })
  end

  return float
end

-- Toggle terminal function
function M.toggle(id)
  id = id or 1 -- Default to terminal 1

  -- If terminal exists and is valid
  if terminals[id] and vim.api.nvim_buf_is_valid(terminals[id].buf) then
    -- Check if terminal window is already open/visible
    if terminals[id].win and vim.api.nvim_win_is_valid(terminals[id].win) then
      -- Just hide the window without closing the buffer
      vim.api.nvim_win_hide(terminals[id].win)
      terminals[id].win = nil
    else
      -- Reopen the window for the existing buffer
      local opts = config.opts
      terminals[id].win = vim.api.nvim_open_win(terminals[id].buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * opts.width),
        height = math.floor(vim.o.lines * opts.height),
        row = math.floor((vim.o.lines - math.floor(vim.o.lines * opts.height)) / 2),
        col = math.floor((vim.o.columns - math.floor(vim.o.columns * opts.width)) / 2),
        style = "minimal",
        border = opts.border,
      })

      -- Automatically enter insert mode when reopening terminal
      if opts.auto_insert then
        vim.cmd("startinsert")
      end
    end
  else
    -- Create new terminal
    create_terminal(id)
  end
end

-- Setup function that accepts user's configuration format
function M.setup(user_config)
  -- Initialize with defaults
  config = vim.deepcopy(default_config)

  -- Merge user config with defaults
  if user_config then
    if user_config.opts then
      config.opts = vim.tbl_deep_extend("force", config.opts, user_config.opts)
    end

    if user_config.keys then
      config.keys = vim.tbl_deep_extend("force", config.keys, user_config.keys)
    end
  end

  -- Set up keymappings
  if config.keys then
    -- Setup terminal keybindings (t1, t2, t3, etc.)
    for key, mapping in pairs(config.keys) do
      local id = tonumber(key:match("t(%d+)"))
      if id then
        vim.keymap.set("n", mapping, function()
          M.toggle(id)
        end, { noremap = true, silent = true, desc = "Toggle terminal " .. id })
      end
    end
  end

  return M
end

-- Function to close all terminal windows (but keep buffers)
function M.close_all()
  for id, term in pairs(terminals) do
    if term.win and vim.api.nvim_win_is_valid(term.win) then
      vim.api.nvim_win_hide(term.win)
      terminals[id].win = nil
    end
  end
end

-- Function to kill all terminals (close buffers and windows)
function M.kill_all()
  for id, term in pairs(terminals) do
    if term.win and vim.api.nvim_win_is_valid(term.win) then
      vim.api.nvim_win_close(term.win, true)
    end
    if term.buf and vim.api.nvim_buf_is_valid(term.buf) then
      vim.api.nvim_buf_delete(term.buf, { force = true })
    end
  end
  terminals = {}
end

return M
