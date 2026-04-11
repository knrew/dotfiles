return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "tamago324/nlsp-settings.nvim",
      "nvimtools/none-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
      "williamboman/mason.nvim",
    },
    config = function()
      require("plugins.lsp.setup").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
  },
  { "tamago324/nlsp-settings.nvim", lazy = true },
  { "nvimtools/none-ls.nvim", lazy = true },
  { "jay-babu/mason-null-ls.nvim", lazy = true },
  {
    "williamboman/mason.nvim",
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    lazy = true,
  },
}
