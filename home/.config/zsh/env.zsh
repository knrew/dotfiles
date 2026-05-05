[[ -f $HOME/.env ]] && source "$HOME/.env"

((${+commands[nvim]})) && export EDITOR=nvim
