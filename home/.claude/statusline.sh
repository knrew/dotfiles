#!/usr/bin/env bash

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0 | round')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

model_part="$model"
[[ -n "$effort" ]] && model_part="${model} (${effort})"

metrics="Ctx ${remaining}%"
if [[ -n "$five_hour" ]]; then
  five_hour_remaining=$(awk -v v="$five_hour" 'BEGIN { printf "%.0f", 100 - v }')
  metrics="${metrics} / 5h ${five_hour_remaining}%"
  [[ -n "$five_hour_resets" ]] && metrics="${metrics} ($(date -d "@${five_hour_resets}" +%H:%M))"
fi
if [[ -n "$seven_day" ]]; then
  seven_day_remaining=$(awk -v v="$seven_day" 'BEGIN { printf "%.0f", 100 - v }')
  metrics="${metrics} / 7d ${seven_day_remaining}%"
  [[ -n "$seven_day_resets" ]] && metrics="${metrics} ($(date -d "@${seven_day_resets}" "+%-m/%-d %H:%M"))"
fi

echo "${model_part} | Remaining: ${metrics}"
