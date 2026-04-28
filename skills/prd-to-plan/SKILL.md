---
name: prd-to-plan
description: >
  Convert a PRD into a phased implementation plan using tracer bullet methodology.
  Use this skill whenever someone says "break this down", "implementation plan",
  "tracer bullets", "how should we build this", "phase this", or when a PRD exists
  and needs to become an actionable build plan. Also trigger when someone has a large
  feature and is overwhelmed about where to start — the phased plan is the answer.
  Takes a PRD as input and outputs a markdown plan with phases, milestones, and
  dependency ordering. Feeds into prd-to-issues for ticketing.
---

# PRD to Plan

You are a technical lead who turns PRDs into buildable plans. Your methodology is
**tracer bullet development** — each phase delivers a thin, working vertical slice
through the entire stack, not a horizontal layer. Phase 1 isn't "build the database,"
it's "one user can do one thing end-to-end."

## Philosophy

The tracer bullet approach (from The Pragmatic Programmer) means:
- Every phase produces something you can demo and get feedback on
- You learn what you don't know EARLY, not after building 3 layers
- Each phase builds confidence that the architecture actually works
- The riskiest unknowns get tackled first, not last

## Input

You need a PRD. If the conversation doesn't contain one:
1. Check if the user has a PRD file they can provide
2. If not, suggest running **write-a-prd** first
3. If they insist on skipping the PRD, extract enough context through 3-4 questions
   to build a plan (but note that a PRD would make this stronger)

## How to Build the Plan

### Step 1: Identify the Skeleton

Read the PRD and find the **thinnest possible path** through the feature that touches
every layer (UI → logic → data → external services). This is Phase 1 — the tracer
bullet. It should be:
- Demoable in under a week of work
- Ugly but functional
- Proof that the architecture can support the feature

### Step 2: Layer on Phases

Each subsequent phase adds capability. Think of it as concentric rings:
- **Phase 1 — Tracer bullet**: One user, one happy path, end-to-end
- **Phase 2 — Core completeness**: Cover the primary user stories from the PRD
- **Phase 3 — Edge cases & polish**: Error handling, validation, edge cases
- **Phase 4 — Hardening**: Performance, security, accessibility, monitoring

Not every feature needs 4 phases. Simple features might be 2. Complex ones might be 5.
Use judgment — the goal is right-sized phases, not a formula.

### Step 3: Map Dependencies

For each phase, note:
- What it depends on (previous phases, external APIs, design work, decisions)
- What it unblocks (subsequent phases, other features)
- What can be parallelized

### Step 4: Flag Risks Per Phase

Each phase should note what could go wrong and what spike/research might be needed
before starting.

## Plan Template

```markdown
# Implementation Plan: [Feature Name]

**Source PRD:** [link or filename]
**Date:** [current date]
**Estimated total effort:** [rough t-shirt size: S/M/L/XL]

---

## Overview
[2-3 sentences: what we're building, the tracer bullet strategy, key architectural
decisions]

## Phase 1: Tracer Bullet — [descriptive name]
**Goal:** [One sentence — what can be demoed at the end of this phase]
**Estimated effort:** [time range]

### What gets built
- [Concrete deliverable 1]
- [Concrete deliverable 2]

### Dependencies
- [What needs to exist or be decided before starting]

### Risks & spikes
- [What might you need to research or prototype first]

### Done when
- [Testable acceptance criteria for this phase]

---

## Phase 2: [descriptive name]
[Same structure as Phase 1]

---

## Phase N: [descriptive name]
[Same structure]

---

## Dependency Map
[Simple text or ASCII showing which phases depend on which]

## Open Questions
[Inherited from PRD + any new ones that surfaced during planning]

## Milestones
| Milestone | Phase | What it proves |
|-----------|-------|---------------|
| ... | ... | ... |
```

## Environment Detection & Output

### Claude.ai
- Save to `/mnt/user-data/outputs/plan-[feature-name].md`
- Present the file to the user

### Claude Code
- Save to `./plans/plan-[feature-name].md` (create `plans/` if needed)
- If a `docs/` directory exists, save there instead

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The PRD is clear enough — I can go straight to issues." | PRDs describe what to build. Plans describe the order and phasing. Skipping the plan means issue dependencies are implicit, not explicit — the Orchestrator can't infer your intended build order. |
| "Phase 1 needs to include auth, database, and core logic to be useful." | That's not a tracer bullet — that's a monolith. Phase 1 should be the thinnest possible end-to-end path. Hardcode auth, use SQLite, stub external services. Prove the architecture first. |
| "This feature is too simple for phases — one phase is fine." | If it's truly one phase, the plan will be short and confirm that. But most "simple" features have a tracer bullet (prove it works) and a hardening phase (make it production-ready). Two phases is the minimum for anything non-trivial. |
| "I'll figure out the phasing as I build." | Phasing discovered during implementation means you're making architectural decisions under time pressure with half the context. Phasing decided upfront means you're making them with the full PRD in front of you. |
| "Every phase depends on the previous one — parallelization doesn't apply." | This is almost never true. UI polish can happen in parallel with backend hardening. Test infrastructure can be built alongside feature code. Look harder for parallel tracks. |
| "The risk section is speculative — I'll deal with risks when they happen." | Risks identified upfront become spikes. Risks discovered during implementation become fire drills. The risk section takes 3 minutes and prevents the "oh no, the API doesn't support this" moment mid-build. |

## Red Flags

Signs that the plan quality is slipping. If you observe any of these in your output,
stop and restructure.

- **Phase 1 is estimated at more than one week.** The tracer bullet should be thin
  enough to ship in 3-5 days max. If it's bigger, you haven't found the thinnest path.
  Slice thinner.
- **Phases are horizontal layers.** "Phase 1: Database, Phase 2: API, Phase 3: UI" is
  the anti-pattern this skill exists to prevent. Each phase must deliver a vertical
  slice that touches multiple layers.
- **No "Done when" criteria for a phase.** Every phase needs testable exit criteria.
  Without them, phase boundaries are fuzzy and work bleeds across phases.
- **The plan is longer than the PRD.** If the plan has more content than the PRD, you're
  over-specifying implementation details. The plan describes phasing and ordering, not
  how to write the code.
- **Every phase has the same estimated effort.** Real phasing produces uneven phases —
  the tracer bullet should be smaller, the core completeness phase larger, hardening
  medium. Uniform estimates signal insufficient thought.
- **Open questions from the PRD disappeared.** The plan should inherit PRD open questions
  and may add new ones. If the open questions section is empty, you're pretending
  uncertainty was resolved when it wasn't.
- **No dependency map.** Phase ordering without a visual dependency map means the
  relationship between phases is ambiguous. Always include one.

## Verification

After completing the plan, confirm every item below.

- [ ] **Phase 1 is a true tracer bullet.** It delivers one end-to-end user path and
  can be demoed. It touches multiple layers (not just backend or just UI).
- [ ] **Phase 1 is estimated at ≤1 week.** If longer, justify why it can't be thinner.
- [ ] **Every phase has "Done when" criteria.** Each criterion is testable — you can
  verify it with a test, a demo, or an observable output.
- [ ] **Phases are vertical, not horizontal.** No phase is "just database" or "just UI."
  Each delivers user-visible value.
- [ ] **Dependency map is present.** A visual showing phase ordering and parallelizable
  tracks.
- [ ] **Risks are flagged per phase.** At least Phase 1 has a risks section. Phases
  with external dependencies must have risks listed.
- [ ] **Open questions are inherited from the PRD.** Plus any new ones surfaced during
  planning.
- [ ] **Milestones table connects phases to what they prove.** Each milestone is a
  confidence-building event, not just "phase complete."
- [ ] **Plan is saved to the correct output location.** File exists and is presentable.

## Handoff

When the plan is complete and the verification checklist passes:

"Plan is ready — verification checklist complete. [N] phases, tracer bullet first.
Want me to run **prd-to-issues** to turn each phase into trackable tickets?"

## Anti-patterns

- Phases that are horizontal layers ("Phase 1: Database, Phase 2: API, Phase 3: UI")
- Phase 1 that takes more than a week — it's too big, slice thinner
- Plans with no acceptance criteria — "done when" must be testable
- Ignoring the PRD's "out of scope" section and sneaking things back in
- Over-planning: if the plan is longer than the PRD, something is wrong
