-- luacheck: globals hl

local draftpad = "draftpad"
local draftpad_workspace = "special:" .. draftpad
local terminal = "alacritty"
local config_dir = debug.getinfo(1, "S").source:match("^@(.*/)") or "./"
local waybar_dir = (config_dir .. "../waybar"):gsub("'", "'\\''")
local waybar = "cd '" .. waybar_dir .. "' && exec waybar -c ./config.hyprland.jsonc -s ./style.css"

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")

hl.config({
  general = {
    layout = "master",
    gaps_in = 0,
    gaps_out = 0,
    border_size = 2,
  },
  input = {
    kb_layout = "jp",
    kb_model = "jp106",
    kb_options = "caps:super",
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      tap_to_click = true,
    },
  },
  animations = { enabled = false },
  decoration = {
    blur = { enabled = false },
    shadow = { enabled = false },
  },
  misc = { disable_hyprland_logo = true },
})

hl.device({ name = "elecom-elecom-trackball-mouse-1", natural_scroll = true })

hl.window_rule({ match = { class = "^herdr$" }, workspace = "1 silent" })
hl.window_rule({
  match = { class = [[(?i)^(google-chrome(-stable)?|com\.google\.chrome)$]] },
  workspace = "2 silent",
})
hl.window_rule({
  match = { class = [[(?i)^(md\.obsidian\.)?obsidian$]] },
  workspace = "5 silent",
})
hl.window_rule({
  match = { class = "^draftpad$" },
  workspace = draftpad_workspace .. " silent",
  float = true,
  center = true,
  size = { "monitor_w * 0.65", "monitor_h * 0.65" },
})

hl.on("hyprland.start", function()
  hl.exec_cmd(waybar)
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("alacritty --class herdr,herdr --title Herdr -e herdr")
  hl.exec_cmd(
    [[alacritty --class draftpad,draftpad --title draftpad -e nvim "$HOME/Documents/draft.md"]]
  )
end)

for number = 1, 10 do
  local key = tostring(number % 10)
  local workspace = tostring(number)
  hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }))
  hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
end

hl.bind("SUPER + Return", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + N", hl.dsp.workspace.toggle_special(draftpad))
hl.bind("SUPER + Tab", hl.dsp.window.cycle_next({ tiled = true }))

hl.bind("SUPER + E", function()
  local workspace = hl.get_active_workspace()
  if not workspace then
    return
  end

  local layout = workspace.tiled_layout == "monocle" and "master" or "monocle"
  hl.workspace_rule({ workspace = workspace.addressable_name, layout = layout })
end, { description = "Toggle Monocle and Master on this workspace" })

for key, direction in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
  hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
end

hl.bind("SUPER + SHIFT + space", hl.dsp.window.float())
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("swaylock -f"))
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exit())
