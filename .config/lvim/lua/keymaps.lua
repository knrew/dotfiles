local keymaps_normal = {
  -- buffer
  ["<C-PageDown>"] = ":BufferLineCycleNext<CR>",
  ["<C-PageUp>"] = ":BufferLineCyclePrev<CR>",
  ["<C-q>"] = ":BufferKill<CR>",

  -- -- window
  ["ss"] = ":split<CR><C-w>w",
  ["sv"] = ":vsplit<CR><C-w>w",

  -- -- lsp
  ["f"] = ":lua require('lvim.lsp.utils').format()<CR>:w<CR>",
  ["<leader>lr"] = ":lua vim.lsp.buf.rename()<CR>",

  -- -- tree
  ["<leader>t"] = ":NeoTreeFocusToggle<CR>",
  ["<leader>e"] = ":NeoTreeFocus<CR>",
  ["<leader>c"] = ":NeoTreeClose<CR>",

  -- -- misc
  ["<Esc>"] = ":w<CR>",
  ["<leader>rr"] = ":LvimReload<CR>",
  ["<C-a>"] = "gg0v<S-g>",
}

local keymaps_insert = {
  [","] = ",<Space>",
}

for k, v in pairs(keymaps_normal) do
  lvim.keys.normal_mode[k] = v
end

for k, v in pairs(keymaps_insert) do
  lvim.keys.insert_mode[k] = v
end
