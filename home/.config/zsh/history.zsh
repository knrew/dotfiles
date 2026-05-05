command mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"

HISTFILE=${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_dups
setopt extended_history
setopt incappendhistory
