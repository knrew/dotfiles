return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    dependencies = "mason.nvim",
  },
  {
    "tamago324/nlsp-settings.nvim",
    lazy = true,
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = true,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim",
    },
    lazy = true,
  },
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
