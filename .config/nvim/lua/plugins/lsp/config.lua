local language_servers = {
  "rust_analyzer",
  "clangd",
  "cmake",
  "lua_ls",
  -- "stylua",
  "vimls",
  "bashls",
  -- "pylsp",
  -- "ruff",
  "texlab"
}

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

local buffer_options = {
  omnifunc = "v:lua.vim.lsp.omnifunc",
  formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
}

return {
  language_servers = language_servers,
  keymaps_normal = keymaps_normal,
  buffer_options = buffer_options,
}
