local opts = function()
  local actions = require("telescope.actions")

  local mappings = {
    n = {
      ["<C-f>"] = actions.close,
    },
    i = {
      ["<C-f>"] = actions.close,
    },
  }

  local buffers_mappings = {
    i = {},
    n = {},
  }

  return {
    defaults = {
      initial_mode = "insert",
      selection_strategy = "reset",
      vimgrep_arguments = {
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
        "target/",
      },
      path_display = { "smart" },
      winblend = 0,
      border = {},
      borderchars = nil,
      color_devicons = true,
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
  }
end

return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    opts = opts,
    config = function(_, telescope_opts)
      require("telescope").setup(telescope_opts)

      pcall(function()
        require("telescope").load_extension("fzf")
      end)
    end,
    lazy = true,
    cmd = "Telescope",
    keys = {
      {
        "<C-f>",
        "<cmd>Telescope find_files find_command=rg,--files,--no-ignore,--hidden<cr>",
        mode = "n",
        desc = "Find files including hidden and ignored",
      },
      {
        "<C-M-f>",
        "<cmd>Telescope find_files find_command=rg,--files<cr>",
        mode = "n",
        desc = "Find files",
      },
    },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    lazy = true,
  },
}
