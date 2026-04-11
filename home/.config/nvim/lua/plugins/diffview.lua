return {
  "sindrets/diffview.nvim",
  opts = function()
    local actions = require("diffview.actions")

    local close_diffview_in_pannel = function()
      actions.close()
      actions.close()
    end

    return {
      keymaps = {
        disable_defaults = false,
        view = {
          { "n", "q", actions.close, { desc = "Close Diffview" } },
          { "n", "<ESC>", actions.close, { desc = "Close Diffview" } },
          { "n", "t", actions.toggle_files, { desc = "Toggle Panel" } },
        },
        diff1 = {},
        diff2 = {},
        diff3 = {},
        diff4 = {},
        file_panel = {
          { "n", "q", close_diffview_in_pannel, { desc = "Close DiffView" } },
          { "n", "<ESC>", close_diffview_in_pannel, { desc = "Close DiffView" } },
          { "n", "t", actions.toggle_files, { desc = "Toggle Panel" } },
        },
        file_history_panel = {},
        option_panel = {},
        help_panel = {},
      },
    }
  end,
  cmd = { "DiffviewOpen" },
  lazy = true,
  keys = {
    {
      "df",
      function()
        vim.cmd("DiffviewOpen")
        vim.cmd("DiffviewToggleFiles")
      end,
      mode = "n",
      desc = "Open Diffview",
    },
  },
}
