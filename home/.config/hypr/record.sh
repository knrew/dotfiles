#!/bin/sh
set -eu

unit=hyprland-screen-recording.service
state=${XDG_RUNTIME_DIR:?}/hyprland-screen-recording

notify() {
  notify-send -a 'Screen recording' "$@" 9>&- || :
}

fail() {
  notify 'Screen recording failed' "$1"
  exit 1
}

exec 9> "$state.lock"
flock -n 9 || exit 0

if [ -f "$state" ]; then
  if systemctl --user is-active --quiet "$unit"; then
    systemctl --user stop "$unit" || fail 'Could not stop the recorder.'
  fi
  file=$(cat "$state")
  rm -f -- "$state"
  if ! stream=$(ffprobe -v error -select_streams v:0 -show_entries stream=index \
    -of csv=p=0 "$file") || [ -z "$stream" ]; then
    [ -s "$file" ] || rm -f -- "$file"
    fail 'No playable video was recorded.'
  fi
  uri=$(jq -nr --arg file "$file" '"file://" + ($file | @uri | gsub("%2F"; "/"))')
  if printf '%s\r\n' "$uri" | wl-copy --type text/uri-list 9>&-; then
    notify 'Recording saved and copied' "$file"
  else
    notify 'Recording saved' "$file"
  fi
  exit 0
fi

command -v wf-recorder > /dev/null || fail 'Install wf-recorder to use this shortcut.'

case "$1" in
  output)
    output=$(hyprctl -j monitors | jq -er '.[] | select(.focused) | .name') ||
      fail 'Could not find the focused monitor.'
    set -- -o "$output"
    ;;
  region | window)
    if [ "$1" = region ]; then
      geometry=$(slurp -d) || exit 0
    else
      geometry=$(hyprctl -j activewindow | jq -er '
        select(.at and .size) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"
      ') || fail 'Focus a window before recording.'
    fi
    # wf-recorder can fall back to the whole output for invalid geometry.
    hyprctl -j monitors | jq -e --arg geometry "$geometry" '
      ($geometry | capture("^(?<x>-?[0-9]+),(?<y>-?[0-9]+) (?<w>[0-9]+)x(?<h>[0-9]+)$")
        | map_values(tonumber)) as $r
      | $r.w > 0 and $r.h > 0 and any(.[];
          (if .transform % 2 == 0 then [.width, .height] else [.height, .width] end) as $size
          | (.x <= $r.x and .y <= $r.y
            and $r.x + $r.w <= .x + ($size[0] / .scale | round)
            and $r.y + $r.h <= .y + ($size[1] / .scale | round)))
    ' > /dev/null || fail 'Choose a rectangle entirely within one monitor.'
    set -- -g "$geometry"
    ;;
  *)
    exit 2
    ;;
esac

dir=$HOME/Videos/recordings
mkdir -p -- "$dir"
file=$(mktemp "$dir/recording_$(date +%Y%m%d_%H%M%S)_XXXXXX.mp4")
printf '%s\n' "$file" > "$state"
if ! systemd-run --user --quiet --collect --unit="$unit" --service-type=exec \
  --expand-environment=no --setenv="WAYLAND_DISPLAY=${WAYLAND_DISPLAY:?}" \
  --property=KillSignal=SIGINT --property=TimeoutStopSec=10s \
  /usr/bin/wf-recorder "$@" -y -F 'pad=ceil(iw/2)*2:ceil(ih/2)*2' -f "$file"; then
  rm -f -- "$state" "$file"
  fail 'Could not start the recorder.'
fi

notify 'Recording started' 'Press a recording shortcut to stop.'
