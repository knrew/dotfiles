local setup = function()
  local actions = require("telescope.actions")
  local icons = require("utils.icons")

  local mappings = {
    n = {
      ["<C-f>"] = actions.close,
    },
    i = {
      ["<C-f>"] = actions.close,
    },
  }

  local buffers_mappings = {
    i = {
    },
    n = {
    },
  }

  require("telescope").setup({
    defaults = {
      -- prompt_prefix = icons.ui.Telescope .. " ",
      -- selection_caret = icons.ui.Forward .. " ",
      -- entry_prefix = "  ",
      initial_mode = "insert",
      selection_strategy = "reset",
      -- sorting_strategy = nil,
      -- layout_strategy = nil,
      -- layout_config = {},
      vimgrep_arguments = {
        -- NOTE: ここのオプションが効いてないのでkeymapで対処中
        "rg",
        "--files",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--no-ignore-vcs",
        "--hidden",
        "--glob=!.git/",
      },
      mappings = mappings,
      file_ignore_patterns = {
        ".git/",
        "target/"
      },
      path_display = { "smart" },
      winblend = 0,
      border = {},
      borderchars = nil,
      color_devicons = true,
      -- set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {
        only_sort_text = true,
      },
      grep_string = {
        only_sort_text = true,
      },
      buffers = {
        initial_mode = "normal",
        mappings = buffers_mappings,
      },
      planets = {
        show_pluto = true,
        show_moon = true,
      },
      git_files = {
        hidden = true,
        show_untracked = true,
      },
      colorscheme = {
        enable_preview = true,
      },
    },
    extensions = {
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
  })

  pcall(function()
    require("telescope").load_extension("fzf")
  end)
end

return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    config = function()
      setup()
    end,
    lazy = true,
    cmd = "Telescope",
    enabled = true,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },
}
