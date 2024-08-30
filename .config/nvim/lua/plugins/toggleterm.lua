local setup = function()
  require("toggleterm").setup({
    open_mapping = [[<C-\>]],
    hide_numbers = false,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factors = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
  })
end

return {
  "akinsho/toggleterm.nvim",
  version = "v2.11.0",
  config  = function()
    setup()
  end,
  enabled = true,
}
