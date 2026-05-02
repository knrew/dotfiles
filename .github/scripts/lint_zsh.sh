#!/usr/bin/env bash

set -euo pipefail

has_shebang() {
  local file=$1
  local first_line

  IFS= read -r first_line < "$file" || return 1

  [[ $first_line == '#!'* ]]
}

is_zsh_shebang() {
  local file=$1
  local first_line

  IFS= read -r first_line < "$file" || return 1

  case "$first_line" in
    '#!/bin/zsh' | '#!/bin/zsh '* | '#!/usr/bin/zsh' | '#!/usr/bin/zsh '* | \
      '#!/usr/bin/env zsh' | '#!/usr/bin/env zsh '* | '#!/usr/bin/env -S zsh' | '#!/usr/bin/env -S zsh '*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_zsh_extension() {
  local file=$1

  case "$file" in
    *.zsh)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

is_zsh_dotfile() {
  local file=$1

  case "${file##*/}" in
    .zshrc | .zprofile | .zshenv | .zlogin | .zlogout)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

list_zsh_files() {
  git ls-files -z | while IFS= read -r -d '' file; do
    if has_shebang "$file"; then
      if is_zsh_shebang "$file"; then
        printf '%s\0' "$file"
      fi
    elif is_zsh_extension "$file" || is_zsh_dotfile "$file"; then
      printf '%s\0' "$file"
    fi
  done
}

mapfile -d '' -t files < <(list_zsh_files)

if [[ ${#files[@]} -eq 0 ]]; then
  printf "No zsh files found.\n"
  exit 0
fi

printf 'zsh -n:\n'
for file in "${files[@]}"; do
  printf '%s\n' "$file"
  zsh -n "$file"
done

printf 'shfmt:\n'
shfmt -ln zsh -d "${files[@]}"
