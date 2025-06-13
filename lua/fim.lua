local M = {}

local term_buf = nil
local term_win = nil
local config = {
  start_with_insert = false,
}

local function create_float_win()
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local opts = {
    relative = "editor",
    width = width,
    height = height,
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
