local formatting = function()
  local icons = require("utils.icons")

  local fields = { "abbr", "kind", "menu" }
  local max_width = 50
  local min_width = 20
  local source_names = {
    nvim_lsp = "[LSP]",
    emoji = "[Emoji]",
    path = "[Path]",
    calc = "[Calc]",
    cmp_tabnine = "[Tabnine]",
    vsnip = "[Snippet]",
    luasnip = "[Snippet]",
    buffer = "[Buffer]",
    tmux = "[TMUX]",
    copilot = "[Copilot]",
    treesitter = "[TreeSitter]",
  }
  local duplicates = {
    buffer = 1,
    path = 1,
    nvim_lsp = 0,
    luasnip = 1,
  }
  local duplicates_default = 0
  local format = function(entry, vim_item)
    -- vim_item.kind = icons[vim_item.kind]

    -- if entry.source.name == "copilot" then
    --   vim_item.kind = icons.git.Octoface
    --   vim_item.kind_hl_group = "CmpItemKindCopilot"
    -- end

    -- if entry.source.name == "cmp_tabnine" then
    --   vim_item.kind = icons.misc.Robot
    --   vim_item.kind_hl_group = "CmpItemKindTabnine"
    -- end

    -- if entry.source.name == "crates" then
    --   vim_item.kind = icons.misc.Package
    --   vim_item.kind_hl_group = "CmpItemKindCrate"
    -- end

    -- if entry.source.name == "lab.quick_data" then
    --   vim_item.kind = icons.misc.CircuitBoard
    --   vim_item.kind_hl_group = "CmpItemKindConstant"
    -- end

    -- if entry.source.name == "emoji" then
    --   vim_item.kind = icons.misc.Smiley
    --   vim_item.kind_hl_group = "CmpItemKindEmoji"
    -- end

    vim_item.menu = source_names[entry.source.name]
    vim_item.dup = duplicates[entry.source.name] or duplicates_default

    local label = vim_item.abbr
    local truncated_label = vim.fn.strcharpart(label, 0, max_width)
    if truncated_label ~= label then
      vim_item.abbr = truncated_label .. icons.ui.Ellipsis
    elseif string.len(label) < min_width then
      local padding = string.rep(' ', min_width - string.len(label))
      vim_item.abbr = label .. padding
    end

    return vim_item
  end

  return {
    fields = fields,
    source_names = source_names,
    format = format,
  }
end

local setup = function()
  local confirm_behavior = require("cmp.types.cmp").ConfirmBehavior
  local select_behavior = require("cmp.types.cmp").SelectBehavior
  local cmp = require("cmp")

  cmp.setup({
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },
    experimental = {
      ghost_text = true,
      native_menu = false,
    },
    window = {
      completion = cmp.config.window.bordered({ border = "single" }),
      documentation = cmp.config.window.bordered({ border = "single" }),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-k>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
      ["<C-j>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item { behavior = select_behavior.Select }, { "i" }),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item { behavior = select_behavior.Select }, { "i" }),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-y>"] = cmp.mapping {
        i = cmp.mapping.confirm { behavior = confirm_behavior.Replace, select = false },
        c = function(fallback)
          if cmp.visible() then
            cmp.confirm { behavior = confirm_behavior.Replace, select = false }
          else
            fallback()
          end
        end,
      },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
          -- elseif luasnip.expand_or_locally_jumpable() then
          --   luasnip.expand_or_jump()
          -- elseif jumpable(1) then
          --   luasnip.jump(1)
          -- elseif has_wordl_before() then
          --   fallback()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
          -- elseif luasnip.jumpable(-1) then
          --   luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local confirm_opts = {
            behavior = confirm_behavior.Replace,
            select = false,
          }
          local is_insert_mode = function()
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end
          if is_insert_mode() then
            confirm_opts.behavior = confirm_behavior.Insert
          end
          local entry = cmp.get_selected_entry()
          local is_copilot = entry and entry.source.name == "copilot"
          if is_copilot then
            confirm_opts.behavior = confirm_behavior.Replace
            confirm_opts.select = true
          end
          if cmp.confirm(confirm_opts) then
            return
          end
        end
        fallback()
      end),
    }),
    completion = {
      keyword_length = 1,
    },
    sources = cmp.config.sources({
      {
        name = "copilot",
        -- keyword_length = 0,
        max_item_count = 3,
        trigger_characters = {
          {
            ".",
            ":",
            "(",
            "'",
            '"',
            "[",
            ",",
            "#",
            "*",
            "@",
            "|",
            "=",
            "-",
            "{",
            "/",
            "\\",
            "+",
            "?",
            " ",
            -- "\t",
            -- "\n",
          },
        },
      },
      {
        name = "nvim_lsp",
        entry_filter = function(entry, ctx)
          local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
          if kind == "Snippet" and ctx.prev_context.filetype == "java" then
            return false
          end
          return true
        end,
      },
      { name = "path" },
      { name = "luasnip" },
      { name = "cmp_tabnine" },
      { name = "nvim_lua" },
      { name = "buffer" },
      { name = "calc" },
      { name = "emoji" },
      { name = "treesitter" },
      { name = "crates" },
      { name = "tmux" },

    }, {
      { name = "buffer" },
    }),
    formatting = formatting(),
  })

  cmp.setup.cmdline({ ":" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "path" },
      { name = "cmdline" },
    }
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "buffer" }
    }
  })

  require("nvim-autopairs").setup({
    check_ts = true,
    enable_check_bracket_line = false,
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    disable_in_macro = false,
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
    enable_moveright = true,
    enable_afterquote = true,
    map_cr = true,
    map_bs = true,
    map_c_w = false,
    map_c_h = false,
    disable_in_visualblock = false,
    fast_wrap = {
      map = "<M-e>",
      chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      offset = 0,
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    }
  })

  pcall(function()
    local function on_confirm_done(...)
      require("nvim-autopairs.completion.cmp").on_confirm_done()(...)
    end
    cmp.event:off("confirm_done", on_confirm_done)
    cmp.event:on("confirm_done", on_confirm_done)
  end)
end

return {
  {
    "hrsh7th/nvim-cmp",
    config = function()
      setup()
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "cmp-nvim-lsp",
      "cmp_luasnip",
      "cmp-buffer",
      "cmp-path",
      "cmp-cmdline",
    },
  },
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = true
  },
  {
    "saadparwaiz1/cmp_luasnip",
    lazy = true
  },
  {
    "hrsh7th/cmp-buffer",
    lazy = true
  },
  {
    "hrsh7th/cmp-path",
    lazy = true
  },
  {
    "hrsh7th/cmp-cmdline",
    lazy = true,
  },
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
  },
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
    cond = true,
  },
  {
    "folke/neodev.nvim",
    lazy = true,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },

}
