[[ $- != *i* ]] && return

export PATH=$PATH:$HOME/.local/bin

# rust
if [ -f $HOME/.cargo/env ]; then
  source $HOME/.cargo/env
fi

if [ -f $HOME/.aliasrc ]; then
  source $HOME/.aliasrc
fi

if [ -f $HOME/.zshrc_local ]; then
  source $HOME/.zshrc_local
fi

# starship
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
eval "$(starship init zsh)"
