alias l='ls -CF'
alias la='ls -a'

alias vi='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
#ln -snfv ${HOME}/.vim ${HOME}/.config/nvim
#ln -snfv ${HOME}/.vimrc ${HOME}/.config/nvim/init.vim

alias lm="latexmk -pvc -halt-on-error"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
