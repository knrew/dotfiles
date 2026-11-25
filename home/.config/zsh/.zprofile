if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && -n ${XDG_VTNR:-} ]]; then
  export XMODIFIERS='@im=fcitx'
  export QT_IM_MODULE=fcitx

  if [[ $XDG_VTNR == 1 ]]; then
    tty1_session=hyprland # hyprland or niri

    case $tty1_session in
      hyprland)
        if [[ -r ${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.lua ]] &&
          command -v start-hyprland > /dev/null; then
          exec start-hyprland
        fi
        ;;
      niri)
        if command -v niri-session > /dev/null; then
          exec niri-session -l
        fi
        ;;
    esac
    unset tty1_session
  fi
fi
