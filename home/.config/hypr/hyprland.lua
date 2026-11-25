-- luacheck: globals hl

local draftpad = "draftpad"
local draftpad_workspace = "special:" .. draftpad
local terminal = "alacritty"
local config_dir = debug.getinfo(1, "S").source:match("^@(.*/)") or "./"
local config_root = "'" .. (config_dir .. ".."):gsub("'", "'\\''") .. "'"

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")

hl.config({
  general = {
    layout = "master",
    gaps_in = 0,
    gaps_out = 0,
    border_size = 1,
    col = {
      active_border = "#1e66f5",
      inactive_border = "#9ca0b0",
    },
  },
  input = {
    kb_layout = "jp",
    kb_model = "jp106",
    kb_options = "caps:super",
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      tap_to_click = false,
    },
  },
  animations = { enabled = false },
  decoration = {
    dim_inactive = true,
    dim_strength = 0.05,
    dim_special = 0.05,
    blur = { enabled = false },
    shadow = { enabled = false },
  },
  misc = {
    disable_hyprland_logo = true,
    key_press_enables_dpms = true,
    mouse_move_enables_dpms = true,
  },
})

hl.device({ name = "elecom-elecom-trackball-mouse-1", natural_scroll = true })

hl.window_rule({ match = { class = "^herdr$" }, workspace = "3 silent" })
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
  if os.getenv("HYPRLAND_NO_SD_TARGET") == "1" then
    hl.exec_cmd("sh " .. config_root .. "/waybar/start.sh")
  end
  hl.exec_cmd("fcitx5 -d")
  hl.exec_cmd("blueman-applet")
  hl.exec_cmd("nm-applet --indicator")
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

hl.bind("SUPER + T", hl.dsp.exec_cmd(terminal))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + N", hl.dsp.workspace.toggle_special(draftpad))
hl.bind("SUPER + Tab", hl.dsp.window.cycle_next({ tiled = true }))

local function set_workspace_layout(layout)
  local workspace = hl.get_active_workspace()
  if workspace then
    hl.workspace_rule({ workspace = workspace.addressable_name, layout = layout })
  end
end

hl.bind("SUPER + M", function()
  set_workspace_layout("master")
end, { description = "Set this workspace to Master" })
hl.bind("SUPER + SHIFT + M", function()
  set_workspace_layout("monocle")
end, { description = "Set this workspace to Monocle" })

hl.bind("SUPER + SHIFT + comma", function()
  local workspace = hl.get_active_workspace()
  local window = hl.get_active_window()
  if workspace and workspace.tiled_layout == "master" and window and not window.floating then
    hl.dispatch(hl.dsp.layout("swapwithmaster master ignoremaster"))
  end
end, { description = "Swap the focused window with Master" })

for key, direction in pairs({ H = "left", J = "down", K = "up", L = "right" }) do
  hl.bind("SUPER + " .. key, hl.dsp.focus({ direction = direction }))
end

hl.bind("SUPER + F", function()
  local window = hl.get_active_window()
  if not window then
    return
  end

  local was_floating = window.floating
  hl.dispatch(hl.dsp.window.float())
  if window.floating ~= was_floating then
    hl.notification.create({
      text = window.floating and "Floating" or "Tiled",
      timeout = 1000,
      icon = "info",
    })
  end
end, { description = "Toggle floating" })
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind("SUPER + SHIFT + Q", hl.dsp.window.close())
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("swaylock -f"))
hl.bind("SUPER + SHIFT + E", hl.dsp.exec_cmd("sh " .. config_root .. "/wayland/power-menu.sh"))
hl.bind("SUPER + SHIFT + Escape", hl.dsp.exit())

for _, action in ipairs({
  {
    keys = { "F1", "XF86AudioMute" },
    command = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
    description = "Toggle audio mute",
  },
  {
    keys = { "F2", "XF86AudioLowerVolume" },
    command = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-",
    description = "Lower volume",
    repeating = true,
  },
  {
    keys = { "F3", "XF86AudioRaiseVolume" },
    command = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 1%+",
    description = "Raise volume",
    repeating = true,
  },
  {
    keys = { "F4", "XF86MonBrightnessDown" },
    command = "brightnessctl --class=backlight set 1%-",
    description = "Lower brightness",
    repeating = true,
  },
  {
    keys = { "F5", "XF86MonBrightnessUp" },
    command = "brightnessctl --class=backlight set +1%",
    description = "Raise brightness",
    repeating = true,
  },
  {
    keys = { "XF86AudioMicMute" },
    command = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",
    description = "Toggle microphone mute",
  },
}) do
  for _, key in ipairs(action.keys) do
    hl.bind(key, hl.dsp.exec_cmd(action.command), {
      locked = true,
      repeating = action.repeating or false,
      description = action.description,
    })
  end
end

for _, mode in ipairs({
  { modifiers = "", target = "output", description = "focused monitor" },
  { modifiers = "SHIFT + ", target = "region", description = "selected area" },
  { modifiers = "CTRL + ", target = "window", description = "focused window" },
}) do
  hl.bind(
    "SUPER + " .. mode.modifiers .. "Print",
    hl.dsp.exec_cmd("sh " .. config_root .. "/hypr/screenshot.sh " .. mode.target),
    { description = "Screenshot: " .. mode.description }
  )
  hl.bind(
    "SUPER + " .. mode.modifiers .. "BackSpace",
    hl.dsp.exec_cmd("sh " .. config_root .. "/hypr/record.sh " .. mode.target),
    { description = "Toggle recording: " .. mode.description }
  )
end
