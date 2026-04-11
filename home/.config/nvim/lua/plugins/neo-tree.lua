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
      commands = {
        -- Override delete to use trash instead of rm(with confirm)
        delete = function(state)
          local inputs = require("neo-tree.ui.inputs")

          local node = state.tree:get_node()
          if node.type == "message" then
            return
          end

          local path = node.path
          local _, name = require("neo-tree.utils").split_path(path)
          local msg = string.format("Are you sure you want to trash '%s'?", name)

          inputs.confirm(msg, function(confirmed)
            if not confirmed then
              return
            end
            if vim.fn.executable("trash") == 1 then
              local result = vim.fn.system({ "trash", vim.fn.fnameescape(path) })
              if vim.v.shell_error ~= 0 then
                vim.notify("Failed to trash file: " .. path .. "\n" .. result, vim.log.levels.ERROR)
                return
              end

              require("neo-tree.sources.manager").refresh(state)
            else
              vim.notify(
                "The 'trash' command is not installed. Please install it to use this feature.",
                vim.log.levels.ERROR
              )
            end
          end)
        end,
      },
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          "node_modules",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
          ".git",
        },
      },
    },
    event_handlers = {
      {
        event = "file_open_requested",
        handler = function()
          require("neo-tree.command").execute({ action = "close" })
        end,
      },
    },
  })
end

local function setup_keymaps()
  vim.keymap.set("n", "<C-t>", "<cmd>Neotree toggle<cr>", {
    noremap = true,
    silent = true,
  })
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- Optional image support for file preview: See `# Preview Mode` for more information.
    -- {"3rd/image.nvim", opts = {}},
    -- OR use snacks.nvim's image module:
    -- "folke/snacks.nvim",
  },
  config = function()
    setup()
    setup_keymaps()
  end,
}
