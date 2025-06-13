local M = {}

local term_buf = nil
local term_win = nil
local config = {
  start_with_insert = false,
  width = 0.8,
  height = 0.8,
  position = "center",
}

local function create_float_win()
  local width_ratio = config.width > 1 and config.width / 100 or config.width
  local height_ratio = config.height > 1 and config.height / 100 or config.height

  local win_width = math.floor(vim.o.columns * width_ratio)
  local win_height = math.floor(vim.o.lines * height_ratio)
  local row, col

  if config.position == "top" then
    row = 0
    col = math.floor((vim.o.columns - win_width) / 2)
  elseif config.position == "bottom" then
    row = vim.o.lines - win_height
    col = math.floor((vim.o.columns - win_width) / 2)
  elseif config.position == "left" then
    row = math.floor((vim.o.lines - win_height) / 2)
    col = 0
  elseif config.position == "right" then
    row = math.floor((vim.o.lines - win_height) / 2)
    col = vim.o.columns - win_width
  else -- center (default)
    row = math.floor((vim.o.lines - win_height) / 2)
    col = math.floor((vim.o.columns - win_width) / 2)
  end

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  term_win = vim.api.nvim_open_win(term_buf, true, opts)
end

local function create_term_buf()
  term_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_call(term_buf, function()
    vim.fn.termopen(vim.o.shell)
  end)
end

function M.toggle()
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, false)
    term_win = nil
  else
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
      create_term_buf()
    end
    create_float_win()
    if config.start_with_insert then
      vim.cmd "startinsert"
    end
  end
end

function M.setup(opts)
  opts = opts or {}
  config = vim.tbl_extend("force", config, opts)
  vim.keymap.set("t", "<A-i>", function()
    M.toggle()
  end, { desc = "Toggle floating terminal" })
end

return M
