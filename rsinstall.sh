#!/bin/env sh

set -eu

if ! type dotfiles_installer &> /dev/null; then
  git clone git@github.com:knrew/dotfiles_installer.git
  cd dotfiles_installer
  cargo install --path .
  cd ..
fi

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd -P)
DOTFILES_DIR=$SCRIPT_DIR
HOME_DIR=$HOME
BACKUP_DIR=${SCRIPT_DIR}/.backup_dotfiles/

dotfiles_installer --dotfiles $DOTFILES_DIR --install $HOME_DIR --backup $BACKUP_DIR
