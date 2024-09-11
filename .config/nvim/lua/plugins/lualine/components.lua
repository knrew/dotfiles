local icons = require("utils.icons")

local lsp_format = function()
  local buf_clients = vim.lsp.get_clients { bufnr = 0 }
  if #buf_clients == 0 then
    return "[lsp inactive]"
  end

  local buf_client_names = {}

  for _, client in pairs(buf_clients) do
    if client.name == "GitHub Copilot" then
      table.insert(buf_client_names, "copilot")
    else
      table.insert(buf_client_names, client.name)
    end
  end

  if #buf_client_names == 0 then
    table.insert(buf_client_names, "lsp inactive")
  end

  local unique_client_names = table.concat(buf_client_names, ", ")
  local language_servers = string.format("[%s]", unique_client_names)

  return language_servers
end

return {
  mode = {
    function()
      return string.upper(vim.api.nvim_get_mode().mode)
    end
  },
  branch = { "branch", icon = icons.git.branch },
  filename_full = {
    "filename",
    file_status = true,
    new_file_status = false,
    path = 3,
    shorting_target = 40,
    symbols = {
      modified = "[+]",
      readonly = "[-]",
      unnamed = "[No Name]",
      newfile = "[New]",
    }
  },
  filename_simple = {
    "filename",
    file_status = false,
    new_file_status = false,
    path = 0,
    shorting_target = 40,
  },
  location = { "location" },
  progress = {
    "progress",
    fmt = function()
      return "%P/%L"
    end,
  },
  diagnostics = { "diagnostics" },
  filetype = { "filetype", padding = { left = 1, right = 1 } },
  diff = {
    "diff",
    -- source = diff_source,
    symbols = {
      added = icons.git.LineAdded .. " ",
      modified = icons.git.LineModified .. " ",
      removed = icons.git.LineRemoved .. " ",
    },
    -- padding = { left = 2, right = 1 },
    -- diff_color = {
    -- added = { fg = "green" },
    -- modified = { fg = "yellow" },
    -- removed = { fg = "red" },
    -- },
  },
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  lsp = { lsp_format },
  datetime = {
    "datetime",
    style = "%H:%M:%S",
  },
  windows = { "windows" },
  navic = { "navic" },
}
