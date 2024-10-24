return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  config = function()
    vim.g.mkdp_auto_start = 1
  end,
  build =
  -- "cd app && yarn install"
      function()
        vim.cmd [[Lazy load markdown-preview.nvim]]
        vim.fn["mkdp#util#install"]()
      end
  ,
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  lazy = true,
}
