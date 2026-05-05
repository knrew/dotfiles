#
# tex
#
alias lm="latexmk -pvc -halt-on-error"

#
# c/cpp
#
function cppb { # build(with cmake)
  if [[ ! -f CMakeLists.txt ]]; then
    command echo "Error: No CMakeLists.txt" >&2
    return 1
  fi
  command mkdir -p build >&2
  # cmake -GNinja -B build -S . >&2
  cmake -B build -S . >&2
  cmake --build build -- "$1" >&2
}

function cppr { # build and run target
  if (($# == 0)); then
    cppb main >&2 && ./build/main
  else
    cppb "$1" >&2 && ./build/"$1" "${@:2}"
  fi
}

function cppc { # clean
  if [[ ! -f CMakeLists.txt ]]; then
    command echo "Error: No CMakeLists.txt"
    return 1
  fi
  command rm -r build && echo "\"build\" has removed."
}

#
# Rust
#
alias cb="cargo build"
alias cbr="cargo build --release"
alias cr="cargo run"
alias crr="cargo run --release"
alias ct="cargo test"
alias ctr="cargo test --release"
