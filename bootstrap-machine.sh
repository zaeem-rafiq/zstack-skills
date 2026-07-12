#!/usr/bin/env bash
# Bootstrap a machine with the full skills stack. Idempotent — re-run anytime.
#
#   1. Third-party skill repos -> ~/.agents/skills + all detected agents (npx skills)
#   2. compound-engineering plugin (claude plugin CLI)
#   3. zstack skills/commands/agents -> ~/.claude (sync-skills.sh)
#   4. Cross-agent symlinks for the zstack skills listed in CROSS_AGENT_SKILLS
#
# Prereqs: node/npx, claude CLI, git. New third-party repo or cross-agent
# skill? Add it to the arrays below and re-run.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

THIRD_PARTY_REPOS=(
  teng-lin/notebooklm-py
  Graphify-Labs/graphify
  kepano/obsidian-skills
  pbakaus/impeccable
  DietrichGebert/ponytail
  bradautomates/claude-video
)

# zstack skills also exposed to Codex/Cursor/OpenCode (Claude Code gets the
# whole library via sync-skills.sh regardless).
CROSS_AGENT_SKILLS=(
  ux-audit
  growth-audit
  app-readiness-audit
  product-audit
)

AGENT_SKILL_DIRS=(~/.codex/skills ~/.cursor/skills ~/.config/opencode/skills)

echo "== 1/4 third-party skills (npx skills add) =="
for repo in "${THIRD_PARTY_REPOS[@]}"; do
  npx -y skills add "$repo" -g --all
done

echo "== 2/4 compound-engineering plugin =="
claude plugin marketplace add EveryInc/every-marketplace || true
claude plugin install compound-engineering@compound-engineering-plugin || true

echo "== 3/4 zstack skills -> ~/.claude =="
"$REPO_ROOT/sync-skills.sh"

echo "== 4/4 cross-agent symlinks =="
mkdir -p ~/.agents/skills
for name in "${CROSS_AGENT_SKILLS[@]}"; do
  ln -sfn "$REPO_ROOT/skills/$name" ~/.agents/skills/"$name"
  for agent_dir in "${AGENT_SKILL_DIRS[@]}"; do
    [ -d "$agent_dir" ] && ln -sfn ~/.agents/skills/"$name" "$agent_dir/$name"
  done
done

echo "Done. Restart agent sessions to pick up new skills."
