#!/bin/sh

set -eu

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.backup_dotfiles/$(date +%Y%m%d_%H%M)"
HOME_DIR=$HOME

stack=()
stack_top_index=0
stack_bottom_index=0

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

function link_or_stack() {
  if [ -d $1 ]; then
      stack[$stack_bottom_index]=$1
      stack_bottom_index=$(($stack_bottom_index + 1))
    else
      link ${1#$DOTFILES_DIR/}
  fi
}

function scan_dir() {
  for entry in $1/.??*; do
    [[ `basename $entry` == ".git" ]] && continue
    [[ `basename $entry` == ".??*" ]] && continue
    link_or_stack $entry
  done

  if [ $1 == $DOTFILES_DIR ]; then
    return 0
  fi

  for entry in $1/??*; do
    [[ `basename $entry` == "??*" ]] && continue
    link_or_stack $entry
  done
}

function main() {
  command echo "installing dotfiles..."

  stack[0]=$DOTFILES_DIR
  stack_bottom_index=1

  while [ $stack_top_index != $stack_bottom_index ]; do
    top=${stack[$stack_top_index]}
    stack_top_index=$(($stack_top_index + 1))

    scan_dir $top
  done

  command echo -e "\e[1;36m Install completed! \e[m"
}

main