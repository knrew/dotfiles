local common = require("plugins.lsp.common")

local M = {
  language_servers = {
    "rust_analyzer",
    "clangd",
    "cmake",
    "lua_ls",
    "vimls",
    "bashls",
    "pylsp",
    "ruff",
    "texlab",
    "marksman",
    "taplo",
  },
}

local function lua_ls_options()
  local opts = common.default_options()

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

local function rust_analyzer_options()
  local opts = common.default_options()

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

local function clangd_options()
  return common.default_options()
end

local server_options = {
  lua_ls = lua_ls_options,
  rust_analyzer = rust_analyzer_options,
  clangd = clangd_options,
}

function M.get(server_name)
  local builder = server_options[server_name]
  if builder then
    return builder()
  end

  return common.default_options()
end

return M
