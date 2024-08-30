local keymaps_normal = {
  -- buffer
  ["<C-h>"] = "<C-w>h",
  ["<C-j>"] = "<C-w>j",
  ["<C-k>"] = "<C-w>k",
  ["<C-l>"] = "<C-w>l",
  ["<C-Left>"] = "<C-w>h",
  ["<C-Up>"] = "<C-w>j",
  ["<C-Down>"] = "<C-w>k",
  ["<C-Right>"] = "<C-w>l",
  ["<C-PageDown>"] = ":BufferLineCycleNext<CR>",
  ["<C-PageUp>"] = ":BufferLineCyclePrev<CR>",
  ["<C-q>"] = ":bd<CR>",
  ["<C-u>"] = ":BufferLineCloseOthers<CR>",

  -- window
  ["ss"] = ":split<CR><C-w>w",
  ["sv"] = ":vsplit<CR><C-w>w",

  -- Resize with arrows
  ["<S-Up>"] = ":resize -2<CR>",
  ["<S-Down>"] = ":resize +2<CR>",
  ["<S-Left>"] = ":vertical resize -2<CR>",
  ["<S-Right>"] = ":vertical resize +2<CR>",

  -- misc
  ["<Esc>"] = ":w<CR>",
  -- ["<C-a>"] = "gg0v<S-g><S-$>",

  ["//"] = ":lua require(\"Comment.api\").toggle.linewise.current()<CR>",
}

local keymaps_insert = {
  [","] = ",<Space>",
}

local keymaps_visual = {
  ["//"] = ":lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>",
}

local keymaps_terminal = {}

for k, v in pairs(keymaps_normal) do
  vim.api.nvim_set_keymap("n", k, v, { noremap = true, silent = true })
end

for k, v in pairs(keymaps_insert) do
  vim.api.nvim_set_keymap("i", k, v, { noremap = true, silent = true })
end

for k, v in pairs(keymaps_visual) do
  vim.api.nvim_set_keymap("v", k, v, { noremap = true, silent = true })
end

for k, v in pairs(keymaps_terminal) do
  vim.api.nvim_set_keymap("t", k, v, { silent = true })
end
