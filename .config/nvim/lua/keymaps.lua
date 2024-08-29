local keymaps_normal = {
  -- buffer
  ["<C-h>"] = "<C-w>h",
  ["<C-j>"] = "<C-w>j",
  ["<C-k>"] = "<C-w>k",
  ["<C-l>"] = "<C-w>l",
  ["<C-PageDown>"] = ":BufferLineCycleNext<CR>",
  ["<C-PageUp>"] = ":BufferLineCyclePrev<CR>",
  ["<leader>q"] = ":bd<CR>",
  ["<C-q>"] = ":BufferLineCloseOthers<CR>",

  -- window
  ["ss"] = ":split<CR><C-w>w",
  ["sv"] = ":vsplit<CR><C-w>w",

  -- Resize with arrows
  ["<C-Up>"] = ":resize -2<CR>",
  ["<C-Down>"] = ":resize +2<CR>",
  ["<C-Left>"] = ":vertical resize -2<CR>",
  ["<C-Right>"] = ":vertical resize +2<CR>",

  -- misc
  ["<Esc>"] = ":w<CR>",
  ["<C-a>"] = "gg0v<S-g><S-$>",
}

local keymaps_insert = {
  [","] = ",<Space>",
}

local keymaps_terminal = {}

for k, v in pairs(keymaps_normal) do
  vim.api.nvim_set_keymap("n", k, v, { noremap = true, silent = true })
end

for k, v in pairs(keymaps_insert) do
  vim.api.nvim_set_keymap("i", k, v, { noremap = true, silent = true })
end

for k, v in pairs(keymaps_terminal) do
  vim.api.nvim_set_keymap("t", k, v, { silent = true })
end
