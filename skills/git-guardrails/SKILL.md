---
name: git-guardrails
description: >
  Set up git safety hooks to block destructive git commands in AI-assisted coding
  environments. Use this skill whenever someone says "block git push", "git safety",
  "protect my repo", "prevent force push", "git hooks for AI", or when setting up a
  new repo that will be used with AI coding assistants. Also trigger when someone
  expresses concern about AI agents making destructive git operations — this provides
  the safety net. One-time setup that protects against accidental force pushes, main
  branch commits, and other destructive operations.
---

# Git Guardrails

You set up safety hooks that prevent destructive git operations, especially important
when using AI coding assistants that might run git commands autonomously.

## Why This Matters

AI coding assistants (Claude Code, Cursor, Copilot, etc.) can execute git commands
as part of their workflow. Most of the time this is helpful — committing work, creating
branches, pushing changes. But without guardrails, an AI agent could:
- Force-push over shared branch history
- Commit directly to main/master
- Push sensitive files (API keys, .env files)
- Delete remote branches
- Create messy commit history

These hooks act as a safety net. They don't prevent the AI from using git — they
prevent the dangerous operations while allowing normal workflow.

## What Gets Protected

### Pre-commit hooks
- Block commits containing sensitive patterns (API keys, passwords, tokens)
- Block commits to main/master branch (require branch-based workflow)
- Warn on large files (>5MB) being committed

### Pre-push hooks
- Block force pushes (`--force`, `--force-with-lease` to shared branches)
- Block pushes directly to main/master
- Block deletion of remote branches

### Commit-msg hooks
- Require conventional commit format (optional, user chooses)
- Block empty commit messages

## Setup Process

### Step 1: Assess the environment

Check what's already in place:
```bash
# Check for existing hooks
ls -la .git/hooks/
# Check for husky or other hook managers
cat package.json | grep -A5 "husky"  # Node projects
cat .pre-commit-config.yaml  # Python projects
```

If the project already uses a hook manager (husky, pre-commit, lefthook), integrate
with it rather than creating standalone scripts.

### Step 2: Create the hooks

#### Pre-commit hook

```bash
#!/bin/bash
# Git Guardrails: pre-commit hook

# Block commits to main/master
BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    echo "❌ Direct commits to $BRANCH are blocked."
    echo "   Create a feature branch: git checkout -b feature/your-feature"
    exit 1
fi

# Check for sensitive patterns
SENSITIVE_PATTERNS=(
    'AKIA[0-9A-Z]{16}'           # AWS Access Key
    'sk-[a-zA-Z0-9]{20,}'        # OpenAI/Stripe-style keys
    'ghp_[a-zA-Z0-9]{36}'        # GitHub Personal Access Token
    'password\s*=\s*["\x27][^"\x27]+'  # Hardcoded passwords
    'BEGIN RSA PRIVATE KEY'       # Private keys
    'BEGIN OPENSSH PRIVATE KEY'   # SSH keys
)

for pattern in "${SENSITIVE_PATTERNS[@]}"; do
    if git diff --cached | grep -qE "$pattern"; then
        echo "❌ Potential secret detected in staged changes!"
        echo "   Pattern: $pattern"
        echo "   Remove the secret and use environment variables instead."
        exit 1
    fi
done

# Warn on large files
LARGE_FILES=$(git diff --cached --name-only | while read f; do
    if [ -f "$f" ]; then
        SIZE=$(wc -c < "$f")
        if [ "$SIZE" -gt 5242880 ]; then  # 5MB
            echo "$f ($(numfmt --to=iec-i --suffix=B "$SIZE" 2>/dev/null || echo "${SIZE} bytes"))"
        fi
    fi
done)

if [ -n "$LARGE_FILES" ]; then
    echo "⚠️  Large files detected:"
    echo "$LARGE_FILES"
    echo "   Consider using Git LFS or adding to .gitignore"
    # Warning only, doesn't block
fi

exit 0
```

#### Pre-push hook

```bash
#!/bin/bash
# Git Guardrails: pre-push hook

REMOTE="$1"
BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Block force pushes
if [[ "$*" == *"--force"* ]] || [[ "$*" == *"-f"* ]]; then
    echo "❌ Force push is blocked by git guardrails."
    echo "   If you really need this, temporarily disable: git push --no-verify"
    exit 1
fi

# Block pushes to main/master
if [[ "$BRANCH" == "main" || "$BRANCH" == "master" ]]; then
    echo "❌ Direct pushes to $BRANCH are blocked."
    echo "   Use a pull request workflow instead."
    exit 1
fi

# Block remote branch deletion
while read local_ref local_sha remote_ref remote_sha; do
    if [[ "$local_sha" == "0000000000000000000000000000000000000000" ]]; then
        echo "❌ Remote branch deletion is blocked by git guardrails."
        exit 1
    fi
done

exit 0
```

### Step 3: Install the hooks

```bash
# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/pre-push

# Verify installation
echo "✅ Git guardrails installed:"
ls -la .git/hooks/pre-commit .git/hooks/pre-push
```

### Step 4: Make hooks portable (optional)

For team projects, store hooks in the repo and set up automatic installation:

```bash
# Store hooks in repo
mkdir -p .githooks
cp .git/hooks/pre-commit .githooks/
cp .git/hooks/pre-push .githooks/

# Configure git to use them
git config core.hooksPath .githooks

# Add setup instruction to README
echo "Run 'git config core.hooksPath .githooks' to enable git guardrails"
```

## Environment Detection

### Claude.ai
- Generate the hook scripts as files in `/mnt/user-data/outputs/githooks/`
- Provide installation instructions the user can follow locally
- Present the files

### Claude Code
- Install hooks directly into `.git/hooks/`
- Verify they work by testing each check
- Optionally commit hooks to `.githooks/` for portability

## Configuration

The user might want to customize:
- Which branches are protected (default: main, master)
- Whether to block or warn on large files
- Which sensitive patterns to check for
- Whether to enforce conventional commits
- Which operations to block vs. warn about

Ask the user what level of protection they want before installing.

## Testing the Hooks

After installation, verify each hook works:

```bash
# Test pre-commit: try committing on main
git checkout main
echo "test" > test.txt && git add test.txt
git commit -m "test"  # Should be blocked

# Test sensitive pattern detection
echo 'API_KEY = "sk-test1234567890abcdef"' > test.txt && git add test.txt
git commit -m "test"  # Should be blocked

# Clean up
git checkout - && git reset HEAD test.txt && rm test.txt
```

## Anti-patterns

- Hooks that are so strict they block normal workflow
- Not providing an escape hatch (--no-verify exists for emergencies)
- Installing hooks without explaining what they do
- Blocking operations silently (always print a clear error message)
- Not making hooks portable for team projects
