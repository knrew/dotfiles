#!/bin/env sh

set -eu

# dotfiles-managerをインストールする
if ! type dotfiles-manager &> /dev/null; then
  cargo install --git https://github.com/knrew/dotfiles-manager.git --force 
fi

script_dir=$(cd "$(dirname $0)" && pwd -P)

# ~/.dotfiles/
dotfiles_dir=${script_dir}/../

# インストール先となるディレクトリ
# ~/
home_dir=$HOME

# ~/.backup_dotfiles/
backup_dir=${home_dir}/.backup_dotfiles/

dotfiles-manager install $dotfiles_dir $home_dir -b $backup_dir
# cd ~/codes/dotfiles_manager/ 
# cargo run --release -- install $dotfiles_dir $home_dir $backup_dir
