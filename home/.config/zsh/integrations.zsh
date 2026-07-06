STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
[[ -f $STARSHIP_CONFIG ]] && export STARSHIP_CONFIG
((${+commands[starship]})) && eval "$(starship init zsh)"

#((${+commands[zellij]})) && eval "$(zellij setup --generate-auto-start zsh)"

# if [[ -o interactive && -t 0 && -t 1 ]] \
#   && [[ "${HERDR_AUTO_START:-1}" != "0" ]] \
#   && [[ "${HERDR_ENV:-0}" != "1" && -z "$HERDR_PANE_ID" ]] \
#   && [[ -z "$TMUX" && -z "$ZELLIJ" && -z "$ZELLIJ_SESSION_NAME" ]] \
#   && [[ "$TERM" != "dumb" ]] \
#   && ((${+commands[herdr]})); then
#   exec herdr
# fi
