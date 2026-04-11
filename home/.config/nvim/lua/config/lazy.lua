local plugin_modules = {
  "plugins.catppuccin",
  "plugins.neo-tree",
  "plugins.toggleterm",
  "plugins.lualine",
  "plugins.bufferline",
  "plugins.lsp",
  "plugins.cmp",
  "plugins.comment",
  "plugins.rainbow-delimiters",
  "plugins.treesitter",
  "plugins.indent-blankline",
  "plugins.navic",
  "plugins.telescope",
  "plugins.diffview",
  "plugins.markdown-preview",
}

local plugins = vim.tbl_map(require, plugin_modules)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out =
    vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = plugins,
  ui = { border = "single" },
  checker = { enabled = false },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
})
