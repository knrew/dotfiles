#!/bin/sh

set -eu

app_id="draftpad"
scratch_workspace="scratch"
lock_file="${XDG_RUNTIME_DIR:-/tmp}/niri-draftpad.lock"

notify_error() {
  notify-send --urgency=critical "Draftpad" "$1"
  exit 1
}

find_draftpad() {
  niri msg -j windows |
    jq -c --arg app_id "$app_id" \
      'first(.[] | select(.app_id == $app_id)) // empty'
}

exec 9> "$lock_file"
flock -n 9 || exit 0

draftpad=$(find_draftpad) || notify_error "niriからwindow一覧を取得できませんでした"

if [ -z "$draftpad" ]; then
  niri msg action spawn -- alacritty \
    --class "$app_id,$app_id" \
    --title "$app_id" \
    -e nvim "$HOME/Documents/draft.md" \
    > /dev/null

  attempt=0
  while [ "$attempt" -lt 40 ]; do
    sleep 0.05
    draftpad=$(find_draftpad) ||
      notify_error "起動後のdraftpadを確認できませんでした"
    [ -n "$draftpad" ] && break
    attempt=$((attempt + 1))
  done

  [ -n "$draftpad" ] ||
    notify_error "draftpadが2秒以内に起動しませんでした"

  window_id=$(printf '%s\n' "$draftpad" | jq -r '.id')
  niri msg action center-window --id "$window_id" > /dev/null
  niri msg action focus-window --id "$window_id" > /dev/null
  exit 0
fi

workspaces=$(niri msg -j workspaces) ||
  notify_error "niriからworkspace一覧を取得できませんでした"

window_id=$(printf '%s\n' "$draftpad" | jq -r '.id')
window_workspace_id=$(printf '%s\n' "$draftpad" | jq -r '.workspace_id')
current_workspace_id=$(
  printf '%s\n' "$workspaces" |
    jq -r 'first(.[] | select(.is_focused)).id // empty'
)
current_workspace_idx=$(
  printf '%s\n' "$workspaces" |
    jq -r 'first(.[] | select(.is_focused)).idx // empty'
)
scratch_workspace_id=$(
  printf '%s\n' "$workspaces" |
    jq -r --arg name "$scratch_workspace" \
      'first(.[] | select(.name == $name)).id // empty'
)

[ -n "$current_workspace_id" ] ||
  notify_error "現在のworkspaceを特定できませんでした"
[ -n "$scratch_workspace_id" ] ||
  notify_error "workspace \"$scratch_workspace\" がありません"

if [ "$window_workspace_id" = "$current_workspace_id" ]; then
  niri msg action move-window-to-workspace \
    --window-id "$window_id" --focus false "$scratch_workspace" \
    > /dev/null
else
  niri msg action move-window-to-workspace \
    --window-id "$window_id" --focus true "$current_workspace_idx" \
    > /dev/null
  niri msg action center-window --id "$window_id" > /dev/null
  niri msg action focus-window --id "$window_id" > /dev/null
fi
