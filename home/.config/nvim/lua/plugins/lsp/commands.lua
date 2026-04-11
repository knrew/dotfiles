local M = {}

local function normalize_format_opts(opts)
  if type(opts) ~= "table" then
    return {}
  end

  local normalized = vim.deepcopy(opts)

  if type(normalized.range) == "number" then
    normalized.range = nil
  end

  normalized.args = nil
  normalized.fargs = nil
  normalized.name = nil
  normalized.line1 = nil
  normalized.line2 = nil
  normalized.mods = nil
  normalized.smods = nil
  normalized.count = nil
  normalized.bang = nil
  normalized.reg = nil

  return normalized
end

local function format_filter(client)
  local filetype = vim.bo.filetype
  local null_ls = require("null-ls")
  local sources = require("null-ls.sources")
  local method = null_ls.methods.FORMATTING
  local available_formatters = sources.get_available(filetype, method)

  if #available_formatters > 0 then
    return client.name == "null-ls"
  end

  return client.supports_method("textDocument/formatting")
end

function M.format(opts)
  opts = normalize_format_opts(opts)
  opts.filter = opts.filter or format_filter
  return vim.lsp.buf.format(opts)
end

function M.rename()
  vim.lsp.buf.rename()
end

function M.toggle_inlay_hint()
  if vim.lsp.inlay_hint then
    local bufnr = vim.api.nvim_get_current_buf()
    if vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
      print("Inlay Hint disabled.")
    else
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      print("Inlay Hint enabled.")
    end
  end
end

return M
