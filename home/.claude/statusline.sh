#!/usr/bin/env bash

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0 | round')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

model_part="$model"
[[ -n "$effort" ]] && model_part="${model} (${effort})"

metrics=""
if [[ -n "$five_hour" ]]; then
  five_hour_remaining=$(printf "%.0f" "$(echo "100 - $five_hour" | bc)")
  metrics="5h ${five_hour_remaining}%"
fi
if [[ -n "$seven_day" ]]; then
  seven_day_remaining=$(printf "%.0f" "$(echo "100 - $seven_day" | bc)")
  metrics="${metrics:+$metrics / }7d ${seven_day_remaining}%"
fi
metrics="${metrics:+$metrics / }Ctx ${remaining}%"

echo "${model_part} | Remaining: ${metrics}"
