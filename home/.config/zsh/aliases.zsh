function loadrc {
  source "${ZDOTDIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}/.zshrc"
}

# ls -> eza
if ((${+commands[eza]})); then
  alias ls=eza
else
  alias ls="ls --color=auto"
fi

# ls
alias ll="ls -alF"
alias la="ls -A"
alias l=ls
# alias l="ls -CF"

# nvim
if ((${+commands[nvim]})); then
  alias vim=nvim
  alias vi=nvim
  alias v=nvim
fi

# rm -> trash-put
# shfmt parses commands[trash-put] as commands[trash - put], so use a variable.
_trash_cmd=trash-put
(($+commands[$_trash_cmd])) && alias rm=$_trash_cmd
unset _trash_cmd

# grep -> ripgrep
((${+commands[rg]})) && alias grep=rg

# cat -> bat
((${+commands[bat]})) && alias cat=bat

alias lg=lazygit

# clipboard
alias clip="xclip -selection c"

# enable/disable backlight auto off
alias enable_sleep="(xset s on +dpms)"
alias disable_sleep="(xset s off -dpms)"
