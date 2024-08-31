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
  -- ["<C-p>"] = ":BufferLinePick<CR>",

  -- window
  ["ss"] = ":split<CR><C-w>w",
  ["sv"] = ":vsplit<CR><C-w>w",
  ["<S-Up>"] = ":resize -2<CR>",
  ["<S-Down>"] = ":resize +2<CR>",
  ["<S-Left>"] = ":vertical resize -2<CR>",
  ["<S-Right>"] = ":vertical resize +2<CR>",

  -- tree
  ["<C-t>"] = ":Neotree toggle<CR>",

  -- comment
  ["<leader>/"] = ":lua require(\"Comment.api\").toggle.linewise.current()<CR>",

  -- misc
  ["<Esc>"] = ":w<CR>",
  ["<C-a>"] = "gg0v<S-g><S-$>",
  ["<leader>h"] = ":nohlsearch<CR>",
  ["<leader>H"] = ":set hlsearch<CR>",
}

local keymaps_insert = {
  [","] = ",<Space>",
}

local keymaps_visual = {
  -- comment
  ["<leader>/"] = ":lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>",
}

local keymaps_terminal = {}

local default_opts = { noremap = true, silent = true }

local setup = function()
  for k, v in pairs(keymaps_normal) do
    vim.api.nvim_set_keymap("n", k, v, default_opts)
  end

  for k, v in pairs(keymaps_insert) do
    vim.api.nvim_set_keymap("i", k, v, default_opts)
  end

  for k, v in pairs(keymaps_visual) do
    vim.api.nvim_set_keymap("v", k, v, default_opts)
  end

  for k, v in pairs(keymaps_terminal) do
    vim.api.nvim_set_keymap("t", k, v, default_opts)
  end
end

return {
  setup = setup,
}
