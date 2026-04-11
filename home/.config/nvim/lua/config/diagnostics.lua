local icons = require("utils.icons")

local default_diagnostic_config = {
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
      [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
      [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
      [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = true,
    style = "minimal",
    border = "single",
    source = "always",
    header = "",
    prefix = "",
  },
}

vim.diagnostic.config(default_diagnostic_config)
