# source zsh
alias loadrc="source $HOME/.zshrc"

# ls
alias ll="ls -alF"
alias la="ls -A"
alias l=ls
# alias l="ls -CF"

# clipboard
alias clip="xclip -selection c"

# lazygit
alias lg=lazygit

# enable/disable backlight auto off
alias enable_sleep="(xset s on +dpms)"
alias disable_sleep="(xset s off -dpms)"

# package manager
alias pacmanls="pacman -Q"
alias aurls="pacman -Qm"

#
# tex
#
alias lm="latexmk -pvc -halt-on-error"

#
# cpp
#
function cppb() { # build(with cmake)
  if [ ! -f CMakeLists.txt ]; then
    command echo "Error: No CMakeLists.txt"
    return 1
  fi
  command mkdir -p build
  # cmake -GNinja -B build -S .
  cmake -B build -S .
  cmake --build build -- $1
}
function cppr() { # build and run target
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
