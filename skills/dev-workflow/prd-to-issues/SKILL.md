---
name: prd-to-issues
description: >
  Convert a PRD or implementation plan into vertical-slice issues with dependency
  ordering. Use this skill whenever someone says "create tickets", "break into issues",
  "make tasks", "GitHub issues from this", "Linear tickets", or when a plan exists and
  needs to become trackable work items. Also trigger when someone has a PRD or plan and
  asks "what do I build first?" — the answer is the ordered issue list. Each issue is a
  vertical slice: independently shippable, testable, and demoable. Outputs to GitHub
  issues, Linear, or local markdown files depending on environment.
---

# PRD to Issues

You turn plans into work items. Each issue you create is a **vertical slice** —
independently shippable, testable, and demoable. No issue should be "set up the
database" or "write CSS." Every issue delivers visible value.

## Philosophy

Bad tickets create bad software. When issues are vague ("implement search"), engineers
either over-build or under-build. When issues are horizontal layers ("create API
endpoints"), nothing works until everything works. Vertical slices let each ticket
stand on its own — you could ship it, get feedback, and adjust before the next one.

## Input

You need a PRD or implementation plan (ideally from prd-to-plan). If neither exists:
1. Ask if they have one to provide
2. Suggest running the earlier skills first
3. If they insist, work from the conversation context but warn that the issues will
   be rougher without a solid plan behind them

## How to Create Issues

### Step 1: Identify the slices

Read the plan phase by phase. For each phase, break it into the smallest independently
shippable units. Each unit should:
- Take 1-3 days of work (not hours, not weeks)
- Be testable — you can write acceptance criteria
- Be demoable — you can show someone what changed
- Touch the full stack for its slice (not just one layer)

### Step 2: Order by dependency

Arrange the issues so that:
1. No issue depends on an unfinished later issue
2. The highest-risk/highest-learning issues come first
3. Parallelizable issues are marked as such

### Step 3: Write each issue

Use this format for each issue:

```markdown
## [Issue Title — verb-first, specific]

**Phase:** [Which phase from the plan]
**Depends on:** [Issue numbers this blocks on, or "none"]
**Effort:** [S/M/L]
**Priority:** [P0/P1/P2]

### Context
[1-2 sentences: why this issue exists, what it enables]

### Acceptance Criteria
- [ ] [Testable criterion 1]
- [ ] [Testable criterion 2]
- [ ] [Testable criterion 3]

### Technical Notes
[Optional: hints about implementation approach, relevant files, gotchas]
```

### Step 4: Create a dependency map

Show the order visually:

```
Issue 1 (P0)
  └── Issue 2 (P0)
  └── Issue 3 (P1) ← can parallel with Issue 2
       └── Issue 4 (P1)
```

## Issue Writing Rules

1. **Titles are verb-first.** "Add halal screening filter to stock search" not
   "Stock screening feature."
2. **Acceptance criteria are checkboxes.** Engineers check them off. QA verifies them.
3. **Every issue has context.** A sentence of "why" saves hours of confusion.
4. **Size matters.** If an issue takes more than 3 days, split it. Less than half a
   day, merge it with a related issue.
5. **Label consistently.** Use labels for phase, priority, and feature area.

## Environment Detection & Output

### Claude.ai
- Save all issues as a single markdown file to
  `/mnt/user-data/outputs/issues-[feature-name].md`
- Include the dependency map at the top
- Present the file to the user

### Claude Code with GitHub
- Check if `gh` CLI is available: `which gh`
- If available, ask the user: "Want me to create these as GitHub issues?"
- If confirmed, create each issue with `gh issue create` with appropriate labels
- Add dependency references in the issue body ("Depends on #XX")

### Claude Code with Linear
- Check if Linear MCP tools are available
- If available, offer to create as Linear issues

### Fallback
- Save to `./issues/issues-[feature-name].md`

## Handoff

"Issues are ready. Want to start building? I can run **tdd** on the first issue."
