#!/bin/sh

set -eu

error() {
  printf 'toggle-lazygit: %s\n' "$*" >&2
}

die() {
  error "$@"
  exit 1
}

[ -n "${HERDR_BIN_PATH:-}" ] || die 'HERDR_BIN_PATH is required'
[ -n "${HERDR_SOCKET_PATH:-}" ] || die 'HERDR_SOCKET_PATH is required'
[ -n "${HERDR_ACTIVE_WORKSPACE_ID:-}" ] || die 'HERDR_ACTIVE_WORKSPACE_ID is required'
[ -n "${HERDR_ACTIVE_TAB_ID:-}" ] || die 'HERDR_ACTIVE_TAB_ID is required'
[ -n "${HERDR_ACTIVE_PANE_ID:-}" ] || die 'HERDR_ACTIVE_PANE_ID is required'
[ "${HERDR_ACTIVE_PANE_CWD+x}" = x ] || die 'HERDR_ACTIVE_PANE_CWD is required'
[ -x "$HERDR_BIN_PATH" ] || die "HERDR_BIN_PATH is not executable: $HERDR_BIN_PATH"

for dependency in jq flock lazygit cksum; do
  command -v "$dependency" >/dev/null 2>&1 ||
    die "required command not found: $dependency"
done

export HERDR_SOCKET_PATH

herdr_cli() {
  "$HERDR_BIN_PATH" "$@"
}

lock_root=${XDG_RUNTIME_DIR:-${TMPDIR:-/tmp}}
[ -d "$lock_root" ] || die "lock directory does not exist: $lock_root"
[ -w "$lock_root" ] || die "lock directory is not writable: $lock_root"

lock_key=$(printf '%s\n%s\n' "$HERDR_SOCKET_PATH" "$HERDR_ACTIVE_TAB_ID" | cksum)
lock_key=${lock_key%% *}
lock_file="$lock_root/herdr-lazygit-toggle-$lock_key.lock"

umask 077
if ! : >"$lock_file"; then
  die "failed to create lock file: $lock_file"
fi
exec 9>"$lock_file"
if ! flock -x 9; then
  die "failed to lock: $lock_file"
fi

load_managed_panes() {
  if ! panes_json=$(herdr_cli pane list --workspace "$HERDR_ACTIVE_WORKSPACE_ID"); then
    die 'failed to list panes'
  fi

  if ! printf '%s\n' "$panes_json" |
    jq -e '.result.panes | type == "array"' >/dev/null; then
    die 'invalid pane list response'
  fi

  if ! managed_pane_ids=$(printf '%s\n' "$panes_json" |
    jq -r --arg tab_id "$HERDR_ACTIVE_TAB_ID" '
      .result.panes[]
      | select(
          .tab_id == $tab_id
          and .tokens.lazygit_toggle? == "1"
        )
      | .pane_id
      | select(type == "string" and length > 0)
    '); then
    die 'failed to parse pane list response'
  fi
}

close_managed_panes() {
  printf '%s\n' "$managed_pane_ids" |
    (
      close_status=0
      while IFS= read -r pane_id; do
        [ -n "$pane_id" ] || continue
        if ! herdr_cli pane close "$pane_id"; then
          close_status=1
        fi
      done
      exit "$close_status"
    )
}

managed_pane_seen=0
close_attempt=1
while [ "$close_attempt" -le 3 ]; do
  load_managed_panes
  [ -n "$managed_pane_ids" ] || break

  managed_pane_seen=1
  close_managed_panes || :
  close_attempt=$((close_attempt + 1))
done

if [ "$managed_pane_seen" -eq 1 ]; then
  load_managed_panes
  [ -z "$managed_pane_ids" ] ||
    die 'failed to close managed lazygit pane'
  exit 0
fi

if [ -n "$HERDR_ACTIVE_PANE_CWD" ]; then
  if ! split_json=$(herdr_cli pane split "$HERDR_ACTIVE_PANE_ID" \
    --direction right --focus --cwd "$HERDR_ACTIVE_PANE_CWD"); then
    die 'failed to create lazygit pane'
  fi
else
  if ! split_json=$(herdr_cli pane split "$HERDR_ACTIVE_PANE_ID" \
    --direction right --focus); then
    die 'failed to create lazygit pane'
  fi
fi

if ! created_pane_id=$(printf '%s\n' "$split_json" |
  jq -er '.result.pane.pane_id | select(type == "string" and length > 0)'); then
  die 'invalid pane split response'
fi

rollback_created_pane() {
  [ -n "${created_pane_id:-}" ] || return 0
  herdr_cli pane close "$created_pane_id" >/dev/null 2>&1 || :
}

trap rollback_created_pane 0
trap 'exit 1' HUP INT TERM

if ! printf '%s\n' "$split_json" |
  jq -e \
    --arg workspace_id "$HERDR_ACTIVE_WORKSPACE_ID" \
    --arg tab_id "$HERDR_ACTIVE_TAB_ID" '
      .result.pane.workspace_id == $workspace_id
      and .result.pane.tab_id == $tab_id
    ' >/dev/null; then
  die 'pane was created outside the active tab'
fi

if ! herdr_cli pane report-metadata "$created_pane_id" \
  --source dotfiles-lazygit-toggle \
  --token lazygit_toggle=1; then
  die 'failed to mark lazygit pane'
fi

if ! herdr_cli pane run "$created_pane_id" 'exec lazygit'; then
  die 'failed to start lazygit'
fi

created_pane_id=
trap - 0 HUP INT TERM
