#!/bin/env sh

set -eu

# dotfiles-managerをインストールする．
if ! command -v dotfiles-manager > /dev/null 2>&1; then
  cargo install --git https://github.com/knrew/dotfiles-manager.git --force
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)

# ~/.dotfiles/
DOTFILES_DIR=${SCRIPT_DIR}/../

# インストール先となるディレクトリ(~/)
HOME_DIR=$HOME

# ~/.backup_dotfiles/
BACKUP_DIR=${HOME_DIR}/.backup_dotfiles/

dotfiles-manager install "$DOTFILES_DIR" "$HOME_DIR" -b "$BACKUP_DIR"
