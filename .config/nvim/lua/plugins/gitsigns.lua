return {
  "lewis6991/gitsigns.nvim",
  config = function()
    require("gitsigns").setup()
  end,
  -- event = "User FileOpened",
  -- cmd = "Gitsigns",
  enabled = true,
}
