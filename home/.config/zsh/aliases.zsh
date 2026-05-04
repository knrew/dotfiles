# source zshrc
function loadrc() {
  source "$HOME/.zshrc"
}

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

alias cx=codex
alias cl=claude
alias oc=opencode
zc() { # claude code with glm
  ANTHROPIC_AUTH_TOKEN="$ZAI_API_KEY" \
    ANTHROPIC_BASE_URL="https://api.z.ai/api/anthropic" \
    API_TIMEOUT_MS="3000000" \
    ANTHROPIC_DEFAULT_HAIKU_MODEL="glm-4.7-flash" \
    ANTHROPIC_DEFAULT_SONNET_MODEL="glm-4.7" \
    ANTHROPIC_DEFAULT_OPUS_MODEL="glm-4.7" \
    claude "$@"
}

# enable/disable backlight auto off
alias enable_sleep="(xset s on +dpms)"
alias disable_sleep="(xset s off -dpms)"

#
# tex
#
alias lm="latexmk -pvc -halt-on-error"

#
# c/cpp
#
function cppb() { # build(with cmake)
  if [ ! -f CMakeLists.txt ]; then
    command echo "Error: No CMakeLists.txt" >&2
    return 1
  fi
  command mkdir -p build >&2
  # cmake -GNinja -B build -S . >&2
  cmake -B build -S . >&2
  cmake --build build -- "$1" >&2
}
function cppr() { # build and run target
  if [ $# = 0 ]; then
    cppb main >&2 && ./build/main
  else
    cppb "$1" >&2 && ./build/"$1" "${@:2}"
  fi
}
function cppc() { # clean
  if [ ! -f CMakeLists.txt ]; then
    command echo "Error: No CMakeLists.txt"
    return 1
  fi
  command rm -r build && echo "\"build\" has removed."
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
