return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "mason-org/mason-lspconfig.nvim",
      "nvimtools/none-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
      "mason-org/mason.nvim",
    },
    config = function()
      require("plugins.lsp.setup").setup()
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
  },
  { "nvimtools/none-ls.nvim", lazy = true },
  { "jay-babu/mason-null-ls.nvim", lazy = true },
  {
    "mason-org/mason.nvim",
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    lazy = true,
  },
}
