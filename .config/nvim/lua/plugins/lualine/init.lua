local setup = function()
  local components = require("plugins.lualine.components")

  local default_sections = {
    lualine_a = {
      components.mode
    },
    lualine_b = {
      components.filename_full,
    },
    lualine_c = {
      components.diff
    },
    lualine_x = {
      components.diagnostics,
    },
    lualine_y = {
      components.lsp,
    },
    lualine_z = {
      components.location,
    }
  }

  local toggleterm_sections = {
    lualine_a = { components.mode },
    lualine_b = { components.branch },
    lualine_c = { components.filename_simple },
    lualine_x = {},
    lualine_y = { components.datetime },
    lualine_z = { components.location }
  }

  local neotree_sections = {
    lualine_a = { components.mode },
    lualine_b = { components.branch },
    lualine_c = { components.filename_simple },
    lualine_x = {},
    lualine_y = { components.datetime },
    lualine_z = { components.location }
  }

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
    sections = default_sections,
    inactive_sections = {
      lualine_a = { "mode" },
    },
    tabline = {},
    winbar = {
      lualine_a = {
      },
      lualine_c = { components.navic },
      lualine_x = {
        function()
          return " "
        end
      }
    },
    inactive_winbar = {},
    extensions = {
      {
        filetypes = { "neo-tree" },
        sections = neotree_sections,
        winbar = {},
      },
      {
        filetypes = { "toggleterm" },
        sections = toggleterm_sections,
      },
    },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  after = "nvim-navic",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    setup()
  end,
}
