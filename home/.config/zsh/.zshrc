ZSHDIR="${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"

function __dotfiles_source_zsh {
  [[ -r "$ZSHDIR/$1" ]] && source "$ZSHDIR/$1"
}

__dotfiles_source_zsh os.zsh
__dotfiles_source_zsh options.zsh
__dotfiles_source_zsh history.zsh
__dotfiles_source_zsh completion.zsh
__dotfiles_source_zsh aliases.zsh
__dotfiles_source_zsh ai.zsh
__dotfiles_source_zsh dev.zsh
__dotfiles_source_zsh fzf.zsh
__dotfiles_source_zsh battery.zsh
[[ -n $DOTFILES_OS ]] && __dotfiles_source_zsh "os/$DOTFILES_OS.zsh"
__dotfiles_source_zsh local.zsh

__dotfiles_source_zsh integrations.zsh
__dotfiles_source_zsh notifications.zsh

unfunction __dotfiles_source_zsh
