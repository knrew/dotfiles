#!/bin/env sh

set -eu

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd -P)
DOTFILES_DIR=$SCRIPT_DIR
BACKUP_DIR="$HOME/.backup_dotfiles/$(date +%Y%m%d_%H%M)"
HOME_DIR=$HOME

scanning_dirs=() # queue
scanning_dirs_top_index=0

function link() {
  if [ -f "$HOME_DIR/$1" ]; then 
    if [ -L "$HOME_DIR/$1" ]; then
      command rm "$HOME_DIR/$1"
    else
      command mkdir -p $(dirname "$BACKUP_DIR/$1")
      command mv "$HOME_DIR/$1" "$BACKUP_DIR/$1"
    fi
  fi

  command mkdir -p $(dirname "$HOME_DIR/$1")
  command ln -snf "$DOTFILES_DIR/$1" "$HOME_DIR/$1"
  command echo "installed: $1"
}

function link_or_push() {
  if [ -d $1 ]; then
      scanning_dirs[${#scanning_dirs[@]}]=$1 #push
    else
      link ${1#$DOTFILES_DIR/}
  fi
}

function scan_dir() {
  for entry in $1/.??*; do
    [[ `basename $entry` == ".git" ]] && continue
    [[ `basename $entry` == ".??*" ]] && continue
    link_or_push $entry
  done

  [[ $1 == $DOTFILES_DIR ]] && return 0
 
  for entry in $1/??*; do
    [[ `basename $entry` == "??*" ]] && continue
    link_or_push $entry
  done
}

function main() {
  command echo "installing dotfiles..."

  scanning_dirs[0]=$DOTFILES_DIR
  scanning_dirs_top_index=0

  while [ $scanning_dirs_top_index != ${#scanning_dirs[@]} ]; do
    top=${scanning_dirs[$scanning_dirs_top_index]}
    scanning_dirs_top_index=$(($scanning_dirs_top_index + 1)) #pop
    scan_dir $top
  done

  command echo -e "\e[1;36mInstall completed! \e[m"
}

main