local language_servers = {
  "rust_analyzer",
  "clangd",
  "cmake",
  "lua_ls",
  "vimls",
  "bashls",
  -- "pylsp",
  -- "ruff",
}

local keymaps_normal = {
  ["K"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Show hover" },
  ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
  ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
  ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
  ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
  ["gs"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "show signature help" },
  ["gl"] = {
    function()
      local float = vim.diagnostic.config().float

      if float then
        local config = type(float) == "table" and float or {}
        config.scope = "line"
        config.border = "single"

        vim.diagnostic.open_float(config)
      end
    end,
    "Show line diagnostics",
  },

  ["f"] = { ":lua require(\"plugins.lsp.utils\").format()<CR>:w<CR>", "Format" },
  ["lr"] = { ":lua vim.lsp.buf.rename()<CR>", "Rename" },
}

local options = {
  omnifunc = "v:lua.vim.lsp.omnifunc",
  formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
}

local setup = function()
  require("mason").setup({
    ui = {
      check_outdated_packages_on_open = true,
      border = "single",
      keymaps = {
        toggle_package_expand = "<CR>",
        install_package = "i",
        update_package = "u",
        check_package_version = "c",
        update_all_packages = "U",
        check_outdated_packages = "C",
        uninstall_package = "X",
        cancel_installation = "<C-c>",
        apply_language_filter = "<C-f>",
      },
    },
    pip = {
      upgrade_pip = false,
      install_args = {},
    },
    max_concurrent_installers = 4,
    registries = {
      "lua:mason-registry.index",
      "github:mason-org/mason-registry",
    },
    providers = {
      "mason.providers.registry-api",
      "mason.providers.client",
    },
    github = {
      download_url_template = "https://github.com/%s/releases/download/%s/%s",
    },
  })

  require("mason-lspconfig").setup {
    ensure_installed = language_servers
  }

  require("mason-lspconfig").setup_handlers {
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  }

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ctx)
      for key, remap in pairs(keymaps_normal) do
        local opts = { buffer = true, desc = remap[2], noremap = true, silent = true }
        vim.keymap.set("n", key, remap[1], opt)
      end
    end,
  })

  -- for k, v in pairs(options) do
  --   vim.api.nvim_set_option_value(k, v, {})
  -- end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
  require("lspconfig.ui.windows").default_options.border = "single"

  require("plugins.lsp.null-ls").setup()
end

return {
  {
    "neovim/nvim-lspconfig",
    -- lazy = true,
    -- dependencies = { "mason-lspconfig.nvim", "nlsp-settings.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    -- cmd = { "LspInstall", "LspUninstall" },
    -- config = function()
    --   require("mason-lspconfig").setup(lvim.lsp.installer.setup)

    --   -- automatic_installation is handled by lsp-manager
    --   local settings = require "mason-lspconfig.settings"
    --   settings.current.automatic_installation = false
    -- end,
    -- lazy = true,
    -- event = "User FileOpened",
    -- dependencies = "mason.nvim",
  },
  {
    "tamago324/nlsp-settings.nvim",
    -- cmd = "LspSettings",
    -- lazy = true
  },
  { "nvimtools/none-ls.nvim",
    -- lazy = true
  },
  {
    "williamboman/mason.nvim",
    config = function()
      setup()
    end,
    -- cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    build = function()
      pcall(function()
        require("mason-registry").refresh()
      end)
    end,
    -- event = "User FileOpened",
    -- lazy = true,
  },
}
