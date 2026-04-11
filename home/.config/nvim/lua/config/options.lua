local global_options = {
  backup = false,
  clipboard = "unnamedplus",
  cmdheight = 1,
  encoding = "utf-8",
  hidden = true,
  hlsearch = true,
  ignorecase = true,
  mouse = "a",
  pumheight = 10,
  showmode = false,
  smartcase = true,
  splitbelow = false,
  splitright = false,
  timeoutlen = 1000,
  title = true,
  updatetime = 100,
  writebackup = false,
  showtabline = 2,
  showcmd = false,
  ruler = false,
  laststatus = 3,
  whichwrap = "<,>,[,],h,l",
  shortmess = "cIF",
}

local buffer_local_options = {
  completeopt = { "menuone", "noselect" },
  fileencoding = "utf-8",
  smartindent = true,
  swapfile = false,
  -- undodir = undodir,
  undofile = true,
  expandtab = true,
  shiftwidth = 2,
  tabstop = 2,
  spelllang = "cjk",
}

local window_local_options = {
  conceallevel = 0,
  foldmethod = "manual",
  foldexpr = "",
  cursorline = true,
  number = true,
  relativenumber = false,
  numberwidth = 4,
  signcolumn = "yes",
  wrap = true,
  -- shade_file=,
  scrolloff = 8,
  sidescrolloff = 8,
}

local function set_options(target, values)
  for key, value in pairs(values) do
    target[key] = value
  end
end

set_options(vim.opt, global_options)
set_options(vim.opt_global, buffer_local_options)
set_options(vim.opt_global, window_local_options)

-- Apply local options to the current editing context without touching special
-- buffers during config reload.
if vim.bo.buftype == "" then
  for key, value in pairs(buffer_local_options) do
    if key ~= "fileencoding" or vim.bo.modifiable then
      vim.opt_local[key] = value
    end
  end

  set_options(vim.opt_local, window_local_options)
end
