#!/usr/bin/env bash

# statusline の入力 JSON にはモデル別週次枠がないため、利用枠 API から補う。
CACHE_DIR="${HOME}/.claude/cache"
USAGE_CACHE="${CACHE_DIR}/model-usage.json"
USAGE_STAMP="${CACHE_DIR}/model-usage.stamp"
USAGE_LOCK="${CACHE_DIR}/model-usage.lock"
USAGE_TTL=300 # Claude Code 本体の取得間隔に合わせる（秒）。
USAGE_STALE=3600

refresh_usage() {
  mkdir -p "$CACHE_DIR" || exit 0

  exec 9> "$USAGE_LOCK" || exit 0
  flock -n 9 || exit 0

  # 429 などの失敗時も連続リクエストを避けるため、成功時刻とは別に試行時刻を残す。
  local now stamp_age
  now=$(date +%s)
  stamp_age=$((now - $(stat -c %Y "$USAGE_STAMP" 2> /dev/null || echo 0)))
  ((stamp_age < USAGE_TTL)) && exit 0
  touch "$USAGE_STAMP"

  local tok
  tok=$(jq -r '.claudeAiOauth.accessToken // empty' "${HOME}/.claude/.credentials.json" 2> /dev/null)
  [[ -n "$tok" ]] || exit 0

  local version user_agent
  version=$(claude --version 2> /dev/null)
  version=${version%% *}
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || version=unknown
  user_agent="claude-cli/${version} (external, cli)"

  local tmp code
  tmp=$(mktemp "${CACHE_DIR}/model-usage.raw.XXXXXX") || exit 0

  # HTTP 200 を受け取った後でも転送は失敗しうるため、curl の終了ステータスも確認する。
  if code=$(curl -s -m 10 -o "$tmp" -w '%{http_code}' \
    -H "Authorization: Bearer ${tok}" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "User-Agent: ${user_agent}" \
    -H "Content-Type: application/json" \
    https://api.anthropic.com/api/oauth/usage 2> /dev/null) &&
    [[ "$code" == "200" ]]; then
    # limits: [] は取得失敗ではなく、モデル別週次枠がないことを表す。
    if jq -ces --argjson now "$now" '
          if length != 1 then error("Expected one usage response") else .[0] end
          | if type != "object" or .error != null or (.limits | type) != "array"
            then error("Invalid usage response") else . end
          | { fetched_at: $now,
              models: [ .limits[]
                        | if type != "object" or (.kind | type) != "string"
                          then error("Invalid usage limit") else . end
                        | select(.kind == "weekly_scoped" and .scope.model != null)
                        | if (.scope.model.display_name | type) != "string"
                            or (.percent | type) != "number"
                            or (.resets_at != null and (.resets_at | type) != "string")
                          then error("Invalid model usage")
                          else { name:      .scope.model.display_name,
                                percent:   .percent,
                                resets_at: .resets_at } end ] }' "$tmp" > "${USAGE_CACHE}.tmp" 2> /dev/null; then
      mv -f "${USAGE_CACHE}.tmp" "$USAGE_CACHE"
    fi
    rm -f "${USAGE_CACHE}.tmp"
  fi
  rm -f "$tmp"
  exit 0
}

SELF="${BASH_SOURCE[0]}"
[[ "$1" == "--refresh" ]] && refresh_usage

input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0 | round')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

now=$(date +%s)

stamp_age=$((now - $(stat -c %Y "$USAGE_STAMP" 2> /dev/null || echo 0)))
if ((stamp_age >= USAGE_TTL)); then
  # 描画のキャンセルに巻き込まれないよう setsid で切り離す。
  # 親の出力パイプを保持して描画を待たせないよう、標準入出力も /dev/null に向ける。
  setsid "$SELF" --refresh < /dev/null > /dev/null 2>&1 &
fi

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

# API の percent は使用率を百分率（0–100）で返す。
fable_line=$(jq -r '
    (.fetched_at // 0) as $f
    | (.models[]? | select(.name == "Fable"))
    | "\($f)\t\(.percent // "")\t\(.resets_at // "")"' "$USAGE_CACHE" 2> /dev/null | head -1)
if [[ -n "$fable_line" ]]; then
  IFS=$'\t' read -r fable_fetched fable_pct fable_resets <<< "$fable_line"
  if [[ -n "$fable_pct" ]]; then
    fable_remaining=$(awk -v v="$fable_pct" 'BEGIN { printf "%.0f", 100 - v }')
    stale=""
    ((now - fable_fetched > USAGE_STALE)) && stale="~"
    metrics="${metrics} / Fable ${stale}${fable_remaining}%"
    # 入力 JSON と API の時刻差を許容し、同じ週次リセットを重複表示しない。
    if [[ -n "$fable_resets" ]]; then
      fable_resets_epoch=$(date -d "$fable_resets" +%s 2> /dev/null)
      if [[ -n "$fable_resets_epoch" ]] &&
        { [[ -z "$seven_day_resets" ]] ||
          ((fable_resets_epoch > seven_day_resets + 60 || fable_resets_epoch < seven_day_resets - 60)); }; then
        metrics="${metrics} ($(date -d "@${fable_resets_epoch}" "+%-m/%-d %H:%M"))"
      fi
    fi
  fi
fi

echo "${model_part} | Remaining: ${metrics}"
