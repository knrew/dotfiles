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

# env
[[ -f $HOME/.env ]] && source "$HOME/.env"

# rust
[[ -f $HOME/.cargo/env ]] && source "$HOME/.cargo/env"

ZSHDIR=$HOME/.config/zsh
[[ -f $ZSHDIR/os.zsh ]] && source "$ZSHDIR/os.zsh"
[[ -f $ZSHDIR/aliases.zsh ]] && source "$ZSHDIR/aliases.zsh"
[[ -f $ZSHDIR/functions.zsh ]] && source "$ZSHDIR/functions.zsh"
[[ -f $ZSHDIR/fzf.zsh ]] && source "$ZSHDIR/fzf.zsh"
[[ -n $DOTFILES_OS && -f $ZSHDIR/os/$DOTFILES_OS.zsh ]] && source "$ZSHDIR/os/$DOTFILES_OS.zsh"
[[ -f $ZSHDIR/local.zsh ]] && source "$ZSHDIR/local.zsh"

# starship
STARSHIP_CONFIG=$HOME/.config/starship/starship.toml
[[ -f $STARSHIP_CONFIG ]] && export STARSHIP_CONFIG=$STARSHIP_CONFIG
type starship &> /dev/null && eval "$(starship init zsh)"

# zellij
type zellij &> /dev/null && eval "$(zellij setup --generate-auto-start zsh)"

# Show warning if battery level is below 20%
typeset -f alert_low_battery &> /dev/null && alert_low_battery 20
