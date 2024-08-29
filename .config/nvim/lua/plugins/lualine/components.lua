local icons = require("utils.icons")

local window_width_limit = 100

local conditions = {
  buffer_not_empty = function()
    return vim.fn.empty(vim.fn.expand "%:t") ~= 1
  end,
  hide_in_width = function()
    return vim.o.columns > window_width_limit
  end,
}

return {
  mode = { "mode" },
  branch = {
    "branch",
    icon = icons.git.branch,
    color = { gui = "bold" },
  },
  filename = { "filename", path = 2, },
  location = { "location" },
  progress = {
    "progress",
    fmt = function()
      return "%P/%L"
    end,
    color = {},
  },
  diagnostics = {
    "diagnostics",
    -- sources = { "nvim_diagnostic" },
    -- symbols = {
    --   error = icons.diagnostics.BoldError .. " ",
    --   warn = icons.diagnostics.BoldWarning .. " ",
    --   info = icons.diagnostics.BoldInformation .. " ",
    --   hint = icons.diagnostics.BoldHint .. " ",
    -- },
  },
  filetype = {
    "filetype",
    cond = nil,
    padding = { left = 1, right = 1 }
  },

  diff = {
    "diff",
    -- source = diff_source,
    -- symbols = {
    --   added = icons.git.LineAdded .. " ",
    --   modified = icons.git.LineModified .. " ",
    --   removed = icons.git.LineRemoved .. " ",
    -- },
    -- padding = { left = 2, right = 1 },
    -- diff_color = {
    -- added = { fg = colors.green },
    -- modified = { fg = colors.yellow },
    -- removed = { fg = colors.red },
    -- },
    -- cond = nil,
  },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  lsp = {
    function()
      local buf_clients = vim.lsp.get_clients { bufnr = 0 }
      if #buf_clients == 0 then
        return "LSP Inactive"
      end

      local buf_ft = vim.bo.filetype
      local buf_client_names = {}
      local copilot_active = false

      -- add client
      for _, client in pairs(buf_clients) do
        if client.name ~= "null-ls" and client.name ~= "copilot" then
          table.insert(buf_client_names, client.name)
        end

        if client.name == "copilot" then
          copilot_active = true
        end
      end

      -- TODO:
      -- add formatter
      -- local formatters = require "lvim.lsp.null-ls.formatters"
      -- local supported_formatters = formatters.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_formatters)

      -- add linter
      -- local linters = require "lvim.lsp.null-ls.linters"
      -- local supported_linters = linters.list_registered(buf_ft)
      -- vim.list_extend(buf_client_names, supported_linters)

      local unique_client_names = table.concat(buf_client_names, ", ")
      local language_servers = string.format("[%s]", unique_client_names)

      if copilot_active then
        language_servers = language_servers .. "%#SLCopilot#" .. " " .. lvim.icons.git.Octoface .. "%*"
      end

      return language_servers
    end,
    color = { gui = "bold" },
    cond = conditions.hide_in_width,
  },
}
