function get_battery_level() {
  if command -v acpi &>/dev/null; then
    acpi -b | grep -o '[0-9]+%' | cut -d% -f1
  fi
}

function alert_low_battery() {
  battery_level=$(get_battery_level)
 if [[ -n $1 && -n $battery_level && $battery_level -le $1 ]]; then
    echo "\033[0;33mWarning: Battery is low(${battery_level}%)!\033[0m"
  fi
}

# autoload -Uz add-zsh-hook
# add-zsh-hook precmd alert_low_battery
