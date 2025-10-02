#!/bin/env sh

set -eu

I3_RESURRECT_DIR="$HOME/.cache/i3-resurrect"

command mkdir -p "$I3_RESURRECT_DIR"

if [ "$1" = "save" ]; then
  if [ -n "$(ls "$I3_RESURRECT_DIR")" ]; then
    command rm "$I3_RESURRECT_DIR/*"
  fi
  i3-msg -t get_workspaces | sed 's/},{/\n/g' | awk -F, '{print $3}' | awk -F: '{print $2}' | xargs -n1 i3-resurrect save -d "$I3_RESURRECT_DIR" -w
elif [ "$1" = "restore" ]; then
  i3-resurrect ls -d "$I3_RESURRECT_DIR" | sed -n '/programs/!p' | awk '{print $2}' | xargs -n1 i3-resurrect restore -d "$I3_RESURRECT_DIR" -w
else
  command echo "argument: \"save\" or \"restore\""
fi
