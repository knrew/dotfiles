# package manager
alias pacman_update="sudo pacman -Syy"

if ((${+commands[fzf]})); then
  alias pacmanls="pacman -Qn | fzf --preview \"pacman -Qi {1}\""
  alias aurls="pacman -Qm | fzf --preview \"pacman -Qi {1}\""
  alias pacmanrm="pacman -Qn | fzf --multi --preview \"pacman -Qi {1}\" | xargs -ro sudo pacman -Rns"
  alias aurrm="pacman -Qm | fzf --multi --preview \"pacman -Qi {1}\" | xargs -ro sudo pacman -Rns"
fi

alias pacman_install=paruz
# alias aur_install=paruz
