#!/bin/bash

DOTFILES_DIR=$(cd $(dirname $0);pwd)

mkdir -p ${HOME}/.config/i3/
mkdir -p ${HOME}/.config/i3status

cp ${DOTFILES_DIR}/.bash_profile ${HOME}
cp ${DOTFILES_DIR}/.bashrc ${HOME}
cp ${DOTFILES_DIR}/.config/i3/config ${HOME}/.config/i3
cp ${DOTFILES_DIR}/.config/i3status/config ${HOME}/.config/i3status 
cp ${DOTFILES_DIR}/.gitconfig ${HOME}
cp ${DOTFILES_DIR}/.latexmkrc ${HOME}
cp ${DOTFILES_DIR}/.vimrc ${HOME}
cp ${DOTFILES_DIR}/.Xmodmap ${HOME}
cp ${DOTFILES_DIR}/.bashrc_ros ${HOME} 
cp ${DOTFILES_DIR}/.bashrc_stm ${HOME}
cp ${DOTFILES_DIR}/.screenrc ${HOME}

