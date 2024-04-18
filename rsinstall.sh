#!/bin/env sh

set -eu

INSTALLER=dotfiles_installer

if ! type $INSTALLER &> /dev/null; then
  #git clone git@github.com:knrew/${INSTALLER}.git
  git clone https://github.com/knrew/${INSTALLER}.git
  cd $INSTALLER
  cargo install --path .
  cd ..
  command rm -rf $INSTALLER
fi

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd -P)
DOTFILES_DIR=$SCRIPT_DIR
HOME_DIR=$HOME
BACKUP_DIR=${SCRIPT_DIR}/.backup_dotfiles/

$INSTALLER --dotfiles $DOTFILES_DIR --install $HOME_DIR --backup $BACKUP_DIR
