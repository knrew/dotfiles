#!/bin/env sh

set -eu

# dotfiles-managerをインストールする．
if ! command -v dotfiles-manager > /dev/null 2>&1; then
  cargo install --git https://github.com/knrew/dotfiles-manager.git --force
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd -P)

DOTFILES_DIR=${SCRIPT_DIR}/../

HOME_DIR=$HOME

dotfiles-manager backup "$DOTFILES_DIR" "$HOME_DIR"
