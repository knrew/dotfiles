local setup = function()
  -- local icons = require("utils.icons")
  require("nvim-navic").setup({})
end

return {
  "SmiteshP/nvim-navic",
  config = function()
    setup()
  end,
  event = "User FileOpened",
  enabled = true,
}
