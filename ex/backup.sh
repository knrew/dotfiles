#!/bin/env sh

set -eu

if ! type dotfiles-manager &> /dev/null; then
  cargo install --git https://github.com/knrew/dotfiles_manager.git --force 
fi

SCRIPT_DIR=$(cd "$(dirname $0)" && pwd -P)
DOTFILES_DIR=${SCRIPT_DIR}/../

dotfiles-manager backup $DOTFILES_DIR $HOME
# cd ~/codes/dotfiles_manager/ 
# cargo run --release -- backup $DOTFILES_DIR $HOME


