local M = {}

function M.setup()
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

  local common = require("plugins.lsp.common")
  local servers = require("plugins.lsp.servers")

  require("mason-lspconfig").setup({ ensure_installed = servers.language_servers })
  require("null-ls").setup(common.default_options())
  require("mason-null-ls").setup({ ensure_installed = require("plugins.lsp.tools") })

  for _, server_name in ipairs(servers.language_servers) do
    vim.lsp.config(server_name, servers.get(server_name))
  end

  vim.lsp.enable(servers.language_servers)

  require("lspconfig.ui.windows").default_options.border = "single"

  if vim.lsp.inlay_hint then
    vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
  end
end

return M
