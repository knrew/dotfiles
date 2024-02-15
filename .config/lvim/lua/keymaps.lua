-- buffer
lvim.keys.normal_mode["<C-PageDown>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<C-PageUp>"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<C-q>"] = ":BufferKill<CR>"

-- window
lvim.keys.normal_mode["ss"] = ":split<CR><C-w>w"
lvim.keys.normal_mode["sv"] = ":vsplit<CR><C-w>w"

-- lsp
lvim.keys.normal_mode["f"] = ":lua require('lvim.lsp.utils').format()<CR>"
lvim.keys.normal_mode["<leader>lr"] = ":lua vim.lsp.buf.rename()<CR>"

-- tree
lvim.keys.normal_mode["<leader>t"] = ":NeoTreeFocusToggle<CR>"
lvim.keys.normal_mode["<leader>e"] = ":NeoTreeFocus<CR>"
lvim.keys.normal_mode["<leader>c"] = ":NeoTreeClose<CR>"

-- misc
lvim.keys.insert_mode[","] = ",<Space>"
lvim.keys.normal_mode["<Esc>"] = ":w<CR>"

-- remove
lvim.keys.normal_mode["<space>c"] = false
