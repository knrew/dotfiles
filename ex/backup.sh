#!/bin/env sh

set -eu

if ! type dotfiles-manager &> /dev/null; then
  cargo install --git https://github.com/knrew/dotfiles_manager.git --force 
fi

# dotfiles-managerをインストールする
if ! type dotfiles-manager &> /dev/null; then
  cargo install --git https://github.com/knrew/dotfiles-manager.git --force 
fi

script_dir=$(cd "$(dirname $0)" && pwd -P)

# ~/.dotfiles/
dotfiles_dir=${script_dir}/../

# ~/
home_dir=$HOME

dotfiles-manager backup $dotfiles_dir $home_dir
# cd ~/codes/dotfiles_manager/ 
# cargo run --release -- backup $dotfiles_dir $home_dir


