local keymaps_normal = {
  -- move window
  ["<C-h>"] = "<C-w>h",
  ["<C-j>"] = "<C-w>j",
  ["<C-k>"] = "<C-w>k",
  ["<C-l>"] = "<C-w>l",
  ["<C-Left>"] = "<C-w>h",
  ["<C-Up>"] = "<C-w>j",
  ["<C-Down>"] = "<C-w>k",
  ["<C-Right>"] = "<C-w>l",
  -- resize window
  ["<C-S-Up>"] = "<cmd>resize -2<cr>",
  ["<C-S-Down>"] = "<cmd>resize +2<cr>",
  ["<C-S-Left>"] = "<cmd>vertical resize -2<cr>",
  ["<C-S-Right>"] = "<cmd>vertical resize +2<cr>",
  -- split window
  ["ss"] = "<cmd>split<cr><C-w>w",
  ["sv"] = "<cmd>vsplit<cr><C-w>w",

  -- buffer
  ["<C-PageDown>"] = "<cmd>BufferLineCycleNext<cr>",
  ["<C-PageUp>"] = "<cmd>BufferLineCyclePrev<cr>",
  ["<C-q>"] = "<cmd>bd<cr>",
  ["<C-S-q>"] = "<cmd>bd!<cr>",
  ["<C-u>"] = "<cmd>BufferLineCloseOthers<cr>",

  -- select all
  ["<C-a>"] = "gg0v<S-g><S-$>",
  ["<C-S-a>"] = "v<S-g><S-$>",
  -- ESC to save
  ["<esc>"] = "<cmd>w<cr>",
  -- delete without yank
  ["x"] = "\"_d",
  ["xx"] = "\"_dd",
  ["X"] = "\"_D",
  -- undo/redo
  ["z"] = "u",
  ["<S-z>"] = "<C-r>",
  ["u"] = "<nop>",
  -- suspend vim
  ["<C-M-q>"] = "<C-z>",
  ["<C-z>"] = "<nop>",

  -- lsp
  ["f"] = "<cmd>Format<cr><cmd>w<cr>",
  ["rn"] = "<cmd>Rename<cr>",
  ["<leader>h"] = "<cmd>ToggleInlayHint<cr>",

  -- tree
  ["<C-t>"] = "<cmd>Neotree toggle<cr>",

  -- telescope
  ["<C-f>"] = "<cmd>Telescope find_files<cr>",

  -- comment
  ["<leader>/"] = "<cmd>ToggleCommentNormal<cr>",

  -- terminal
  -- ["<leader>t"] = "<cmd>terminal<cr>",

  -- lazygit
  ["lg"] = "<cmd>terminal lazygit<cr>i",

  -- diffview
  ["df"] = "<cmd>DiffviewOpen<cr><cmd>DiffviewToggleFiles<cr>",

  -- markdown preview
  ["md"] = "<cmd>MarkdownPreview<cr>",
}

local keymaps_insert = {
  [","] = ",<Space>",
}

local keymaps_visual = {
  ["<leader>/"] = "<cmd>ToggleCommentNormal<cr>",
}

local keymaps_select = {
  ["<leader>/"] = "<cmd>ToggleCommentSelect<cr>",

  -- delete without yank
  ["x"] = "\"_d",
}

local keymaps_terminal = {
  -- ["<ESC>"] = "<C-\\><C-n>",
}

local default_opts = { noremap = true, silent = true, desc = "defined in keymaps.lua" }

local setup = function()
  for k, v in pairs(keymaps_normal) do
    vim.keymap.set("n", k, v, default_opts)
  end

  for k, v in pairs(keymaps_insert) do
    vim.keymap.set("i", k, v, default_opts)
  end

  for k, v in pairs(keymaps_visual) do
    vim.keymap.set("v", k, v, default_opts)
  end

  for k, v in pairs(keymaps_select) do
    vim.keymap.set("x", k, v, default_opts)
  end

  for k, v in pairs(keymaps_terminal) do
    vim.keymap.set("t", k, v, default_opts)
  end
end

return {
  setup = setup,
}
