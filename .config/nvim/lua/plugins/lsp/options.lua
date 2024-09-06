local setup_document_highlight = function(client, bufnr)
  local status_ok, highlight_supported = pcall(function()
    return client.supports_method "textDocument/documentHighlight"
  end)
  if not status_ok or not highlight_supported then
    return
  end
  local group = "lsp_document_highlight"
  local hl_events = { "CursorHold", "CursorHoldI" }

  local ok, hl_autocmds = pcall(vim.api.nvim_get_autocmds, {
    group = group,
    buffer = bufnr,
    event = hl_events,
  })

  if ok and #hl_autocmds > 0 then
    return
  end

  vim.api.nvim_create_augroup(group, { clear = false })
  vim.api.nvim_create_autocmd(hl_events, {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.document_highlight,
  })
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = bufnr,
    callback = vim.lsp.buf.clear_references,
  })
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

local add_lsp_buffer_keybindings = function(bufnr)
  local keymaps_normal = require("plugins.lsp.config").keymaps_normal
  for key, remap in pairs(keymaps_normal) do
    local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
    vim.keymap.set("n", key, remap[1], opts)
  end
end

local setup_document_symbols = function(client, bufnr)
  vim.g.navic_silence = false
  local symbols_supported = client.supports_method "textDocument/documentSymbol"
  if not symbols_supported then
    return
  end
  local status_ok, navic = pcall(require, "nvim-navic")
  if status_ok then
    navic.attach(client, bufnr)
  end
end

local add_lsp_buffer_options = function(bufnr)
  local options = require("plugins.lsp.config").buffer_options
  for k, v in pairs(options) do
    vim.api.nvim_set_option_value(k, v, { buf = bufnr })
  end
end

local common_on_attach = function(client, bufnr)
  setup_document_highlight(client, bufnr)
  setup_codelens_refresh(client, bufnr)
  add_lsp_buffer_keybindings(bufnr)
  add_lsp_buffer_options(bufnr)
  setup_document_symbols(client, bufnr)
end

local common_on_init = function(_, _)
end

local clear_augroup = function(name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds { group = name }
    end)
  end)
end

local common_on_exit = function(_, _)
  clear_augroup("lsp_document_highlight")
  clear_augroup("lsp_code_lens_refresh")
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

local default_opts = function()
  return {
    on_attach = common_on_attach,
    on_init = common_on_init,
    on_exit = common_on_exit,
    capabilities = common_capabilities(),
  }
end

local lua_ls_opts = function()
  local opts = default_opts();

  opts.settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        pathStrict = true,
        path = { "?.lua", "?/init.lua" },
      },
      workspace = {
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
          "${3rd}/busted/library",
          "${3rd}/luassert/library",
        }),
        checkThirdParty = "Disable",
      },
    },
  }

  return opts
end

local rust_analyzer_opts = function()
  local opts = default_opts();

  opts.settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        enable = true,
      },
    }
  }

  return opts
end

return {
  default_opts = default_opts(),
  lua_ls_opts = lua_ls_opts(),
  rust_analyzer_opts = rust_analyzer_opts(),
}
