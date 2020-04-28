#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \w]\$ '

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

#neovim
XDG_CONFIG_HOME=$HOME/.config

#alias
alias vi='nvim'
alias vim='nvim'
alias gitit='gitit -f gitit.conf'
