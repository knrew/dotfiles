STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
[[ -f $STARSHIP_CONFIG ]] && export STARSHIP_CONFIG
((${+commands[starship]})) && eval "$(starship init zsh)"

((${+commands[zellij]})) && eval "$(zellij setup --generate-auto-start zsh)"
