#!/usr/bin/env bash
#
# sync-skills.sh — propagate skills, agents, and commands from zstack.
#
# Single source of truth: ~/Documents/zstack-skills
#   skills/            -> ~/.claude/skills and ~/.claude/repo-skill-template/<skill>
#   agents/            -> ~/.claude/agents and ~/.claude/repo-skill-template/agents
#   .claude/commands/  -> ~/.claude/commands and ~/.claude/repo-skill-template/commands
#
# The live Claude dirs also hold non-zstack content. Sync is additive at the top
# level: zstack-owned items are added/refreshed, unrelated user/plugin items stay.
# Skill directory contents are mirrored with --delete once the zstack skill exists.
#
# All three locations are git repos — after running, review `git diff` in each
# target and commit. Nothing here commits for you.
#
# Usage:
#   ./sync-skills.sh --dry-run   # show what would change, write nothing
#   ./sync-skills.sh             # apply
#
set -euo pipefail

ROOT="$HOME/Documents/zstack-skills"
SRC_SKILLS="$ROOT/skills"
SRC_AGENTS="$ROOT/agents"
SRC_COMMANDS="$ROOT/.claude/commands"
LIVE_SKILLS="$HOME/.claude/skills"
LIVE_AGENTS="$HOME/.claude/agents"
LIVE_COMMANDS="$HOME/.claude/commands"
TMPL="$HOME/.claude/repo-skill-template"

[ -d "$SRC_SKILLS" ] || { echo "FATAL: source not found: $SRC_SKILLS" >&2; exit 1; }
[ -d "$SRC_AGENTS" ] || { echo "FATAL: source not found: $SRC_AGENTS" >&2; exit 1; }

DRY_RUN=0
RSYNC_OPTS=(-a -c --delete)
if [ "${1:-}" = "--dry-run" ]; then
  DRY_RUN=1
  RSYNC_OPTS+=(-n -i)
  echo "=== DRY RUN (no files written) ==="
elif [ "$#" -gt 0 ]; then
  echo "Usage: $0 [--dry-run]" >&2
  exit 2
fi

ensure_dir() {
  local dir="$1"
  if [ "$DRY_RUN" -eq 1 ]; then
    [ -d "$dir" ] || echo "would create: $dir"
  else
    mkdir -p "$dir"
  fi
}

sync_skill_dirs() {
  local src="$1" dest="$2" label="$3" count=0
  ensure_dir "$dest"
  for d in "$src"/*/; do
    [ -d "$d" ] || continue
    local name
    name=$(basename "$d")
    rsync "${RSYNC_OPTS[@]}" "$d" "$dest/$name/"
    count=$((count + 1))
  done
  echo "$label: synced $count skills -> $dest"
}

sync_markdown_files() {
  local src="$1" dest="$2" label="$3" count=0
  [ -d "$src" ] || { echo "$label: skipped missing source -> $src"; return; }
  ensure_dir "$dest"
  for f in "$src"/*.md; do
    [ -f "$f" ] || continue
    local name
    name=$(basename "$f")
    rsync "${RSYNC_OPTS[@]}" "$f" "$dest/$name"
    count=$((count + 1))
  done
  echo "$label: synced $count files -> $dest"
}

sync_skill_dirs "$SRC_SKILLS" "$TMPL" "template skills"
sync_skill_dirs "$SRC_SKILLS" "$LIVE_SKILLS" "live skills"
sync_markdown_files "$SRC_AGENTS" "$TMPL/agents" "template agents"
sync_markdown_files "$SRC_AGENTS" "$LIVE_AGENTS" "live agents"
sync_markdown_files "$SRC_COMMANDS" "$TMPL/commands" "template commands"
sync_markdown_files "$SRC_COMMANDS" "$LIVE_COMMANDS" "live commands"

echo
echo "Review and commit:"
echo "  git -C "$LIVE_SKILLS" diff --stat && git -C "$LIVE_SKILLS" add -A && git -C "$LIVE_SKILLS" commit -m 'chore: sync zstack skills'"
echo "  git -C "$HOME/.claude" diff --stat -- repo-skill-template agents commands && git -C "$HOME/.claude" add -A -- repo-skill-template agents commands && git -C "$HOME/.claude" commit -m 'chore: sync zstack commands and agents'"
