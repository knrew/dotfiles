local comment_commands = require("plugins.comment_commands")
local lsp_commands = require("plugins.lsp.commands")
local cmp_commands = require("plugins.cmp.commands")
local register_commands = require("utils.commands").register

local commands = {
  {
    name = "Format",
    fn = lsp_commands.format,
  },
  {
    name = "Rename",
    fn = lsp_commands.rename,
  },
  {
    name = "ToggleCommentNormal",
    fn = comment_commands.toggle_current,
  },
  {
    name = "ToggleCommentSelect",
    fn = comment_commands.toggle_visual,
  },
  {
    name = "ToggleInlayHint",
    fn = lsp_commands.toggle_inlay_hint,
  },
  {
    name = "ToggleCmp",
    fn = cmp_commands.toggle,
  },
}

register_commands(commands)