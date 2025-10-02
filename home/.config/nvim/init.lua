vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.lazy")

require("config.lsp")
require("config.cmp")

require("config.commands")
require("config.options")
require("config.keymaps")

pcall(require, "config.local")
