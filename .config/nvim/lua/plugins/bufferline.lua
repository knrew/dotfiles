local function diagnostics_indicator(_, _, diagnostics, _)
  local icons = require("utils.icons")
  local result = {}
  local symbols = {
    error = icons.diagnostics.Error,
    warning = icons.diagnostics.Warning,
    info = icons.diagnostics.Information,
  }
  for name, count in pairs(diagnostics) do
    if symbols[name] and count > 0 then
      table.insert(result, symbols[name] .. " " .. count)
    end
  end
  result = table.concat(result, " ")
  return #result > 0 and result or ""
end

local setup = function()
  local options = {
    options = {
      numbers = "none",
      show_buffer_icons = true,
      diagnostics = "nvim_lsp",
      diagnostics_update_in_insert = false,
      diagnostics_indicator = diagnostics_indicator,
      -- groups = {
      --   items = {
      --     require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " })
      --   }
      -- }
    }
  }

  local status_ok, catppuccin = pcall(require, "catppuccin.groups.integrations.bufferline")
  if status_ok then
    options.highlights = catppuccin.get()
  end

  require("bufferline").setup(options)
end

return {
  "akinsho/bufferline.nvim",
  after = "catppuccin",
  config = function()
    setup()
  end
}
