#!/usr/bin/env bash
# register-orchestrator.sh — add a project to the orchestrator's config and
# reload the launchd service. Atomic, with rollback on failure.
#
# Usage:
#   register-orchestrator.sh \
#     --project-id=<uuid> --team-id=<uuid> --keyword=<str> --path=<abs-path>

set -euo pipefail

# ---------- parse args ----------
PROJECT_ID=""
TEAM_ID=""
KEYWORD=""
LOCAL_PATH=""

for arg in "$@"; do
  case "$arg" in
    --project-id=*) PROJECT_ID="${arg#*=}" ;;
    --team-id=*) TEAM_ID="${arg#*=}" ;;
    --keyword=*) KEYWORD="${arg#*=}" ;;
    --path=*) LOCAL_PATH="${arg#*=}" ;;
    *) echo "unknown arg: $arg" >&2; exit 64 ;;
  esac
done

for name in PROJECT_ID TEAM_ID KEYWORD LOCAL_PATH; do
  if [ -z "${!name}" ]; then
    echo "error: --$(echo "$name" | tr '[:upper:]' '[:lower:]' | tr '_' '-') is required" >&2
    exit 64
  fi
done

# ---------- paths ----------
CONFIG="$HOME/.orchestrator/config.json"
PLIST="$HOME/Library/LaunchAgents/com.rafiqlabs.orchestrator.plist"
LABEL="com.rafiqlabs.orchestrator"
HEALTH_URL="http://localhost:3000/health"

# ---------- prereqs ----------
if [ ! -f "$CONFIG" ]; then
  echo "error: orchestrator config not found at $CONFIG" >&2
  echo "       bootstrap registration requires an existing orchestrator install" >&2
  exit 72
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "error: jq is required (brew install jq)" >&2
  exit 72
fi

# Validate existing config parses.
if ! jq -e . "$CONFIG" >/dev/null 2>&1; then
  echo "error: current $CONFIG is not valid JSON — refusing to modify" >&2
  exit 73
fi

# Validate absolute path resolves.
if [ ! -d "$LOCAL_PATH" ]; then
  echo "error: local path $LOCAL_PATH does not exist" >&2
  exit 64
fi

# ---------- idempotency check ----------
if jq -e --arg pid "$PROJECT_ID" '.projects | has($pid)' "$CONFIG" >/dev/null; then
  existing="$(jq -r --arg pid "$PROJECT_ID" '.projects[$pid]' "$CONFIG")"
  if [ "$existing" = "$LOCAL_PATH" ]; then
    echo "✓ project $PROJECT_ID already registered at $LOCAL_PATH — nothing to do"
    exit 0
  else
    echo "warning: project $PROJECT_ID already registered at different path:"
    echo "  current: $existing"
    echo "  new:     $LOCAL_PATH"
    echo "  updating..."
  fi
fi

# ---------- backup ----------
STAMP="$(date -u +%Y%m%d-%H%M%S)"
BACKUP="$CONFIG.backup.$STAMP"
cp "$CONFIG" "$BACKUP"
echo "backed up config to $BACKUP"

# ---------- build new config ----------
TMP="$(mktemp)"
jq \
  --arg pid "$PROJECT_ID" \
  --arg tid "$TEAM_ID" \
  --arg kw "$KEYWORD" \
  --arg path "$LOCAL_PATH" \
  '
    .projects[$pid] = $path
    | .projectKeywords[$kw] = { projectId: $pid, teamId: $tid }
  ' "$CONFIG" > "$TMP"

# Sanity: the new file is valid JSON.
if ! jq -e . "$TMP" >/dev/null 2>&1; then
  echo "error: generated config is invalid — aborting, no changes made" >&2
  rm -f "$TMP"
  exit 74
fi

# Atomic swap.
mv "$TMP" "$CONFIG"
echo "updated $CONFIG"

# ---------- reload launchd ----------
restore_backup() {
  echo "restoring config from $BACKUP..." >&2
  cp "$BACKUP" "$CONFIG"
  launchctl load "$PLIST" >/dev/null 2>&1 || true
}

if [ ! -f "$PLIST" ]; then
  echo "warning: launchd plist not found at $PLIST — config updated but service not reloaded"
  echo "         install with: ./scripts/install-service.sh from the orchestrator repo"
  exit 0
fi

echo "reloading $LABEL..."
launchctl unload "$PLIST" 2>/dev/null || true
sleep 1
if ! launchctl load "$PLIST"; then
  echo "error: launchctl load failed" >&2
  restore_backup
  exit 75
fi

# ---------- health check ----------
echo "verifying health endpoint..."
HEALTH_OK=0
for i in 1 2 3 4 5; do
  sleep 2
  if curl -fsS --max-time 3 "$HEALTH_URL" >/dev/null 2>&1; then
    HEALTH_OK=1
    break
  fi
done

if [ "$HEALTH_OK" -eq 0 ]; then
  echo "error: orchestrator not responding at $HEALTH_URL after reload" >&2
  echo "       check logs at ~/.orchestrator/logs/" >&2
  restore_backup
  exit 76
fi

# ---------- confirm ----------
echo
echo "✓ orchestrator registered"
echo "  project id:   $PROJECT_ID"
echo "  team id:      $TEAM_ID"
echo "  keyword:      $KEYWORD"
echo "  local path:   $LOCAL_PATH"
echo "  health:       OK (at $HEALTH_URL)"
echo "  backup kept:  $BACKUP"
