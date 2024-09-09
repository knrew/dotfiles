return {
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    lazy = true,
    dependencies = {
      "cmp-nvim-lsp",
      "cmp_luasnip",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
      "cmp-calc"
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true
  },
  {
    "saadparwaiz1/cmp_luasnip",
    lazy = true
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true
  },
  {
    "hrsh7th/cmp-path",
    lazy = true
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
  {
    "hrsh7th/cmp-calc",
    lazy = true,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    lazy = true,
    config = function()
      require("plugins.cmp.luasnip").setup()
    end,
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },
  {
    "folke/neodev.nvim",
    lazy = true,
  },
  {
    "windwp/nvim-autopairs",
    lazy = true,
    event = "InsertEnter",
  },
}
