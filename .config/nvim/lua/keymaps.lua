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
  ["<C-PageDown>"] = "<cmd>BufferLineCycleNext<CR>",
  ["<C-PageUp>"] = "<cmd>BufferLineCyclePrev<CR>",
  ["<C-q>"] = "<cmd>bd<CR>",
  ["<C-S-q>"] = "<cmd>bd!<CR>",
  ["<C-u>"] = "<cmd>BufferLineCloseOthers<CR>",
  -- ["<C-p>"] = ":BufferLinePick<CR>",

  -- window
  ["ss"] = "<cmd>split<CR><C-w>w",
  ["sv"] = "<cmd>vsplit<CR><C-w>w",
  ["<C-S-Up>"] = "<cmd>resize -2<CR>",
  ["<C-S-Down>"] = "<cmd>resize +2<CR>",
  ["<C-S-Left>"] = "<cmd>vertical resize -2<CR>",
  ["<C-S-Right>"] = "<cmd>vertical resize +2<CR>",

  -- lsp
  ["f"] = "<cmd>lua require(\"plugins.lsp.formatter\").format()<CR>:w<CR>",
  ["lr"] = "<cmd>lua vim.lsp.buf.rename()<CR>",

  -- tree
  ["<C-t>"] = "<cmd>Neotree toggle<CR>",

  -- comment
  ["<leader>/"] = "<cmd>lua require(\"Comment.api\").toggle.linewise.current()<CR>",

  -- terminal
  ["<leader>t"] = "<cmd>terminal<cr>",

  -- lazygit
  ["lg"] = "<cmd>terminal lazygit<cr>i",

  -- misc
  ["<Esc>"] = "<cmd>w<CR>",
  ["<C-a>"] = "gg0v<S-g><S-$>",
  ["<leader>h"] = "<cmd>nohlsearch<CR>",
  ["<leader>H"] = "<cmd>set hlsearch<CR>",
}

local keymaps_insert = {
  [","] = ",<Space>",
}

local keymaps_visual = {}

local keymaps_terminal = {
  -- ["<ESC>"] = "<C-\\><C-n>",
}

local default_opts = { noremap = true, silent = true, }

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

  -- comment(select)
  vim.keymap.set("x",
    "<leader>/",
    function()
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end,
    default_opts
  )
end

return {
  setup = setup,
}
