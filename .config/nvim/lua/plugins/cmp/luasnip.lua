local mysnippets_dir = (function()
  local config_dir = vim.call("stdpath", "config")
  return config_dir .. "/lua/snippets/"
end)()

local setup = function()
  local snippets_dirs = {
    mysnippets_dir,
  }

  local paths = {}
  for _, dir in pairs(snippets_dirs) do
    paths[#paths + 1] = dir
  end

  require("luasnip.loaders.from_lua").lazy_load({ paths = paths })
  require("luasnip.loaders.from_vscode").lazy_load()
end

return {
  setup = setup
}
