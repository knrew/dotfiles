# Created by newuser for 5.9
[[ $- != *i* ]] && return

# Rust
if [ -f "$HOME/.cargo/env" ]; then
    source $HOME/.cargo/env
    
fi

source "$HOME/.aliasrc"

eval "$(starship init zsh)"
