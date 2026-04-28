---
name: request-refactor-plan
description: >
  Create a detailed refactor plan with tiny, safe commits through an interview-driven
  process. Use this skill whenever someone says "plan a refactor", "refactoring RFC",
  "how do I refactor this safely", "restructure this module", or when an architecture
  review (improve-codebase-architecture) has identified a refactor worth doing. Also
  trigger when someone wants to make a big structural change but is nervous about
  breaking things — the tiny-commit plan is designed to make large refactors safe.
  Outputs an RFC-style plan as a markdown file or GitHub issue.
---

# Request Refactor Plan

You create safe, step-by-step refactor plans. The key insight: big refactors are
dangerous, but a sequence of tiny, independently-safe commits is not. Each commit
should leave the codebase in a working state — tests pass, app runs, nothing is
half-done.

## Philosophy

The goal isn't to refactor in one heroic commit. It's to create a sequence of boring,
obvious, individually-safe steps that add up to a big structural change. Each step
should be:
- **Small enough to review in 5 minutes**
- **Safe enough to deploy independently**
- **Reversible** — if something goes wrong, revert one commit, not twenty
- **Testable** — tests pass at every step

This is the Mikado Method meets trunk-based development.

## The Interview

Before writing the plan, understand the refactor:

1. **What are you trying to change?** (Current structure → desired structure)
2. **Why now?** (What pain is this causing? What does it unblock?)
3. **What scares you about this change?** (The answer reveals the real risks)
4. **What tests exist?** (Your safety net determines how aggressive you can be)
5. **What's the blast radius?** (How many files/modules does this touch?)

Ask these one at a time. The "what scares you" question is the most important — it
tells you where to be extra careful.

## Building the Plan

### Step 1: Define the end state

Describe what the codebase looks like AFTER the refactor is complete. Be specific
about file structure, module boundaries, and interface changes.

### Step 2: Identify the risk zones

What could break? Map the areas of concern:
- Files with no test coverage
- Shared interfaces that many callers depend on
- State management or data flow changes
- External integrations that are hard to test

### Step 3: Plan the commit sequence

Each commit in the sequence should be one of these safe operations:

| Operation | Risk | Example |
|-----------|------|---------|
| **Rename** | Very low | Rename file or function |
| **Extract** | Low | Pull code into a new function/module |
| **Inline** | Low | Replace indirection with direct code |
| **Move** | Low-Medium | Move code to a different module |
| **Introduce abstraction** | Medium | Add a new interface/protocol |
| **Replace implementation** | Medium-High | Swap one implementation for another |
| **Delete** | Low (if tests pass) | Remove dead code |
| **Change interface** | High | Modify a public API |

Order them from lowest risk to highest. Front-load the safe structural moves.
Save interface changes for late in the sequence when you have confidence.

### Step 4: Add verification points

After every 3-5 commits, insert a verification checkpoint:
- Run the full test suite
- Manually smoke-test the affected feature
- Review the diff since the last checkpoint

## Plan Template

```markdown
# Refactor Plan: [Descriptive Title]

**Source:** [Architecture review RFC or description of the problem]
**Date:** [current date]
**Risk Level:** [Low / Medium / High]
**Estimated commits:** [number]
**Estimated effort:** [time range]

---

## Current State
[How it works now. Include file paths and structure.]

## Desired State
[How it should work after. Include proposed file paths and structure.]

## Why This Matters
[The pain this refactor addresses]

## Risk Assessment
- **Test coverage in affected area:** [Good / Partial / Poor]
- **Number of callers affected:** [count]
- **Data migration needed:** [Yes / No]
- **Can be done incrementally:** [Yes / No]

## Prerequisites
- [ ] [Any prep work needed before starting]

## Commit Sequence

### Commit 1: [description]
**Operation:** [Rename / Extract / Move / etc.]
**Files touched:** [list]
**Risk:** Low
**What to verify:** [How to confirm this commit is safe]

### Commit 2: [description]
**Operation:** [type]
**Files touched:** [list]
**Risk:** Low
**What to verify:** [verification step]

--- ✅ Checkpoint: Run full test suite ---

### Commit 3: [description]
...

--- ✅ Checkpoint: Smoke test [feature] ---

### Commit N: [description]
...

## Rollback Plan
[If things go wrong at any point, what do you do?]

## Definition of Done
- [ ] All tests pass
- [ ] No dead code remains
- [ ] New structure matches desired state
- [ ] Documentation updated (if applicable)
```

## Environment Detection & Output

### Claude.ai
- Save to `/mnt/user-data/outputs/refactor-plan-[name].md`
- Present the file

### Claude Code
- Save to `./plans/refactor-plan-[name].md`
- Offer to create as a GitHub issue with `refactor` label
- Can inspect the actual codebase to make the plan concrete with real file paths

## Handoff

"Plan is ready. Want to start executing? I can run **tdd** on each commit in the
sequence to make sure nothing breaks."

## Anti-patterns

- One giant commit that "refactors everything"
- Refactoring without tests (add tests first, then refactor)
- Mixing refactoring with feature work in the same commits
- Plans that require the codebase to be broken for intermediate steps
- Not having a rollback plan
