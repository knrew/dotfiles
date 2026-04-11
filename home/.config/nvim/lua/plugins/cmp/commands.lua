local M = {}

function M.toggle()
  local cmp = require("cmp")
  local enabled = cmp.get_config().enabled

  if enabled == false or (type(enabled) == "function" and not enabled()) then
    cmp.setup({ enabled = true })
    print("Completion enabled.")
  else
    cmp.setup({ enabled = false })
    print("Completion disabled.")
  end
end

return M
