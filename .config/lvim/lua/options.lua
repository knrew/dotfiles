local options = {
  encoding = "utf-8",
  fileencoding = "utf-8",
  title = true,
  -- backup = false,
  clipboard = "unnamedplus",
  cmdheight = 1,
  completeopt = { "menuone" },
  conceallevel = 0,
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  pumheight = 10,
  showmode = false,
  showtabline = 2,
  smartcase = true,
  smartindent = true,
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  cursorline = true,
  number = true,
  relativenumber = false,
  wrap = true,
}

vim.opt.shortmess:append("c")

for k, v in pairs(options) do
  vim.opt[k] = v
end

