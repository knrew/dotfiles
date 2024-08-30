return {
  "akinsho/bufferline.nvim",
  version = "v4.7.0",
  after = "catppuccin",
  config = function()
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get(),
    })
  end
}
