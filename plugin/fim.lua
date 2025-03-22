-- Plugin loader file for fim.nvim
-- This file will be auto-loaded by Neovim

-- Define commands for managing terminals
vim.api.nvim_create_user_command("FimTerm", function(cmd_opts)
  local id = tonumber(cmd_opts.args) or 1
  require("fim").toggle(id)
end, {
  nargs = "?",
  desc = "Open or toggle a floating terminal (with optional ID)",
})

vim.api.nvim_create_user_command("FimCloseAll", function()
  require("fim").close_all()
end, {
  desc = "Close all floating terminal windows (preserves processes)",
})

vim.api.nvim_create_user_command("FimKillAll", function()
  require("fim").kill_all()
end, {
  desc = "Kill all floating terminals and their processes",
})
