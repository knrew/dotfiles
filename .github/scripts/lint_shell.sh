#!/bin/env bash

set -euo pipefail

list_shell_files() {
  find . \
    -type d \( -name .git \) -prune -o \
    -type f \( \
    -name "*.sh" -o \
    -name "*.bash" -o \
    -name "*.bashrc" -o \
    -name "*.bash_profile" -o \
    -name "*.zsh" -o \
    -name "*.zshrc" -o \
    -name "*.zprofile" -o \
    -name "*.xinitrc" \
    \) \
    ! \( \
    -name "*fzf.zsh" \
    \) \
    -print0
}

mapfile -d '' -t files < <(list_shell_files)

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No shell files found."
  exit 0
fi

shellcheck "${files[@]}" &&
  shfmt -d "${files[@]}"
