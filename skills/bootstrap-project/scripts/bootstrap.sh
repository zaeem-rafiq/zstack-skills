#!/usr/bin/env bash
# bootstrap.sh — scaffold a new project from an archetype.
#
# Invoked by the bootstrap-project skill after it has collected manifest values
# from the user. This script is purely deterministic: copy files, substitute
# placeholders, create directories. No interaction.
#
# Usage:
#   bootstrap.sh --archetype=<name> --path=<path> --name=<str> --domain=<str> \
#                --repo=<str> --linear-project-id=<uuid> --linear-team-id=<uuid> \
#                --linear-keyword=<str> --ai-features=<bool> --phase=<str> \
#                [--firebase-project-id=<str>] [--bundle-id=<str>] \
#                [--content-type=<str>] [--service-type=<str>] [--config-path=<str>]

set -euo pipefail

# ---------- parse args ----------
ARCHETYPE=""
PROJECT_PATH=""
PROJECT_NAME=""
DOMAIN=""
REPO=""
LINEAR_PROJECT_ID=""
LINEAR_TEAM_ID=""
LINEAR_KEYWORD=""
AI_FEATURES="false"
PHASE="pre-launch"
FIREBASE_PROJECT_ID=""
BUNDLE_ID=""
CONTENT_TYPE=""
SERVICE_TYPE=""
CONFIG_PATH=""

for arg in "$@"; do
  case "$arg" in
    --archetype=*) ARCHETYPE="${arg#*=}" ;;
    --path=*) PROJECT_PATH="${arg#*=}" ;;
    --name=*) PROJECT_NAME="${arg#*=}" ;;
    --domain=*) DOMAIN="${arg#*=}" ;;
    --repo=*) REPO="${arg#*=}" ;;
    --linear-project-id=*) LINEAR_PROJECT_ID="${arg#*=}" ;;
    --linear-team-id=*) LINEAR_TEAM_ID="${arg#*=}" ;;
    --linear-keyword=*) LINEAR_KEYWORD="${arg#*=}" ;;
    --ai-features=*) AI_FEATURES="${arg#*=}" ;;
    --phase=*) PHASE="${arg#*=}" ;;
    --firebase-project-id=*) FIREBASE_PROJECT_ID="${arg#*=}" ;;
    --bundle-id=*) BUNDLE_ID="${arg#*=}" ;;
    --content-type=*) CONTENT_TYPE="${arg#*=}" ;;
    --service-type=*) SERVICE_TYPE="${arg#*=}" ;;
    --config-path=*) CONFIG_PATH="${arg#*=}" ;;
    *) echo "unknown arg: $arg" >&2; exit 64 ;;
  esac
done

# ---------- validate ----------
require() {
  local name="$1" value="$2"
  if [ -z "$value" ]; then
    echo "error: --$name is required" >&2
    exit 64
  fi
}

require "archetype" "$ARCHETYPE"
require "path" "$PROJECT_PATH"
require "name" "$PROJECT_NAME"
require "linear-project-id" "$LINEAR_PROJECT_ID"
require "linear-team-id" "$LINEAR_TEAM_ID"
require "linear-keyword" "$LINEAR_KEYWORD"

ARCHETYPES_DIR="$HOME/.claude/archetypes"
SKILLS_SRC="$HOME/.claude/repo-skill-template"
SHARED_CLAUDE_MD="$HOME/.claude/CLAUDE.md.template"

ARCHETYPE_DIR="$ARCHETYPES_DIR/$ARCHETYPE"
if [ ! -d "$ARCHETYPE_DIR" ]; then
  echo "error: archetype '$ARCHETYPE' not found at $ARCHETYPE_DIR" >&2
  echo "available:" >&2
  ls -1 "$ARCHETYPES_DIR" >&2 || true
  exit 64
fi

if [ ! -d "$PROJECT_PATH" ]; then
  echo "creating $PROJECT_PATH"
  mkdir -p "$PROJECT_PATH"
fi

if [ -f "$PROJECT_PATH/CLAUDE.md" ] || [ -d "$PROJECT_PATH/.claude/skills" ]; then
  echo "error: $PROJECT_PATH already has CLAUDE.md or .claude/skills — refuse to clobber" >&2
  exit 65
fi

if [ ! -f "$SHARED_CLAUDE_MD" ]; then
  echo "error: shared template not found at $SHARED_CLAUDE_MD" >&2
  exit 72
fi

# ---------- helpers ----------
abs_path() {
  local p="$1"
  ( cd "$p" && pwd )
}

ABS_PROJECT_PATH="$(abs_path "$PROJECT_PATH")"
TODAY="$(date -u +%Y-%m-%d)"

# Safe substitution for sed: escape `/` `&` `|` in replacement strings.
sed_escape() {
  printf '%s' "$1" | sed -e 's/[\/&|]/\\&/g'
}

substitute_placeholders() {
  local file="$1"
  local tmp
  tmp="$(mktemp)"
  sed \
    -e "s|\[PROJECT_NAME\]|$(sed_escape "$PROJECT_NAME")|g" \
    -e "s|\[DOMAIN\]|$(sed_escape "$DOMAIN")|g" \
    -e "s|\[REPO_URL\]|$(sed_escape "$REPO")|g" \
    -e "s|\[LINEAR_PROJECT_ID\]|$(sed_escape "$LINEAR_PROJECT_ID")|g" \
    -e "s|\[LINEAR_TEAM_ID\]|$(sed_escape "$LINEAR_TEAM_ID")|g" \
    -e "s|\[LINEAR_KEYWORD\]|$(sed_escape "$LINEAR_KEYWORD")|g" \
    -e "s|\[LOCAL_PATH\]|$(sed_escape "$ABS_PROJECT_PATH")|g" \
    -e "s|\[AI_FEATURES\]|$(sed_escape "$AI_FEATURES")|g" \
    -e "s|\[PHASE\]|$(sed_escape "$PHASE")|g" \
    -e "s|\[DATE\]|$(sed_escape "$TODAY")|g" \
    -e "s|\[FIREBASE_PROJECT_ID\]|$(sed_escape "$FIREBASE_PROJECT_ID")|g" \
    -e "s|\[BUNDLE_ID\]|$(sed_escape "$BUNDLE_ID")|g" \
    -e "s|\[CONTENT_TYPE\]|$(sed_escape "$CONTENT_TYPE")|g" \
    -e "s|\[SERVICE_TYPE\]|$(sed_escape "$SERVICE_TYPE")|g" \
    -e "s|\[CONFIG_PATH\]|$(sed_escape "$CONFIG_PATH")|g" \
    "$file" > "$tmp"
  mv "$tmp" "$file"
}

# Replace a single-line marker with a file's contents. Uses awk (more reliable
# than sed for multi-line replacement).
replace_marker_with_file() {
  local marker="$1" content_file="$2" target_file="$3"
  local tmp
  tmp="$(mktemp)"
  awk -v marker="$marker" -v file="$content_file" '
    $0 ~ marker {
      while ((getline line < file) > 0) print line
      close(file)
      next
    }
    { print }
  ' "$target_file" > "$tmp"
  mv "$tmp" "$target_file"
}

# ---------- build CLAUDE.md ----------
echo "building CLAUDE.md from archetype '$ARCHETYPE'..."

TARGET_CLAUDE="$PROJECT_PATH/CLAUDE.md"
cp "$ARCHETYPE_DIR/claude.md.template" "$TARGET_CLAUDE"

# Stage manifest, boundaries, shared into temp files so we can substitute first.
MANIFEST_TMP="$(mktemp)"
cp "$ARCHETYPE_DIR/manifest.template.md" "$MANIFEST_TMP"
substitute_placeholders "$MANIFEST_TMP"

BOUNDARIES_TMP="$(mktemp)"
cp "$ARCHETYPE_DIR/boundaries.md" "$BOUNDARIES_TMP"

SHARED_TMP="$(mktemp)"
# Shared boilerplate = CLAUDE.md.template content MINUS everything up to and
# including its first `---` divider. The archetype provides its own title,
# Project Manifest, and any archetype-specific top — we append shared workflow
# rules after that.
awk '
  !past && /^---[[:space:]]*$/ { past = 1; next }
  past { print }
' "$SHARED_CLAUDE_MD" > "$SHARED_TMP"

# Replace markers in the target CLAUDE.md.
replace_marker_with_file "<!-- PROJECT_MANIFEST -->" "$MANIFEST_TMP" "$TARGET_CLAUDE"
replace_marker_with_file "<!-- SHARED_WORKFLOW_BOILERPLATE -->" "$SHARED_TMP" "$TARGET_CLAUDE"
replace_marker_with_file "<!-- BOUNDARIES -->" "$BOUNDARIES_TMP" "$TARGET_CLAUDE"

# Final pass: substitute placeholders in anything left (archetype-specific text
# in claude.md.template, e.g., the Architecture diagram that uses [PROJECT_NAME]).
substitute_placeholders "$TARGET_CLAUDE"

rm -f "$MANIFEST_TMP" "$BOUNDARIES_TMP" "$SHARED_TMP"

# Sanity check: no placeholders left.
if grep -qE '\[PROJECT_NAME\]|\[DOMAIN\]|\[LINEAR_PROJECT_ID\]|\[LINEAR_TEAM_ID\]|\[LINEAR_KEYWORD\]|\[LOCAL_PATH\]' "$TARGET_CLAUDE"; then
  echo "warning: unsubstituted placeholder(s) remain in CLAUDE.md — inspect manually:" >&2
  grep -nE '\[PROJECT_NAME\]|\[DOMAIN\]|\[LINEAR_' "$TARGET_CLAUDE" | head -20 >&2
fi

# ---------- copy knowledge + docs ----------
echo "copying knowledge/ and docs/..."
mkdir -p "$PROJECT_PATH/knowledge" "$PROJECT_PATH/docs"
cp "$ARCHETYPE_DIR/knowledge/UBIQUITOUS-LANGUAGE.md" "$PROJECT_PATH/knowledge/"
cp "$ARCHETYPE_DIR/knowledge/ADR-INDEX.md" "$PROJECT_PATH/knowledge/"
cp "$ARCHETYPE_DIR/docs/README.md" "$PROJECT_PATH/docs/"
substitute_placeholders "$PROJECT_PATH/knowledge/UBIQUITOUS-LANGUAGE.md"
substitute_placeholders "$PROJECT_PATH/knowledge/ADR-INDEX.md"
substitute_placeholders "$PROJECT_PATH/docs/README.md"

# ---------- create tasks/ ----------
echo "creating tasks/..."
mkdir -p "$PROJECT_PATH/tasks"

cat > "$PROJECT_PATH/tasks/todo.md" <<EOF
# Current Sprint — $PROJECT_NAME

## [First task]
- [ ] Fill in your first task here

### Review
- (Add a review section here when the task completes)
EOF

cat > "$PROJECT_PATH/tasks/lessons.md" <<EOF
# Lessons Learned — $PROJECT_NAME

Format: [Date] [Module] What went wrong → What to do instead

## $TODAY [bootstrap] Created from $ARCHETYPE archetype
- Bootstrap happened via \`/bootstrap\` skill.
- First task: review CLAUDE.md manifest values, especially Linear IDs, before
  pushing the first Agent Ready issue.
EOF

# ---------- copy skills ----------
echo "copying portable skill library to .claude/skills/..."
mkdir -p "$PROJECT_PATH/.claude/skills"
for skill in "$SKILLS_SRC"/*/; do
  name="$(basename "$skill")"
  if [ ! -d "$PROJECT_PATH/.claude/skills/$name" ]; then
    cp -R "$skill" "$PROJECT_PATH/.claude/skills/$name"
  fi
done

# ---------- report ----------
SKILL_COUNT=$(ls -1d "$PROJECT_PATH/.claude/skills/"*/ 2>/dev/null | wc -l | tr -d ' ')

cat <<EOF

✓ bootstrap complete for $PROJECT_NAME ($ARCHETYPE)

  Path:           $ABS_PROJECT_PATH
  CLAUDE.md:      written with populated Project Manifest
  knowledge/:     UBIQUITOUS-LANGUAGE.md + ADR-INDEX.md (starter scaffolds)
  docs/:          README.md (directory convention)
  tasks/:         todo.md + lessons.md (starter files)
  .claude/skills/ $SKILL_COUNT skills copied

  Next:
    1. Run register-orchestrator.sh to add this project to the orchestrator
    2. Run /git-guardrails to install git safety hooks
    3. Review CLAUDE.md manifest values — especially Linear IDs
EOF
