#!/usr/bin/env bash
#
# sync-skills.sh — propagate skills from the canonical zstack-skills repo.
#
# Single source of truth:  ~/Documents/zstack-skills/skills/
# Targets:
#   1) ~/.claude/skills              (live invocation set)  — UPDATE existing only
#   2) ~/.claude/repo-skill-template (seed for new repos)   — full mirror
#
# Why "update existing only" for the live set: ~/.claude/skills also holds
# gstack / google-agents-cli / firecrawl skills that are NOT part of the zstack
# family. We must never add/remove those, so we only refresh skills already there.
#
# All three locations are git repos — after running, review `git diff` in each
# target and commit. Nothing here commits for you.
#
# Usage:
#   ./sync-skills.sh --dry-run   # show what would change, write nothing
#   ./sync-skills.sh             # apply
#
set -euo pipefail

SRC="$HOME/Documents/zstack-skills/skills"
LIVE="$HOME/.claude/skills"
TMPL="$HOME/.claude/repo-skill-template"

[ -d "$SRC" ] || { echo "FATAL: source not found: $SRC" >&2; exit 1; }

# -c (checksum): transfer only on real content diff, so content-identical copies
# with differing mtimes are left untouched (no needless churn; git tracks content).
RSYNC_OPTS=(-a -c --delete)
if [ "${1:-}" = "--dry-run" ]; then
  RSYNC_OPTS+=(-n -i)
  echo "=== DRY RUN (no files written) ==="
fi

live_updated=0 tmpl_synced=0
for d in "$SRC"/*/; do
  name=$(basename "$d")

  # Seed for new repos: always mirror.
  rsync "${RSYNC_OPTS[@]}" "$d" "$TMPL/$name/"
  tmpl_synced=$((tmpl_synced + 1))

  # Live set: refresh only if the skill is already present.
  if [ -d "$LIVE/$name" ]; then
    rsync "${RSYNC_OPTS[@]}" "$d" "$LIVE/$name/"
    live_updated=$((live_updated + 1))
  fi
done

echo
echo "template: mirrored $tmpl_synced skills -> $TMPL"
echo "live:     refreshed $live_updated existing skills -> $LIVE"
echo
echo "Review and commit:"
echo "  git -C \"$LIVE\" diff --stat   && git -C \"$LIVE\" add -A && git -C \"$LIVE\" commit -m 'chore: sync skills from zstack canonical'"
echo "  git -C \"$TMPL\" diff --stat   && git -C \"$TMPL\" add -A && git -C \"$TMPL\" commit -m 'chore: sync skills from zstack canonical'"
