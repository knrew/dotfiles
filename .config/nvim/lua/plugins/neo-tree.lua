local setup = function()
  require("neo-tree").setup({
    close_if_last_window = false,
    window = {
      width = 30,
    },
    buffers = {
      follow_current_file = {
        enabled = true,
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          "node_modules"
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
          ".git"
        },
      },
    },
    event_handlers = {
      {
        event = "file_open_requested",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end
      },
    }
  })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  -- branch = "v3.x"
  version = "3.26",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
    "3rd/image.nvim",
  },
  config = function()
    setup()
  end,
  enabled = true,
}
