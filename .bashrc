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

#rm -> trash-put
if type trash-put &> /dev/null
then
    alias rm=trash-put
fi

export PATH=$PATH:$HOME/.local/bin

# neovim
#XDG_CONFIG_HOME=$HOME/.config
alias vi='nvim'
alias vim='nvim'
alias vimrc='(nvim $HOME/.config/nvim/init.vim)' 
alias vieuc='vi -c ":e ++enc=euc-jp"'

# tex
alias lm="latexmk -pvc -halt-on-error"

# Rust
source $HOME/.cargo/env

alias swiki='(cd $HOME/wiki && gitit -f gitit.conf)'
alias bashrc='(nvim $HOME/.bashrc)'
alias i3config='(nvim $HOME/.config/i3/config)'

alias pycharm='(sh /usr/local/pycharm-community-2020.1.2/bin/pycharm.sh)'
