#!/bin/env sh

set -eu

if ! type $manager &> /dev/null; then
  git clone https://github.com/knrew/dotfiles_manager.git
  cd dotfiles_manager
  cargo install --path .
  cd ..
  command rm -f dotfiles_manager
fi

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd -P)
DOTFILES_DIR=${SCRIPT_DIR}/../
INSTALL_DIR=$HOME
BACKUP_DIR=${HOME}/.backup_dotfiles/

dotfiles-manager install $DOTFILES_DIR $INSTALL_DIR $BACKUP_DIR
