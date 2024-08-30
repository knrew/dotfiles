local setup = function()
  local treesitter_configs = require("nvim-treesitter.configs")

  require("ts_context_commentstring").setup({
    enable = true,
    enable_autocmd = false,
    config = {
      typescript = "// %s",
      css = "/* %s */",
      scss = "/* %s */",
      html = "<!-- %s -->",
      svelte = "<!-- %s -->",
      vue = "<!-- %s -->",
      json = "",
    },
  })

  treesitter_configs.setup({
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
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    matchup = {
      enable = false,
      disable = {},
    },
    highlight = {
      enable = true,
      disable = {},
      additional_vim_regex_highlighting = false,
    },
    indent = { enable = false, disable = { "yaml", "python" } },
    autotag = { enable = false },
    textobjects = {
      swap = { enable = false, },
      select = { enable = false, },
    },
    textsubjects = {
      enable = false,
      keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
    },
    playground = {
      enable = false,
      disable = {},
      updatetime = 25,
      persist_queries = false,
      keybindings = {
        toggle_query_editor = "o",
        toggle_hl_groups = "i",
        toggle_injected_languages = "t",
        toggle_anonymous_nodes = "a",
        toggle_language_display = "I",
        focus_language = "f",
        unfocus_language = "F",
        update = "R",
        goto_node = "<cr>",
        show_help = "?",
      },
    },
    rainbow = {
      enable = true,
      extended_mode = true,
      max_file_lines = 1000,
    },
  })

  local ts_utils = require("nvim-treesitter.ts_utils")
  ts_utils.is_in_node_range = vim.treesitter.is_in_node_range
  ts_utils.get_node_range = vim.treesitter.get_node_range
end

return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    lazy = true,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      setup()
    end,
    dependencies = {
      { "hiphish/rainbow-delimiters.nvim" }
    },
    build = function()
      require("nvim-treesitter.install").update({ with_sync = true })()
    end,
    event = { "User FileOpened", "BufReadPost", }
  },
}
