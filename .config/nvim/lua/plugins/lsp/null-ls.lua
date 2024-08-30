local clear_augroup = function(name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds { group = name }
    end)
  end)
end

local setup_codelens_refresh = function(client, bufnr)
  local status_ok, codelens_supported = pcall(function()
    return client.supports_method "textDocument/codeLens"
  end)
  if not status_ok or not codelens_supported then
    return
  end
  local group = "lsp_code_lens_refresh"
  local cl_events = { "BufEnter", "InsertLeave" }
  local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = cl_events,
  })

  if ok and #cl_autocmds > 0 then
    return
  end
  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(cl_events, {
    group = group,
    buffer = bufnr,
    callback = function()
      vim.lsp.codelens.refresh { bufnr = bufnr }
    end,
  })
end

local setup_document_symbols = function(client, bufnr)
  vim.g.navic_silence = false -- can be set to true to suppress error
  local symbols_supported = client.supports_method "textDocument/documentSymbol"
  if not symbols_supported then
    Log:debug("skipping setup for document_symbols, method not supported by " .. client.name)
    return
  end
  local status_ok, navic = pcall(require, "nvim-navic")
  if status_ok then
    navic.attach(client, bufnr)
  end
end

local common_capabilities = function()
  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    return cmp_nvim_lsp.default_capabilities()
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  return capabilities
end

local common_on_attach = function(client, bufnr)
  setup_codelens_refresh(client, bufnr)
  add_lsp_buffer_keybindings(bufnr)
  add_lsp_buffer_options(bufnr)
  setup_document_symbols(client, bufnr)
end


local common_on_init = function(client, bufnr)
end


local common_on_exit = function(_, _)
  autocmds.clear_augroup("lsp_code_lens_refresh")
end

local setup = function()
  require("null-ls").setup({
    on_attach = common_on_attach,
    on_init = common_on_init,
    on_exit = common_on_exit,
    capabilities = common_capabilities(),
  })
end

return {
  setup = setup
}
