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

  pcall(function()
    require("nlspsettings").setup()
  end)

  local lsp_options = require("plugins.lsp.options")

  require("null-ls").setup(lsp_options.default_opts)

  local language_servers = require("plugins.lsp.config").language_servers

  require("mason-lspconfig").setup({ ensure_installed = language_servers })

  local lspconfig = require("lspconfig")
  require("mason-lspconfig").setup_handlers {
    function(server_name)
      local opts = {}
      if server_name == "lua_ls" then
        opts = lsp_options.lua_ls_opts
      elseif server_name == "rust_analyzer" then
        opts = lsp_options.rust_analyzer_opts
      else
        opts = lsp_options.default_opts
      end
      lspconfig[server_name].setup(opts)
    end,
  }

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
  require("lspconfig.ui.windows").default_options.border = "single"
end

return {
  setup = setup
}
