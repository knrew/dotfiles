local setup = function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "comment",
      "markdown_inline",
      "regex",
      "rust",
      "cpp",
      "c",
      "cmake",
      "bash",
      "lua",
    },
    ignore_install = {
      "tex",
      "latex",
    },
    sync_install = false,
    auto_install = false,
    highlight = {
      enable = true,
      disable = function(lang, buf)
        if vim.tbl_contains({ "tex", "latex" }, lang) then
          return true
        end

        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = true, disable = { "yaml", "python" } },
  })

  require("ts_context_commentstring").setup({
    enable = true,
    enable_autocmd = false,
    config = {
      -- Languages that have a single comment style
      typescript = "// %s",
      css = "/* %s */",
      scss = "/* %s */",
      html = "<!-- %s -->",
      svelte = "<!-- %s -->",
      vue = "<!-- %s -->",
      json = "",
    }
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      setup()
    end,
    event = "User FileOpened",
    enabled = true,
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
}
