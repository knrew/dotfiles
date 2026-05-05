[[ -z $DISPLAY && ${XDG_VTNR:-0} -eq 1 ]] && (($+commands[startx])) && exec startx
