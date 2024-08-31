local setup = function()
  require("catppuccin").setup({
    flavour = "latte", -- latte, frappe, macchiato, mocha
    background = {     -- :h background
      light = "latte",
      dark = "mocha",
    },
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false,    -- shows the '~' characters after the end of buffers
    term_colors = true,            -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = true,              -- dims the background color of inactive window
      shade = "dark",
      percentage = 0.15,           -- percentage of the shade to apply to the inactive window
    },
    no_italic = true,              -- Force no italic
    no_bold = false,               -- Force no bold
    no_underline = false,          -- Force no underline
    styles = {                     -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = {},               -- Change the style of comments
      conditionals = {},
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
    },
    color_overrides = {},
    custom_highlights = {},
    integrations = {
      cmp = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
          ok = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
          ok = { "underline" },
        },
        inlay_hints = {
          background = true,
        },
      },
      dap = true,
      gitsigns = true,
      nvimtree = true,
      neotree = true,
      treesitter = true,
      treesitter_context = true,
      notify = true,
      mini = {
        enabled = true,
        indentscope_color = "",
      },
      rainbow_delimiters = true,
      -- ts_rainbow = true,
      mason = true,
      navic = {
        enabled = false,
        custom_bg = "NONE", -- "lualine" will set background to mantle
      },
      illuminate = {
        enabled = true,
        lsp = true,
      },
      indent_blankline = {
        enabled = true,
        scope_color = "sapphire",
        colored_indent_levels = true,
      },
    },
  })

  vim.cmd.colorscheme("catppuccin")
end

return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    setup()
  end,
  enabled = true,
}
