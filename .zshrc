[[ $- != *i* ]] && return

# rust
if [ -f "$HOME/.cargo/env" ]; then
  source $HOME/.cargo/env
fi

# starship
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

export PATH=$PATH:$HOME/.local/bin

if [ -f $HOME/.aliasrc ]; then
  source $HOME/.aliasrc
fi

if [ -f $HOME/.zshrc_local ]; then
  source $HOME/.zshrc_local
fi

eval "$(starship init zsh)"
