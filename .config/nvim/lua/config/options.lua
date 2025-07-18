local options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 1,
  completeopt = { "menuone", "noselect" },
  conceallevel = 0,
  encoding = "utf-8",
  fileencoding = "utf-8",
  foldmethod = "manual",
  foldexpr = "",
  hidden = true,
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  pumheight = 10,
  showmode = false,
  smartcase = true,
  smartindent = true,
  splitbelow = false,
  splitright = false,
  swapfile = false,
  timeoutlen = 1000,
  title = true,
  -- undodir = undodir,
  undofile = true,
  updatetime = 100,
  writebackup = false,
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  showtabline = 2,
  cursorline = true,
  number = true,
  relativenumber = false,
  numberwidth = 4,
  signcolumn = "yes",
  wrap = true,
  -- shade_file=,
  scrolloff = 8,
  sidescrolloff = 8,
  showcmd = false,
  ruler = false,
  laststatus = 3,

  spelllang = "cjk",
  shortmess = "cI",
  whichwrap = "<,>,[,],h,l",
}

local setup = function()
  for k, v in pairs(options) do
    vim.opt[k] = v
  end

  -- vim.opt.spelllang:append("cjk")
  -- vim.opt.shortmess:append("c")
  -- vim.opt.shortmess:append("I")
  -- vim.opt.whichwrap:append("<,>,[,],h,l")

  -- setup diagnostics
  local icons = require("utils.icons")
  local default_diagnostic_config = {
    signs = {
      active = true,
      text = {
        [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
        [vim.diagnostic.severity.WARN] = icons.diagnostics.Warning,
        [vim.diagnostic.severity.INFO] = icons.diagnostics.Information,
        [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
      }
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

  -- inlay hint enabled
  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { 0 })
  end
end

setup()
