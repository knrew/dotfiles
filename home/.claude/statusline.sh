#!/usr/bin/env bash

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // "0"')
echo "${model} | Remaining Context: ${remaining}% left"
