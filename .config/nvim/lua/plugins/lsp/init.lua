return {
  {
    "neovim/nvim-lspconfig",
    lazy = true,
    dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- cmd = { "LspInstall", "LspUninstall" },
    lazy = true,
    -- event = "User FileOpnned",
    dependencies = "mason.nvim",
  },
  {
    "tamago324/nlsp-settings.nvim",
    -- cmd = "LspSettings",
    lazy = true
  },
  {
    "nvimtools/none-ls.nvim",
    lazy = true
  },
  {
    "williamboman/mason.nvim",
    -- cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    -- event = "User FileOpened",
    lazy = false,
  },
}
