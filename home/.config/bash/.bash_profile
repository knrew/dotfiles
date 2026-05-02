# shellcheck shell=bash
#
# ~/.bash_profile
#

# shellcheck source=/dev/null
[[ -f $HOME/.bashrc ]] && . "$HOME/.bashrc"

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
