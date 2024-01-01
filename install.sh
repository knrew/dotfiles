#!/bin/sh

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.backup_dotfiles_$(date +%Y%m%d_%H%M%S)"

make_link() {
  if [ ! -f "$DOTFILES_DIR/$1" ]; then 
    command echo -e "\e[31mnot exist: $DOTFILES_DIR/$1\e[m"
    return -1
  fi

  if [ -f "$HOME/$1" ]; then 
    if [ -L "$HOME/$1" ]; then
      command rm "$HOME/$1"
    else
      command mkdir -p $(dirname "$BACKUP_DIR/$1")
      command mv "$HOME/$1" "$BACKUP_DIR/$1"
    fi
  fi

  command mkdir -p $(dirname "$HOME/$1")
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
make_link ".config/i3/scripts/wiki_launch.sh"
make_link ".config/i3/scripts/resurrect_save.sh"
make_link ".config/i3/scripts/resurrect_restore.sh"
make_link ".config/i3status/config"
make_link ".config/i3-resurrect/config.json"
make_link ".config/nvim/init.vim"
make_link ".config/zathura/zathurarc"
make_link ".config/Code/User/settings.json"
make_link ".config/Code/User/keybindings.json"
make_link ".config/alacritty/alacritty.toml"
make_link ".config/polybar/config"
make_link ".config/polybar/polybar_launch.sh"
make_link ".config/rofi/config.rasi"

if [ -z "$(command ls -A $BACKUP_DIR)" ]; then
  command rm -r $BACKUP_DIR
else
  command echo "backup_dir: $BACKUP_DIR"
fi

command echo -e "\e[1;36m Install completed! \e[m"