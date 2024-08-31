local setup = function()
  local icons = require("utils.icons")

  require("ibl").setup({
    indent = {
      char = icons.ui.LineLeft,
    },
    scope = {
      enabled = true,
      char = icons.ui.LineLeft,
      show_start = false,
      show_end = false,
    },
    whitespace = {
      remove_blankline_trail = false
    },
    exclude = {
      buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
      filetypes = {
        "lspinfo",
        "packer",
        "checkhealth",
        "help",
        "man",
        "gitcommit",
        "TelescopePrompt",
        "TelescopeResults",
        "''",
        "lazy",
      },
    },
  })

  local hooks = require("ibl.hooks")
  hooks.register(
    hooks.type.WHITESPACE,
    hooks.builtin.hide_first_space_indent_level
  )
end

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    setup()
  end,
  -- event = { "User FileOpened", "BufReadPost", "VimEnter" }
}
