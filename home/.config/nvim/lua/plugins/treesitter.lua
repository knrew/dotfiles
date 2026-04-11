local managed_parsers = {
  "comment",
  "markdown",
  "markdown_inline",
  "regex",
  "rust",
  "cpp",
  "c",
  "cmake",
  "bash",
  "lua",
}

local highlight_disabled_filetypes = {
  tex = true,
  latex = true,
}

local indent_disabled_filetypes = {
  yaml = true,
  python = true,
}

local max_filesize = 100 * 1024

local function has_tree_sitter_cli()
  return vim.fn.executable("tree-sitter") == 1
end

local function warn_missing_tree_sitter_cli()
  if vim.g.nvim_treesitter_cli_warned then
    return
  end

  vim.g.nvim_treesitter_cli_warned = true
  vim.schedule(function()
    vim.notify(
      "nvim-treesitter: `tree-sitter` CLI was not found, so parser install/update was skipped",
      vim.log.levels.WARN
    )
  end)
end

local function is_large_file(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == "" then
    return false
  end

  local ok, stats = pcall(vim.uv.fs_stat, path)
  return ok and stats and stats.size > max_filesize
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = function()
      if not has_tree_sitter_cli() then
        warn_missing_tree_sitter_cli()
        return
      end

      vim.cmd("TSUpdate")
    end,
    config = function()
      local treesitter = require("nvim-treesitter")
      treesitter.setup({})

      local installed = treesitter.get_installed("parsers") or {}
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, managed_parsers)

      if #missing > 0 and has_tree_sitter_cli() then
        treesitter.install(missing)
      elseif #missing > 0 then
        warn_missing_tree_sitter_cli()
      end

      local group = vim.api.nvim_create_augroup("nvim_treesitter_filetypes", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "*",
        callback = function(event)
          local bufnr = event.buf
          local filetype = vim.bo[bufnr].filetype
          local has_parser = pcall(vim.treesitter.get_parser, bufnr)

          if
            has_parser
            and not highlight_disabled_filetypes[filetype]
            and not is_large_file(bufnr)
          then
            pcall(vim.treesitter.start, bufnr)
          end

          if has_parser and not indent_disabled_filetypes[filetype] then
            vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
