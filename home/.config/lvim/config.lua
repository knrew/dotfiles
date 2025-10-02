-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

require("options")
require("keymaps")

lvim.format_on_save = false
lvim.builtin.treesitter.rainbow.enable = true
lvim.builtin.nvimtree.active = false -- NOTE: using neo-tree
lvim.builtin.terminal.direction = "float"
-- lvim.lsp.automatic_servers_installation = true
lvim.lsp.installer.setup.automatic_installation = false

lvim.colorscheme = "catppuccin"
-- lvim.builtin.lualine.options.theme = "catppuccin"

lvim.plugins = {}
table.insert(lvim.plugins, require("plugins.catppuccin"))
table.insert(lvim.plugins, require("plugins.neo-tree"))
table.insert(lvim.plugins, require("plugins.nvim-ts-rainbow"))
table.insert(lvim.plugins, require("plugins.vimtex"))
