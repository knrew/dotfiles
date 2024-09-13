#!/bin/env sh

set -eu

if ! type dotfiles-manager &> /dev/null; then
  cargo install --git https://github.com/knrew/dotfiles_manager.git --force 
fi

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd -P)
DOTFILES_DIR=${SCRIPT_DIR}/../
INSTALL_DIR=$HOME
BACKUP_DIR=${HOME}/.backup_dotfiles/

dotfiles-manager install $DOTFILES_DIR $INSTALL_DIR $BACKUP_DIR
# cd ~/codes/dotfiles_manager/ 
# cargo run --release -- install $DOTFILES_DIR $INSTALL_DIR $BACKUP_DIR
