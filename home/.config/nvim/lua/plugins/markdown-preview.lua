return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  keys = {
    {
      "md",
      "<cmd>MarkdownPreview<cr>",
      mode = "n",
      desc = "Markdown preview",
    },
  },
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  build = "cd app && npm install",
  lazy = true,
}
