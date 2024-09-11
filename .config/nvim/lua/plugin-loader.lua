local plugins = {
  require("plugins.catppuccin"),
  require("plugins.neo-tree"),
  require("plugins.toggleterm"),
  require("plugins.lualine"),
  require("plugins.bufferline"),
  require("plugins.lsp"),
  require("plugins.cmp"),
  require("plugins.comment"),
  require("plugins.rainbow-delimiters"),
  require("plugins.treesitter"),
  require("plugins.indent-blankline"),
  require("plugins.navic"),
  require("plugins.web-devicons"),
  require("plugins.telescope"),
  require("plugins.diffview"),
  require("plugins.obsidian-bridge"),
  require("plugins.plenary"),
  require("plugins.copilot"),
}

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = { plugins },
  ui = { border = "single" },
  checker = { enabled = false },
})
