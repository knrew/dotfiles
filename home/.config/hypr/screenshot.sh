#!/bin/sh
set -eu

case "$1" in
  output)
    output=$(hyprctl -j monitors | jq -er '.[] | select(.focused) | .name')
    set -- -o "$output"
    ;;
  region)
    geometry=$(slurp -d < /dev/null) || exit 0
    set -- -g "$geometry"
    ;;
  window)
    geometry=$(hyprctl -j activewindow | jq -er '
      select(.at and .size and .size[0] > 0 and .size[1] > 0)
      | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
    ') || exit 0
    set -- -g "$geometry"
    ;;
  *)
    exit 2
    ;;
esac

dir=$HOME/Pictures/screenshots
mkdir -p -- "$dir"
file=$(mktemp "$dir/screenshot_$(date +%Y%m%d_%H%M%S)_XXXXXX.png")
if ! grim "$@" "$file" || [ ! -s "$file" ]; then
  rm -f -- "$file"
  notify-send 'Screenshot failed' 'grim could not capture the image.'
  exit 1
fi

if wl-copy --type image/png < "$file"; then
  notify-send 'Screenshot saved and copied' "$file"
else
  notify-send 'Screenshot saved' "$file"
fi
