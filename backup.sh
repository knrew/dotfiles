#!/bin/bash

DOTFILES_DIR=$(cd $(dirname $0);pwd)

mkdir -p ${DOTFILES_DIR}/.config/i3/
mkdir -p ${DOTFILES_DIR}/.config/i3status/
mkdir -p ${DOTFILES_DIR}/.config/termite/

cp ${HOME}/.bash_profile ${DOTFILES_DIR}
cp ${HOME}/.bashrc ${DOTFILES_DIR}
cp ${HOME}/.config/i3/config ${DOTFILES_DIR}/.config/i3/
cp ${HOME}/.config/i3status/config ${DOTFILES_DIR}/.config/i3status/ 
cp ${HOME}/.gitconfig ${DOTFILES_DIR}
cp ${HOME}/.latexmkrc ${DOTFILES_DIR}
cp ${HOME}/.vimrc ${DOTFILES_DIR}
cp ${HOME}/.Xmodmap ${DOTFILES_DIR}
cp ${HOME}/.screenrc ${DOTFILES_DIR}
cp ${HOME}/.xinitrc ${DOTFILES_DIR}
cp ${HOME}/.config/termite/config ${DOTFILES_DIR}/.config/termite
