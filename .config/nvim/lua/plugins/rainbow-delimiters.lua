return {
  "HiPhish/rainbow-delimiters.nvim",
  config = function()
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
      -- highlight = highlight,
    })
  end
}
