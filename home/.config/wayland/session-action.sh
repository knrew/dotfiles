#!/bin/sh

action=${1:-}

case "$XDG_CURRENT_DESKTOP:$action" in
  [Hh]yprland:power-on | [Hh]yprland:power-off)
    exec hyprctl dispatch "hl.dsp.dpms({ action = \"${action#power-}\" })"
    ;;
  niri:power-on | niri:power-off)
    exec niri msg action "$action-monitors"
    ;;
  [Hh]yprland:logout)
    exec hyprctl dispatch 'hl.dsp.exit()'
    ;;
  niri:logout)
    exec niri msg action quit --skip-confirmation
    ;;
  *)
    printf 'Unsupported Wayland session action: %s (%s)\n' "$action" "$XDG_CURRENT_DESKTOP" >&2
    exit 1
    ;;
esac
