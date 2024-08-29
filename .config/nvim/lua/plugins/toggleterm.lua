local keymaps_normal = {
  ["<C-\\>"] = ":ToggleTerm direction=float<CR>",
}

local keymaps_insert = {
  ["<C-\\>"] = ":ToggleTerm direction=float<CR>",
}

local keymaps_terminal = {
  ["<C-\\>"] = "<ESC>:ToggleTerm direction=float<CR>",
}

local setup = function()
  require("toggleterm").setup({ silent = true })
  vim.keymap.set("t", "<ESC>", [[<C-\><C-n>]], { silent = true })

  for k, v in pairs(keymaps_normal) do
    vim.api.nvim_set_keymap("n", k, v, { noremap = true, silent = true })
  end

  for k, v in pairs(keymaps_insert) do
    vim.api.nvim_set_keymap("i", k, v, { noremap = true, silent = true })
  end

  for k, v in pairs(keymaps_terminal) do
    vim.api.nvim_set_keymap("t", k, v, { silent = true })
  end
end

return {
  "akinsho/toggleterm.nvim",
  version = "v2.11.0",
  config  = function()
    setup()
  end,
  enabled = true,
}
