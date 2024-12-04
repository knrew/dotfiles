export FZF_DEFAULT_OPTS=" \
--reverse
--color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
--color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
--color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
--color=selected-bg:#bcc0cc \
--multi"

# repeat command history
function fh() {
  # eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed -E 's/ *[0-9]*\*? *//' | sed -E 's/\\/\\\\/g')
}

# cd(without hidden directories)
function fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# cd(including hidden directories)
function fda() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# cd(parent directories)
fdr() {
  local declare dirs=()
  get_parent_dirs() {
    if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
    if [[ "${1}" == '/' ]]; then
      for _dir in "${dirs[@]}"; do echo $_dir; done
    else
      get_parent_dirs $(dirname "$1")
    fi
  }
  local dir=$(get_parent_dirs $(realpath "${1:-$PWD}") | fzf-tmux --tac)
  cd "$dir"
}

# fuzzy cd from anywhere
# e.g.) cf word1 word2
function cf() {
  local file
  file="$(locate -Ai -0 $@ | command grep -z -vE '~$' | fzf --read0 -0 -1)"
  if [[ -n $file ]]; then
    if [[ -d $file ]]; then
      cd -- $file
    else
      cd -- ${file:h}
    fi
  fi
}

# open file/directory with vim(without hidden files)
function fe() {
  local file
  file=$(find ${1:-.} -path '*/\.*' -prune -o -print 2> /dev/null | fzf +m) &&
  ${EDITOR:-vim} "$file"
}

# open file/directory with vim(including hidden files)
function fea() {
  local file
  file=$(find ${1:-.} 2> /dev/null | fzf +m) && 
  ${EDITOR:-vim} "$file"
}

# fuzzy vim from anywhere
function vf() {
  local files
  files=(${(f)"$(locate -Ai -0 $@ | grep -z -vE '~$' | fzf --read0 -0 -1 -m)"})
  if [[ -n $files ]]; then
     ${EDITOR:-vim} -- $files
     print -l $files[1]
  fi
}

# kill processes
function fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi 
    if [ "x$pid" != "x" ]; then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# ls installed packages
alias pacmanls="pacman -Qn | fzf --preview \"pacman -Qi {1}\""
alias aurls="pacman -Qm | fzf --preview \"pacman -Qi {1}\""

# rm installed package
alias pacmanrm="pacman -Qn | fzf --multi --preview \"pacman -Qi {1}\" | xargs -ro sudo pacman -Rns"
alias aurrm="pacman -Qm | fzf --multi --preview \"pacman -Qi {1}\" | xargs -ro sudo pacman -Rns"

# install package
# alias pacman_install="pacman -Slq | fzf --multi --preview \"pacman -Si {1}\" | xargs -ro sudo pacman -S"
alias pacman_install=paruz
# alias aur_install=paruz
