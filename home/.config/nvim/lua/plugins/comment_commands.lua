local M = {}

function M.toggle_current()
  require("Comment.api").toggle.linewise.current()
end

function M.toggle_visual()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end

return M
