#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\u@\h \w \$ '

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# rm -> trash-put
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi

export PATH=$PATH:$HOME/.local/bin

source $HOME/.cargo/env # Rust

# neovim
alias vi='nvim'
alias vim='nvim'
alias vimrc='(nvim $HOME/.config/nvim/init.vim)' 

alias bashrc='(nvim $HOME/.bashrc)'
alias reflebash='(source $HOME/.bashrc)'
alias i3config='(nvim $HOME/.config/i3/config)'

alias lm="latexmk -pvc -halt-on-error" # tex
alias swiki='(cd $HOME/wiki && gitit -f gitit_files/gitit.conf)'

alias dias='(xset s off -dpms)' # disable auto sleep
alias enas='(xset s on +dpms)' # enable auto sleep

alias pacmanls='pacman -Qqen'
alias yayls='pacman -Qqem'

#alias python=python3.8

#bash $HOME/Applications/manju.sh today true
