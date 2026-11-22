if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && -n ${XDG_VTNR:-} ]]; then
  export XMODIFIERS='@im=fcitx'
  export QT_IM_MODULE=fcitx

  if [[ $XDG_VTNR == 1 && -r ${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.lua ]] &&
    command -v start-hyprland > /dev/null; then
    exec start-hyprland
  fi
fi
