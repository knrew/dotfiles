return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  config = function()
    vim.g.mkdp_auto_start = 1
  end,
  build = function()
    vim.fn["mkdp#util#install"]()
  end,
  lazy = true,
}
