function get_battery_level {
  if ((${+commands[acpi]})); then
    acpi -b | grep -o '[0-9]+%' | cut -d% -f1
  fi
}

function alert_low_battery {
  local battery_level yellow reset

  battery_level=$(get_battery_level)
  if [[ -n $1 && -n $battery_level && $battery_level -le $1 ]]; then
    yellow="\033[0;33m"
    reset="\033[0m"
    printf "${yellow}Warning: Battery is low(%s%%)!${reset}\n" "$battery_level"
  fi
}

# autoload -Uz add-zsh-hook
# add-zsh-hook precmd alert_low_battery
