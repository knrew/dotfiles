local opts = function()
  local icons = require("utils.icons")

  return {
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
      remove_blankline_trail = false,
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
  }
end

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = opts,
  config = function(_, ibl_opts)
    require("ibl").setup(ibl_opts)

    local hooks = require("ibl.hooks")
    hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
  end,
}
