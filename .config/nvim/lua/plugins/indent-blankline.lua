local setup = function()
  local icons = require("utils.icons")

  local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
  }

  require("ibl").setup({
    indent = {
      -- highlight = highlight,
      -- char = icons.ui.LineLeft,
    },
    whitespace = {
      remove_blankline_trail = false
    },
    scope = {
      enabled = true,
      highlight = highlight,
      char = icons.ui.LineLeft,
    },
    exclude = {}
  })

  -- local hooks = require("ibl.hooks")
  -- hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  opts = {},
  config = function()
    setup()
  end,
  event = { "User FileOpened", "BufReadPost", "VimEnter" }
}
