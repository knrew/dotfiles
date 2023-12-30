#!/bin/sh

HOME_DIR="$HOME/"
DOTFILES_DIR="$HOME_DIR/dotfiles/"
BACKUP_DIR="$HOME_DIR/dotfiles_backup/"

make_link() {
  if [ -f "$DOTFILES_DIR/$1" ]; then 
    :
  else
    command echo "$DOTFILES_DIR/$1 does not exist."
    return -1
  fi 
  if [ -f "$HOME_DIR/$1" ]; then 
    command mkdir -p $(dirname "$BACKUP_DIR/$1")
    command mv "$HOME_DIR/$1" "$BACKUP_DIR/$1"
  fi
  command ln -snf "$DOTFILES_DIR/$1" "$HOME/$1"
  command echo "installed: $1"
  return 0
}

command mkdir -p $BACKUP_DIR

make_link ".bash_profile"
make_link ".bashrc"
make_link ".latexmkrc"
make_link ".xinitrc"
make_link ".Xmodmap"
make_link ".gitconfig"
make_link ".config/i3/config"
make_link ".config/i3status/config"
make_link ".config/nvim/init.vim"
make_link ".config/zathura/zathurarc"
make_link ".config/Code/User/settings.json"
make_link ".config/Code/User/keybindings.json"
make_link ".config/alacritty/alacritty.toml"

command echo -e "\e[1;36m Install completed! \e[m"