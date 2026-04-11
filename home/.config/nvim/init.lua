vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

require("config.options")
require("config.diagnostics")
require("config.commands")
require("config.keymaps")

pcall(require, "config.local")
