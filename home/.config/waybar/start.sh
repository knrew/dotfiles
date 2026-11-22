#!/bin/sh

case "$XDG_CURRENT_DESKTOP" in
  [Hh]yprland)
    cd "$(dirname "$0")" || exit
    exec waybar -c ./config.hyprland.jsonc -s ./style.css
    ;;
  *)
    exec waybar
    ;;
esac
