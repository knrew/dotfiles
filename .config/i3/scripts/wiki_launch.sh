#!/bin/sh

set -eu

# pkill gitit

if [ -d "$HOME/wiki" ]; then
  if type gitit > /dev/null 2>&1; then
    command cd "$HOME/wiki"
    command gitit -f gitit_files/gitit.conf &
  fi
fi