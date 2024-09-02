require("plugins.lsp.setup").setup()
require("plugins.cmp.setup").setup()
require("options").setup()
require("keymaps").setup()
require("commands").setup()
local status_ok, config_local = pcall(require, "config_local")
if status_ok then
  config_local.setup()
end
