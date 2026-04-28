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
- **Always assign to a non-null project** (e.g., "Acme: App Store Stability & Growth").
  The Orchestrator ignores issues without a project. This is a hard constraint.

### Fallback
- Save to `./issues/issues-[feature-name].md`

## Common Rationalizations

These are excuses that surface during issue decomposition. When you catch yourself
reaching for one, stop — the rebuttal is the correct path.

| Rationalization | Reality |
|---|---|
| "One big issue is easier than five small ones." | One big issue means one big PR with tangled changes that are hard to review, hard to revert, and hard for the Orchestrator to process autonomously. Five small issues means five reviewable, revertable, independently shippable commits. |
| "The dependency order is obvious, I don't need to write it out." | Obvious to you right now, in this context window. Not obvious to the Orchestrator at 2am processing the queue, or to you in three weeks when you've context-switched. Make it explicit in the `Depends on` field. |
| "This issue is too small to be worth its own ticket." | If it's independently testable and demoable, it deserves its own ticket. Small issues are faster to review, faster to merge, and faster to revert. The overhead of creating a ticket is 30 seconds; the overhead of untangling a combined ticket is hours. |
| "I'll figure out the acceptance criteria during implementation." | Acceptance criteria written during implementation describe what you built, not what you should have built. Write them before implementation so they serve as a contract. The Orchestrator uses them to know when an issue is done. |
| "This feature doesn't decompose into vertical slices." | Every feature decomposes into vertical slices. If you can't find them, you're thinking in horizontal layers (backend, then frontend, then tests). Reframe: what's the thinnest end-to-end path a user could see? That's your first slice. |
| "We're behind schedule, just make one issue for the whole feature." | Being behind schedule is exactly when you need small, predictable issues. A single mega-issue hides risk. Five small issues let you ship the first three and defer the last two if time runs out — you still deliver value. |
| "The plan already has enough detail, I can skip writing formal issues." | The plan describes what to build. Issues describe what to build *this commit*. They're different granularities for different audiences. The plan is for you; the issues are for the agent executing the work. |
| "I'll assign the project later." | The Orchestrator ignores issues without a project assignment. "Later" means the issue sits unprocessed. Set the project now — it takes 2 seconds. |

## Red Flags

Signs that issue decomposition quality is slipping. If you observe any of these in
your output, **stop and restructure before publishing the issues.**

- **An issue title starts with a noun instead of a verb.** "Authentication system" is
  not an issue — it's a feature area. "Add JWT token validation to API endpoints" is
  an issue. Every title must start with a verb.
- **An issue has no acceptance criteria, or criteria are vague.** "It works" and
  "Looks good" are not acceptance criteria. Each criterion must be a specific,
  binary pass/fail condition that the Orchestrator can evaluate.
- **An issue touches more than 5 files.** This is a heuristic, not a hard limit, but
  issues touching many files are usually too large. Consider whether it can be split
  into smaller slices.
- **Two issues have circular dependencies.** If A depends on B and B depends on A,
  they're actually one issue, or the decomposition is wrong. Redraw the boundary.
- **All issues are the same size (S or M).** Real feature decomposition produces
  varied sizes. If everything looks uniform, you're probably not decomposing deeply
  enough — some slices should be tiny scaffolding, others should be meatier logic.
- **No issue is marked as parallelizable.** In any non-trivial feature, some work can
  happen in parallel. If everything is strictly sequential, reconsider whether some
  slices are truly independent.
- **The "Context" field is empty or just restates the title.** Context explains *why*
  this issue exists and what it enables for the next issue. Without it, the
  implementing agent has no strategic understanding of the work.
- **Issues are missing the `Depends on` field.** Even if the dependency is "none,"
  state it explicitly. The Orchestrator reads this field to determine processing
  order.
- **Issues are missing a project assignment (Linear).** The Orchestrator's launchd
  service filters by project. No project = invisible to the pipeline.

## Verification

After decomposing a PRD into issues, confirm every item below. Each checkbox requires
**evidence** — a specific reference, not just "I checked."

- [ ] **Every issue title starts with a verb.** Scan all titles. No nouns-as-titles.
- [ ] **Every issue has 2+ testable acceptance criteria.** Criteria are specific,
  binary, and written so the Orchestrator can evaluate pass/fail.
- [ ] **Dependency map is present and acyclic.** The visual dependency tree exists
  at the top of the output. No circular dependencies.
- [ ] **Every issue has a `Depends on` field.** Even if the value is "none."
- [ ] **No issue exceeds 3 days of estimated effort.** If an issue is marked "L,"
  justify why it can't be split further, or split it.
- [ ] **At least one parallelizable pair identified** (for features with 4+ issues).
  If none exist, state why all work is strictly sequential.
- [ ] **Project assignment is set for all Linear issues.** Name the specific project
  each issue will be assigned to.
- [ ] **Issue count is reasonable for the feature scope.** A rough heuristic: 1 issue
  per 1-3 days of work. A 2-week feature should have ~5-10 issues. Fewer means
  issues are too large; more means they're too granular.
- [ ] **First issue is the tracer bullet.** The first issue in dependency order
  delivers the thinnest end-to-end path through the feature. It proves the
  architecture works before building on top of it.

## Handoff

When all issues are written and the verification checklist is complete:

"Issues are ready — [N] issues across [M] phases. Verification checklist complete.
Dependency map is at the top of the output. Want to start building? I can run
**tdd** on the first issue: '[title of first issue].'"
