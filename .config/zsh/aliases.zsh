# source zshrc
alias loadrc="source $HOME/.zshrc"

# ls -> eza
if type eza &> /dev/null; then
  alias ls=eza
else
  alias ls="ls --color=auto"
fi

# ls
alias ll="ls -alF"
alias la="ls -A"
alias l=ls
# alias l="ls -CF"

# nvim
if type nvim &> /dev/null; then
  export EDITOR=nvim
  alias vim=nvim
  alias vi=nvim
  alias v=nvim
fi

# rm -> trash-put
 type trash-put &> /dev/null && alias rm=trash-put

# grep -> ripgrep
 type rg &> /dev/null && alias grep=rg

# cat -> bat
type bat &> /dev/null && alias cat=bat

# clipboard
alias clip="xclip -selection c"

# lazygit
alias lg=lazygit

# enable/disable backlight auto off
alias enable_sleep="(xset s on +dpms)"
alias disable_sleep="(xset s off -dpms)"

# package manager(fzf functions for package manager are defined in fzf.zsh)
alias pacman_update="sudo pacman -Syy" 

#
# tex
#
alias lm="latexmk -pvc -halt-on-error"

#
# c/cpp
#
function clangb() { # build(with cmake)
  if [ ! -f CMakeLists.txt ]; then
    command echo "Error: No CMakeLists.txt"
    return 1
  fi
  command mkdir -p build
  # cmake -GNinja -B build -S .
  cmake -B build -S .
  cmake --build build -- $1
}
function clangr() { # build and run target
  if [ $# = 0 ]; then
    command echo "Error: Specify target"
    return 1
  fi
  cppb $1 && build/$1 ${@:2}
}

#
# rust
#
alias cb="cargo build"
alias cbr="cargo build --release"
alias cr="cargo run"
alias crr="cargo run --release"
alias ct="cargo test"
alias ctr="cargo test --release"
