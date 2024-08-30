local toggle_key = "//"

local keymaps_normal = {
  toggle_key = ":lua require(\"Comment.api\").toggle.linewise.current()<CR>",
}

local keymaps_visual = {
  toggle_key = ":lua require(\"Comment.api\").toggle.linewise(vim.fn.visualmode())<CR>",
}

local setup = function()
  require("Comment").setup({
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
      local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if loaded and ts_comment then
        return ts_comment.create_pre_hook()(...)
      end
    end,
    post_hook = nil,
  })

  for k, v in pairs(keymaps_normal) do
    vim.api.nvim_set_keymap("n", k, v, { noremap = true, silent = true })
  end

  for k, v in pairs(keymaps_visual) do
    vim.api.nvim_set_keymap("v", k, v, { noremap = true, silent = true })
  end
end

return {
  "numToStr/Comment.nvim",
  config = function()
    setup()
  end,
  keys = { { "<C-a>", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
  event = "User FileOpened",
  enabled = true,
}
