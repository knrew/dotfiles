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
}

-- local buffer_options = {
--   omnifunc = "v:lua.vim.lsp.omnifunc",
--   formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
-- }

local setup_document_highlight = function(client, bufnr)
  local status_ok, highlight_supported = pcall(function()
    return client.supports_method("textDocument/documentHighlight")
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

-- local setup_codelens_refresh = function(client, bufnr)
--   local status_ok, codelens_supported = pcall(function()
--     return client.supports_method("textDocument/codeLens")
--   end)
--   if not status_ok or not codelens_supported then
--     return
--   end
--   local group = "lsp_code_lens_refresh"
--   local cl_events = { "BufEnter", "InsertLeave" }
--   local ok, cl_autocmds = pcall(vim.api.nvim_get_autocmds, {
--     group = group,
--     buffer = bufnr,
--     event = cl_events,
--   })

--   if ok and #cl_autocmds > 0 then
--     return
--   end
--   vim.api.nvim_create_augroup(group, { clear = false })
--   vim.api.nvim_create_autocmd(cl_events, {
--     group = group,
--     buffer = bufnr,
--     callback = function()
--       vim.lsp.codelens.refresh({ bufnr = bufnr })
--     end,
--   })
-- end

local add_lsp_buffer_keybindings = function(bufnr)
  for key, remap in pairs(keymaps_normal) do
    local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
    vim.keymap.set("n", key, remap[1], opts)
  end
end

-- local setup_document_symbols = function(client, bufnr)
--   vim.g.navic_silence = false
--   local symbols_supported = client.supports_method("textDocument/documentSymbol")
--   if not symbols_supported then
--     return
--   end
--   local status_ok, navic = pcall(require, "nvim-navic")
--   if status_ok then
--     navic.attach(client, bufnr)
--   end
-- end

-- local add_lsp_buffer_options = function(bufnr)
--   for k, v in pairs(buffer_options) do
--     vim.api.nvim_set_option_value(k, v, { buf = bufnr })
--   end
-- end

-- for on_exit
local clear_augroup = function(name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds({ group = name })
    end)
  end)
end

local on_attach = function(client, bufnr)
  setup_document_highlight(client, bufnr)
  -- setup_codelens_refresh(client, bufnr)
  add_lsp_buffer_keybindings(bufnr)
  -- add_lsp_buffer_options(bufnr)
  -- setup_document_symbols(client, bufnr)
end

local on_init = function(_, _) end

local on_exit = function(_, _)
  clear_augroup("lsp_document_highlight")
  clear_augroup("lsp_code_lens_refresh")
end

local capabilities = function()
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

local default_options = function()
  return {
    on_attach = on_attach,
    on_init = on_init,
    on_exit = on_exit,
    capabilities = capabilities(),
  }
end

local lua_ls_options = function()
  local opts = default_options()

  opts.settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
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

local rust_analyzer_options = function()
  local opts = default_options()

  opts.settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        enable = true,
      },
      cargo = {
        features = "all",
        buildScripts = {
          overrideCommand = {
            "cargo",
            "check",
            "--quiet",
            "--workspace",
            "--message-format=json",
            "--all-targets",
          },
        },
      },
      check = {
        overrideCommand = {
          "cargo",
          "check",
          "--quiet",
          "--workspace",
          "--message-format=json",
          "--all-targets",
        },
      },
      procMacro = {
        attributes = {
          enable = true,
        },
      },
    },
  }

  return opts
end

local clangd_options = function()
  local opts = default_options()

  return opts
end

return {
  default_options = default_options(),
  lua_ls_options = lua_ls_options(),
  rust_analyzer_options = rust_analyzer_options(),
  clangd_options = clangd_options(),
}
