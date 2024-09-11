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
      "cmp-calc",
      -- "cmp-copilot",
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
  -- {
  --   "hrsh7th/cmp-copilot",
  --   lazy = true,
  -- },
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
  {
    "github/copilot.vim",
    lazy = true,
    cmd = { "Copilot" },
  },
  {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function()
      local status_ok, copilot = pcall(require, "copilot")
      if status_ok then
        copilot.setup()
        require("copilot_cmp").setup()

        -- vim.defer_fn(function()
        --   copilot.setup()
        --   require("copilot_cmp").setup()
        -- end, 100)
      end
    end,
    dependencies = { "zbirenbaum/copilot.lua" },
  },
}
