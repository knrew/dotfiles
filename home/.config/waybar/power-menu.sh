#!/bin/sh

choose() {
  fuzzel \
    --dmenu \
    --only-match \
    --no-sort \
    --minimal-lines \
    --width=24 \
    --lines="$1" \
    --prompt="$2"
}

confirm_action() {
  answer=$(printf '%s\n' "Cancel" "Confirm" | choose 2 "$1? ")
  [ "$answer" = "Confirm" ]
}

choice=$(
  printf '%s\n' \
    "󰐥  Shutdown" \
    "󰜉  Reboot" \
    "󰤄  Suspend" \
    "󰍃  Log out" \
    "󰜺  Cancel" |
    choose 5 "Power: "
)

case "$choice" in
  "󰐥  Shutdown")
    confirm_action "Shutdown" && systemctl poweroff
    ;;
  "󰜉  Reboot")
    confirm_action "Reboot" && systemctl reboot
    ;;
  "󰤄  Suspend")
    systemctl suspend
    ;;
  "󰍃  Log out")
    confirm_action "Log out" && niri msg action quit --skip-confirmation
    ;;
esac
