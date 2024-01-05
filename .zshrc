[[ $- != *i* ]] && return

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source $HOME/.cargo/env
fi

export PATH=$PATH:$HOME/.local/bin

source "$HOME/.aliasrc"

eval "$(starship init zsh)"
