return {
  "numToStr/Comment.nvim",
  main = "Comment",
  opts = {
    padding = true,
    sticky = true,
    ignore = "^$",
    mappings = {
      basic = true,
      extra = true,
    },
    toggler = {
      line = "gcc",
      block = "gbc",
    },
    opleader = {
      line = "gc",
      block = "gb",
    },
    extra = {
      above = "gcO",
      below = "gco",
      eol = "gcA",
    },
    pre_hook = function(...)
      local loaded, ts_comment =
        pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if loaded and ts_comment then
        return ts_comment.create_pre_hook()(...)
      end
    end,
    post_hook = nil,
  },
  keys = {
    { "gc", mode = { "n", "v" } },
    { "gb", mode = { "n", "v" } },
    {
      "<leader>/",
      function()
        require("plugins.comment_commands").toggle_current()
      end,
      mode = "n",
      desc = "Toggle comment",
    },
    {
      "<leader>/",
      function()
        require("plugins.comment_commands").toggle_current()
      end,
      mode = "v",
      desc = "Toggle comment",
    },
    {
      "<leader>/",
      function()
        require("plugins.comment_commands").toggle_visual()
      end,
      mode = "x",
      desc = "Toggle comment for selection",
    },
  },
}
