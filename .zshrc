[[ $- != *i* ]] && return

export PATH=$PATH:$HOME/.local/bin

export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=1000
export SAVEHIST=10000
setopt hist_ignore_dups
setopt EXTENDED_HISTORY
setopt incappendhistory

# autoload -Uz compinit promptinit
# compinit
# promptinit

# rust
if [ -f $HOME/.cargo/env ]; then
  source $HOME/.cargo/env
fi

if [ -f $HOME/.aliases ]; then
  source $HOME/.aliases
fi

if [ -f $HOME/.zshrc_local ]; then
  source $HOME/.zshrc_local
fi

# starship
export STARSHIP_CONFIG=$HOME/.config/starship/starship2.toml
eval "$(starship init zsh)"
