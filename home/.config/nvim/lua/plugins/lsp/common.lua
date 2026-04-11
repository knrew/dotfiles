local M = {}

local function lsp_float_opts()
  return { border = "single" }
end

local function show_hover()
  vim.lsp.buf.hover(lsp_float_opts())
end

local function show_signature_help()
  vim.lsp.buf.signature_help(lsp_float_opts())
end

local keymaps_normal = {
  ["K"] = { show_hover, "Show hover" },
  ["gd"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Goto definition" },
  ["gD"] = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "Goto Declaration" },
  ["gr"] = { "<cmd>lua vim.lsp.buf.references()<cr>", "Goto references" },
  ["gI"] = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "Goto Implementation" },
  ["gs"] = { show_signature_help, "show signature help" },
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

local keymaps_insert_select = {
  ["<C-S>"] = { show_signature_help, "show signature help" },
}

local function setup_document_highlight(client, bufnr)
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

local function add_lsp_buffer_keybindings(bufnr)
  for key, remap in pairs(keymaps_normal) do
    local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
    vim.keymap.set("n", key, remap[1], opts)
  end

  for key, remap in pairs(keymaps_insert_select) do
    local opts = { buffer = bufnr, desc = remap[2], noremap = true, silent = true }
    vim.keymap.set({ "i", "s" }, key, remap[1], opts)
  end
end

local function clear_augroup(name)
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds({ group = name })
    end)
  end)
end

function M.on_attach(client, bufnr)
  setup_document_highlight(client, bufnr)
  add_lsp_buffer_keybindings(bufnr)
end

function M.on_init(_, _) end

function M.on_exit(_, _)
  clear_augroup("lsp_document_highlight")
  clear_augroup("lsp_code_lens_refresh")
end

function M.capabilities()
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

function M.default_options()
  return {
    on_attach = M.on_attach,
    on_init = M.on_init,
    on_exit = M.on_exit,
    capabilities = M.capabilities(),
  }
end

return M
