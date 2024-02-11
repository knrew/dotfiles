-- local opts = { noremap = true, silent = true }
-- local term_opts = { silent = true }
-- local keymap = vim.api.nvim_set_keymap
-- keymap("i", ",", ",<Space>", opts)

lvim.keys.normal_mode["f"] = ":w<cr>"
lvim.keys.normal_mode["<Esc>"] = ":w<cr>"
lvim.keys.normal_mode["<C-a>"] = "ggv<S-g>yy"
lvim.keys.normal_mode["dl"] = "yy<cr>p"

-- lvim.keys.insert_mode["<leader>f"] = "<Esc>:w<cr>"
lvim.keys.insert_mode["<Esc>"] = "<Esc>:w<cr>"
lvim.keys.insert_mode[","] = ",<Space>"
