return {
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
    local rainbow_delimiters = require 'rainbow-delimiters'

    local highlight = {
      "RainbowRed",
      "RainbowYellow",
      "RainbowBlue",
      "RainbowOrange",
      "RainbowGreen",
      "RainbowViolet",
      "RainbowCyan",
    }
    require("rainbow-delimiters.setup").setup({
      strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        vim = rainbow_delimiters.strategy['local'],
      },
      highlight = highlight,
    })
  end
}
