if [[ -z $DISPLAY && -z $WAYLAND_DISPLAY && ${XDG_VTNR:-0} -eq 1 ]]; then
  export XMODIFIERS='@im=fcitx'
  export QT_IM_MODULE=fcitx
  exec niri-session -l
fi
