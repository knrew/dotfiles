local setup = function()
  local components = require("plugins.lualine.components")

  require("lualine").setup({
    options = {
      icons_enabled = true,
      theme = "catppuccin",
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
      disabled_filetypes = {
        statusline = {},
        winbar = {},
      },
      ignore_focus = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { components.mode },
      lualine_b = { components.branch },
      lualine_c = { components.filename, components.diff },
      lualine_x = {
        components.diagnostics,
        components.lsp,
        components.spaces,
        components.filetype,
      },
      lualine_y = { components.location },
      lualine_z = { components.progress }
    },
    inactive_sections = {
      lualine_a = { components.mode },
      lualine_b = { components.branch },
      lualine_c = { components.diff },
      lualine_x = {
        components.diagnostics,
        components.lsp,
        components.spaces,
        components.filetype
      },
      lualine_y = { components.location },
      lualine_z = { components.progress }
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {},
  })
end

return {
  "nvim-lualine/lualine.nvim",
  branch = "master",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    setup()
  end,
  -- event = "VimEnter",
}
