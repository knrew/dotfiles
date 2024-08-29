local format_filter = function(client)
  local filetype = vim.bo.filetype
  local n = require("null-ls")
  local s = require("null-ls.sources")
  local method = n.methods.FORMATTING
  local available_formatters = s.get_available(filetype, method)

  if #available_formatters > 0 then
    return client.name == "null-ls"
  elseif client.supports_method("textDocument/formatting") then
    return true
  else
    return false
  end
end

local format = function(opts)
  opts = opts or {}
  opts.filter = opts.filter or format_filter

  return vim.lsp.buf.format(opts)
end

return {
  format = format,
}
