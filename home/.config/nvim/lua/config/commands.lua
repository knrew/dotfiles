local commands = {
  {
    name = "Format",
    fn = function()
      require("config.lsp.commands").format()
    end,
  },
  {
    name = "Rename",
    fn = function()
      vim.lsp.buf.rename()
    end,
  },
  {
    name = "ToggleCommentNormal",
    fn = function()
      require("Comment.api").toggle.linewise.current()
    end,
  },
  {
    name = "ToggleCommentSelect",
    fn = function()
      local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
      vim.api.nvim_feedkeys(esc, "nx", false)
      require("Comment.api").toggle.linewise(vim.fn.visualmode())
    end,
  },
  {
    name = "ToggleInlayHint",
    fn = function()
      if vim.lsp.inlay_hint then
        if vim.lsp.inlay_hint.is_enabled() then
          vim.lsp.inlay_hint.enable(false, { 0 })
          print("Inlay Hint enabled.")
        else
          vim.lsp.inlay_hint.enable(true, { 0 })
          print("Inlay Hint disabled.")
        end
      end
    end,
  },
  {
    name = "ToggleCmp",
    fn = function()
      local cmp = require("cmp")
      local enabled = cmp.get_config().enabled
      if enabled == false or (type(enabled) == "function" and not enabled()) then
        cmp.setup({ enabled = true })
        print("Completion enabled.")
      else
        cmp.setup({ enabled = false })
        print("Completion disabled.")
      end
    end,
  },
  {
    name = "Memo",
    fn = function()
      vim.api.nvim_command("edit ~/wiki/workspace/memo.md")
    end,
  },
  {
    name = "Daily",
    fn = function()
      local d = os.date("%Y%m%d")
      local file = "~/wiki/dailylog/" .. d .. ".md"
      vim.api.nvim_command("edit " .. file)
    end,
  },
}

local setup = function()
  local common_opts = { force = true }
  for _, cmd in pairs(commands) do
    local opts = vim.tbl_deep_extend("force", common_opts, cmd.opts or {})
    vim.api.nvim_create_user_command(cmd.name, cmd.fn, opts)
  end
end

setup()
