#!/bin/env sh

set -eu

SCREENSHOT_DIR=$HOME/Pictures/screenshots
FILE_NAME=$SCREENSHOT_DIR/screenshot_%Y%m%d_%H%M%S.png

command mkdir -p "$SCREENSHOT_DIR"

if [ "$1" = "full" ]; then
  scrot "$FILE_NAME"
elif [ "$1" = "area" ]; then
  sleep 0.2 && scrot -s "$FILE_NAME"
else
  command echo "argument: \"full\" or \"area\""
fi
