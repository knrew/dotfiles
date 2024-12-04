# completion
autoload -Uz compinit promptinit
compinit
promptinit

# history
export HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt hist_ignore_dups
setopt extended_history
setopt incappendhistory

export PATH=$PATH:$HOME/.local/bin

# rust
[[ -f $HOME/.cargo/env ]] && source $HOME/.cargo/env 

ZSHDIR=$HOME/.config/zsh
[[ -f $ZSHDIR/aliases.zsh ]] && source $ZSHDIR/aliases.zsh
[[ -f $ZSHDIR/fzf.zsh ]] && source $ZSHDIR/fzf.zsh
[[ -f $ZSHDIR/config_local.zsh ]] && source $ZSHDIR/config_local.zsh

# starship
STARSHIP_CONFIG=$HOME/.config/starship/starship2.toml
[[ -f $STARSHIP_CONFIG ]] && export STARSHIP_CONFIG=$STARSHIP_CONFIG
type starship &> /dev/null && eval "$(starship init zsh)"
