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
        local commentstring = ts_comment.create_pre_hook()(...)
        if commentstring then
          return commentstring
        end
      end

      local commentstring = vim.bo.commentstring
      if type(commentstring) == "string" and commentstring:find("%%s") then
        return commentstring
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
        require("plugins.comment_commands").toggle_visual()
      end,
      mode = { "x", "s" },
      desc = "Toggle comment for selection",
    },
  },
}
