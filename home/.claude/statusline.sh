#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# モデル別週次枠(Fable など)のキャッシュ
#   statusline の JSON には five_hour / seven_day / spend_limit しか来ないため、
#   Claude Code 本体と同じ /api/oauth/usage を別途叩いてキャッシュする。
#   statusline は「キャッシュを読むだけ」。取得は常にデタッチした別プロセス。
# ---------------------------------------------------------------------------
CACHE_DIR="${HOME}/.claude/cache"
USAGE_CACHE="${CACHE_DIR}/model-usage.json"
USAGE_STAMP="${CACHE_DIR}/model-usage.stamp"
USAGE_LOCK="${CACHE_DIR}/model-usage.lock"
USAGE_TTL=300    # 再取得間隔(秒)。Claude Code 本体の内部 TTL と同じ
USAGE_STALE=3600 # これより古い値は ~ を付けて「古い」と明示

refresh_usage() {
  mkdir -p "$CACHE_DIR" || exit 0

  # 同一マシンの全セッションで 1 本だけ走らせる
  exec 9> "$USAGE_LOCK" || exit 0
  flock -n 9 || exit 0

  # 成功・失敗を問わず「試行時刻」で間隔を守る(429 のときも叩き続けない)
  local now stamp_age
  now=$(date +%s)
  stamp_age=$((now - $(stat -c %Y "$USAGE_STAMP" 2> /dev/null || echo 0)))
  ((stamp_age < USAGE_TTL)) && exit 0
  touch "$USAGE_STAMP"

  local tok
  tok=$(jq -r '.claudeAiOauth.accessToken // empty' "${HOME}/.claude/.credentials.json" 2> /dev/null)
  [[ -n "$tok" ]] || exit 0 # API キー運用などトークンが無い環境では何もしない

  local version user_agent
  version=$(claude --version 2> /dev/null)
  version=${version%% *}
  [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] || version=unknown
  user_agent="claude-cli/${version} (external, cli)"

  local tmp code
  tmp=$(mktemp "${CACHE_DIR}/model-usage.raw.XXXXXX") || exit 0

  # 通信失敗や 401 / 429 等は旧キャッシュを温存して次回に回す
  if code=$(curl -s -m 10 -o "$tmp" -w '%{http_code}' \
    -H "Authorization: Bearer ${tok}" \
    -H "anthropic-beta: oauth-2025-04-20" \
    -H "User-Agent: ${user_agent}" \
    -H "Content-Type: application/json" \
    https://api.anthropic.com/api/oauth/usage 2> /dev/null) &&
    [[ "$code" == "200" ]]; then
    # 空本文・エラー本文・不正な形式を拒否する。正常な limits: [] は許容する
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

# ---------------------------------------------------------------------------
# ここから通常の statusline 描画
# ---------------------------------------------------------------------------
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
effort=$(echo "$input" | jq -r '.effort.level // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // 0 | round')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

now=$(date +%s)

# キャッシュが古ければ「裏で」取り直す。setsid で親のプロセスグループから切り離し、
# stdio を閉じることで (1) statusline のキャンセルに巻き込まれない
# (2) 親の stdout パイプを掴んだままにして描画を止めない、の両方を担保する
stamp_age=$((now - $(stat -c %Y "$USAGE_STAMP" 2> /dev/null || echo 0)))
if ((stamp_age >= USAGE_TTL)); then
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

# Fable の週次枠(キャッシュ由来)。percent は既に 0-100 なので 100 倍しない
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
    # 週次枠と同じリセット時刻なら重複表示しない
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
