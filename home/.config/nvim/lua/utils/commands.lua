local M = {}

function M.register(commands, common_opts)
  local default_opts = common_opts or { force = true }

  for _, cmd in ipairs(commands) do
    local opts = vim.tbl_deep_extend("force", default_opts, cmd.opts or {})
    vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
  end
end

return M
