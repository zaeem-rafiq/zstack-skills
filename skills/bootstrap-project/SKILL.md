---
name: bootstrap-project
description: >
  Scaffold a new project from an archetype template — copies archetype files,
  merges the Project Manifest into a fresh CLAUDE.md, installs the portable skill
  library, and registers the project with the orchestrator so it picks up Linear
  issues automatically. Use this skill when the user says "bootstrap a new project",
  "start a new repo", "set up a new [Next.js / iOS / Node / content] project",
  or when `/bootstrap` is invoked directly. Replaces the manual "copy skills,
  edit CLAUDE.md, add to orchestrator" dance with a single guided flow.
  Available archetypes: `nextjs-web`, `ios-swiftui`, `node-service`, `content-site`.
---

# Bootstrap Project

You scaffold a new project from a chosen archetype. The goal: a user starts with
an empty directory (or an existing repo) and ends with a fully-configured project
that every other skill can work with out of the box.

## Invocation

The user typically invokes this via:

```
/bootstrap --archetype=<name> --path=<path>
```

If either arg is missing, ask interactively. Valid archetypes: `nextjs-web`,
`ios-swiftui`, `node-service`, `content-site` (validate against
`~/.claude/archetypes/` directory listing before proceeding).

## Step-by-step flow

### 1. Validate

- Confirm `~/.claude/archetypes/<archetype>/` exists. If not, list available
  archetypes and stop.
- Confirm `<path>` exists OR create it (ask the user first if creating).
- If `<path>` already contains a `CLAUDE.md` or `.claude/skills/`, **STOP** and
  ask the user whether to abort or overwrite. Do not silently clobber existing work.

### 2. Collect manifest values

Ask the user for these values one at a time (OK to combine into a single
`AskUserQuestion` call with multiple questions). Reasonable defaults shown in brackets:

- **Project Name** (e.g., "Acme") — human-readable
- **Domain** (e.g., "acme.com") — production URL, or "none" if no domain yet
- **Repo URL** (e.g., "github.com/your-org/acme") — or "none" if not yet pushed
- **Linear Project ID** (UUID) — get from Linear → Settings → Projects → API
- **Linear Team ID** (UUID) — usually the default team; find yours in Linear → Settings → API
- **Linear Keyword** (lowercase, e.g., "acme") — used by orchestrator for routing
- **AI Features** (`true`/`false`) — are there LLM-powered features? If yes, quality gate
  will chain in `eval-framework` automatically
- **Phase** (default: "pre-launch") — options: pre-launch, launched, maintenance, sunset

For archetype-specific extras (Firebase project ID for iOS, Bundle ID for iOS,
Supabase URL for Next.js, etc.), ask only what the archetype's `manifest.template.md`
declares as placeholders.

### 3. Run the scaffold script

Invoke the deterministic bootstrap script with the collected values:

```bash
~/.claude/repo-skill-template/bootstrap-project/scripts/bootstrap.sh \
  --archetype=<name> \
  --path=<path> \
  --name=<project-name> \
  --domain=<domain> \
  --repo=<repo> \
  --linear-project-id=<uuid> \
  --linear-team-id=<uuid> \
  --linear-keyword=<keyword> \
  --ai-features=<bool> \
  --phase=<phase>
```

The script does the mechanical work: copies archetype files, merges templates,
substitutes placeholders, copies skills, creates knowledge/ and tasks/ directories.

**Read its output**. It reports what it did — if any step failed, stop and
investigate before continuing. Do not mark the task complete on partial success.

### 4. Register with the orchestrator

Invoke the orchestrator registration script:

```bash
~/.claude/repo-skill-template/bootstrap-project/scripts/register-orchestrator.sh \
  --project-id=<linear-project-id> \
  --team-id=<linear-team-id> \
  --keyword=<linear-keyword> \
  --path=<absolute-local-path>
```

This script:
- Reads `~/.orchestrator/config.json`
- Appends entries to `projects` and `projectKeywords`
- Writes atomically (temp + rename)
- Reloads the launchd service
- Verifies the service is healthy afterward
- On failure: restores from backup and reports the error

If orchestrator registration fails, the scaffold is still valid — surface the
error and note that the user can run the register script again later.

### 5. Install git safety hooks

If `<path>` is a git repo (check for `.git/`), invoke the `git-guardrails` skill:
tell the user "I'm running `/git-guardrails` to set up pre-commit and pre-push
hooks". If `<path>` is NOT yet a git repo, offer to `git init` first, then run
the guardrails skill.

### 6. First commit

If the user has `git init`-ed, stage everything and commit:

```bash
cd <path>
git add -A
git commit -m "chore: bootstrap project from <archetype> archetype"
```

Do NOT push — let the user decide when to push and to which remote.

### 7. Report summary

Tell the user, in a short report:

- Archetype used
- Files created (counts, not full list)
- Linear project + keyword registered with orchestrator
- Next steps:
  1. `cd <path>` and look at the new CLAUDE.md — confirm the Project Manifest
     values are right
  2. Create first Linear issue with status "Agent Ready" to test the orchestrator
     picks it up
  3. Fill in `knowledge/UBIQUITOUS-LANGUAGE.md` with the top 5–10 domain terms
     as they emerge — don't try to complete it up front

## What this skill does NOT do

- Does not choose the archetype for the user — they pick it
- Does not install language/runtime dependencies (npm install, bundle install,
  etc.) — that's the user's first post-bootstrap step
- Does not create a GitHub repository — user does that separately if needed
- Does not configure deploy targets (Vercel project, App Store Connect, etc.)
- Does not push to a remote
- Does not populate knowledge files — those fill in as the project evolves

## Failure modes to watch for

- **Placeholder remaining in CLAUDE.md**: run `grep -n '\[PROJECT_NAME\]\|\[DOMAIN\]\|\[LINEAR_' <path>/CLAUDE.md`
  after step 3. If any match, a substitution was missed — fix it before proceeding.
- **Orchestrator config corruption**: if the register script fails mid-write,
  it should auto-restore. Verify the file parses: `jq . ~/.orchestrator/config.json`.
- **Skills directory already exists in target**: the bootstrap script will
  refuse to overwrite. Resolve manually — don't force the copy.
- **Launchd reload fails**: the orchestrator process may be stuck. Check logs
  at `~/.orchestrator/logs/`. User may need to manually
  `launchctl unload && launchctl load`.

## Exit criteria

Mark the bootstrap complete ONLY when ALL of these are true:

1. `<path>/CLAUDE.md` exists, has a populated Project Manifest section, and
   contains no `[PLACEHOLDER]` tokens.
2. `<path>/.claude/skills/` contains the full portable skill library.
3. `<path>/knowledge/` and `<path>/docs/` and `<path>/tasks/` directories exist.
4. `~/.orchestrator/config.json` contains the new `projects` and
   `projectKeywords` entries and parses as valid JSON.
5. `launchctl list com.your-org.orchestrator` shows the service running.
6. Git guardrails hooks are installed (if git-initialized).
7. First commit exists (if git-initialized).

If any of these fail, report the specific failure to the user and leave the
scaffold in whatever state it's in — don't try to "clean up" by deleting the
partial scaffold.
