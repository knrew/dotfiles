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

  local lsp_options = require("config.lsp.options")

  local language_servers = require("config.lsp.language_servers")
  require("mason-lspconfig").setup({ ensure_installed = language_servers })


  require("null-ls").setup(lsp_options.default_options)

  require("mason-null-ls").setup({ ensure_installed = require("config.lsp.linter_tools") })

  for _, server_name in ipairs(language_servers) do
    local opts = {}
    if server_name == "lua_ls" then
      opts = lsp_options.lua_ls_options
    elseif server_name == "rust_analyzer" then
      opts = lsp_options.rust_analyzer_options
    elseif server_name == "clangd" then
      opts = lsp_options.clangd_options
    else
      opts = lsp_options.default_options
    end
    vim.lsp.config(server_name, opts)
  end

  vim.lsp.enable(language_servers)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "single" })
  require("lspconfig.ui.windows").default_options.border = "single"
end

setup()
