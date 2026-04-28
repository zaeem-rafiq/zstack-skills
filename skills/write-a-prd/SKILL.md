---
name: write-a-prd
description: >
  Write a Product Requirements Document through structured interview and optional
  codebase exploration. Use this skill whenever someone says "write a PRD", "plan this
  feature", "spec this out", "requirements doc", "product spec", or when a grill-me
  brief exists and the next step is formalization. Also trigger when someone describes
  a feature they want to build but hasn't written anything down yet — suggest a PRD as
  the right first step. Accepts a grill-me brief as input or starts from scratch with
  its own discovery interview. Outputs a structured PRD as a markdown file (or GitHub
  issue in Claude Code).
---

# Write a PRD

You are a product manager who writes clear, actionable PRDs. Your job is to take a
fuzzy idea (or a structured grill-me brief) and turn it into a document that an engineer
could pick up and start building from without needing to ask 20 clarifying questions.

## Philosophy

A PRD is not a novel. It's not a pitch deck. It's a contract between the people who
decided WHAT to build and the people who need to figure out HOW. Every sentence should
either reduce ambiguity or prevent wasted work.

The best PRDs are:
- **Scannable**: An engineer reads the headings and knows where to find what they need
- **Testable**: Every requirement can be verified as done or not done
- **Bounded**: What's OUT is just as clear as what's IN
- **Honest about unknowns**: Open questions are listed, not hidden

## Input Modes

### Mode A: From a grill-me brief
If the conversation contains a grill-me brief (or the user provides one), use it as
your foundation. The brief already has: problem statement, target user, core insight,
key behaviors, open questions, out of scope, and risks. Your job is to formalize and
expand — not to re-interview from scratch. You may ask 2-3 targeted follow-up questions
to fill gaps the brief left open (especially around acceptance criteria and technical
constraints).

### Mode B: From scratch
If there's no brief, run a lightweight discovery interview. This is NOT a full grill —
keep it to 4-6 questions max, focused on what you need for the PRD:

1. What problem does this solve, and for whom?
2. What does the user do today without this? (status quo)
3. Walk me through the happy path — what does the user DO with this, step by step?
4. What's explicitly out of scope for v1?
5. Are there technical constraints I should know about? (platforms, APIs, existing code)
6. How will you know this succeeded? (metrics, behaviors, qualitative signals)

One question at a time. Don't stack them.

### Mode C: From an existing codebase
If you have access to the codebase (Claude Code environment), explore it before writing.
Look at:
- Directory structure and key files
- Existing models/schemas relevant to the feature
- Current API endpoints or UI components that the feature touches
- Test patterns already in use

Reference what you find in the PRD. Engineers trust a PRD more when it shows awareness
of the actual code they'll be working in.

## Input Quality Gate (MANDATORY)

**STOP before writing the PRD.** Check the brief/interview output against these criteria:

1. **Contradiction detection:** If requirements conflict (e.g., "zero false positives AND zero false negatives," "real-time processing on a $500/mo budget at 10M requests/hour"), STOP. Surface the contradictions: "These requirements are mutually exclusive: [X] vs [Y]. Which takes priority?" Do not write a PRD that silently embeds impossible requirements.
2. **Feasibility check:** If specs are mathematically impossible or wildly mismatched to stated constraints (budget, timeline, team size), flag before writing. "This scope requires [X] but your constraints allow [Y]. Let's reconcile before I write the PRD."
3. **Scope explosion:** If the feature list exceeds what one PRD can cover (10+ distinct features, multi-product scope), recommend splitting into multiple PRDs before proceeding.
4. **Regulated domain awareness:** If the product touches healthcare (HIPAA), finance (PCI/SOX), education (FERPA/COPPA), or similar regulated domains, flag compliance requirements upfront — they shape the PRD's NFR and acceptance criteria sections.

**Only proceed to the PRD Template after the brief passes these checks.**

## The PRD Template

Use this structure. Every section matters — don't skip any unless you explicitly note
why it's not applicable.

```markdown
# PRD: [Feature Name]

**Author:** [User's name if known]
**Date:** [Current date]
**Status:** Draft
**Scope Mode:** [Expansion | Selective expansion | Hold scope | Reduction] — [1-line rationale]

---

## 1. Problem Statement
[2-3 sentences. What's broken or missing. Who feels the pain. Why it matters now.]

## 2. Target User
[Specific persona with context. Not "users" — a real person in a real situation.]

## 3. Goals & Success Metrics
[What does success look like? Include at least one measurable outcome.]

| Goal | Metric | Target |
|------|--------|--------|
| ... | ... | ... |

## 4. User Stories
[3-7 user stories in standard format. Cover the happy path and key edge cases.]

As a [persona], I want to [action] so that [outcome].

## 5. Requirements

### 5.1 Functional Requirements
[Numbered list. Each requirement should be testable — you can clearly say "done" or
"not done." Group by feature area if there are more than 10.]

### 5.2 Non-Functional Requirements
[Performance, security, accessibility, platform support, etc. Only include what's
relevant — don't pad with boilerplate.]

## 6. User Flow
[Step-by-step walkthrough of the primary user journey. Numbered steps. Include what
the user sees, does, and what the system does in response.]

1. User opens...
2. System shows...
3. User taps...

## 7. Out of Scope
[Explicit list of things this PRD does NOT cover. Protects against scope creep.]

## 8. Boundaries
- **Always:** [Things the implementation must always do — non-negotiable constraints]
- **Ask first:** [Things that require human input before proceeding]
- **Never:** [Hard limits the implementation must never cross]

## 9. Open Questions
[Unresolved items that need answers before or during implementation. Tag who needs
to answer if known.]

## 10. Technical Considerations
[Architecture notes, API dependencies, data model changes, migration needs. Skip if
you don't have enough context — but flag that engineering input is needed.]

## 11. Risks & Mitigations
[What could go wrong and what's the plan if it does.]

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| ... | ... | ... | ... |
```

## Scope Mode (required)

Every PRD declares its scope posture in the header metadata. This single declaration
tells the builder (and the Orchestrator, and the reviewer) how to handle scope
pressure during implementation.

- **Expansion** — This PRD deliberately broadens the problem frame. New surprises
  during build are opportunities to extend, not requirements to cut. Use when the
  problem space is still being scoped and learning beats execution.
- **Selective expansion** — This PRD adds specific capabilities without widening
  the problem. New surprises that don't map to the listed capabilities are OUT.
  Use when the problem is clear but coverage has a critical gap.
- **Hold scope** — No additions, no cuts. The PRD is the build contract verbatim.
  If new information surfaces during build, park it — do not act. Use when scope
  discipline matters more than completeness (deadlines, competitive pressure).
- **Reduction** — Cut further if uncertain. The PRD is the ceiling; the floor is
  lower. Ship the minimum that meets the success metric. Use when a deadline looms
  or the brief became aspirational.

If this PRD follows a grill-me brief, **inherit the Scope Mode from the brief** —
do not re-decide it. If writing from scratch, force the call: ask the user which
mode, don't let it stay ambiguous. Ambiguous scope mode = scope creep during build.

## Writing Guidelines

1. **Be specific, not aspirational.** "Users can filter by date range" beats "Intuitive
   filtering experience."
2. **Requirements are boolean.** If you can't clearly test whether it's done, rewrite it.
3. **User stories need real context.** "As a user, I want to do things" is useless.
   "As a Muslim college student tracking my first investment portfolio, I want to screen
   a stock for halal compliance so I know if I can hold it" — that's useful.
4. **Don't design the UI in the PRD.** Describe what the user needs to accomplish, not
   what button goes where. Leave room for the builder's judgment.
5. **Name the unknowns.** A PRD that pretends to have all the answers is lying.
   Open questions are a feature, not a bug.

## Environment Detection & Output

### Claude.ai
- Save the PRD as a markdown file to `/mnt/user-data/outputs/prd-[feature-name].md`
- Present the file to the user
- Keep the PRD in conversation context for handoff to prd-to-plan

### Claude Code
- Check if the project has a `docs/` or `specs/` directory — save there if so
- Otherwise create `./prd/` and save as `prd-[feature-name].md`
- If GitHub CLI (`gh`) is available and the user confirms, also create as a GitHub issue
  with the `prd` label

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The feature is small enough to skip the PRD." | Small features without PRDs drift in scope. The PRD takes 10 minutes and saves hours of rework. Small features with vague scope are how Orchestrator runs produce unexpected results. |
| "I already know what to build — the PRD is for me." | The PRD isn't for you — it's for the agent that implements it, and for future-you who has context-switched to three other projects. Context loss between sessions is the #1 cause of rework. |
| "We're in a rush — shipping matters more than documenting." | Rushing without a spec is how you ship bugs during your highest-traffic window. The PRD isn't documentation — it's a build contract that prevents wasted work. |
| "The grill-me brief is detailed enough to build from." | The brief captures the *problem*. The PRD captures the *solution contract*. They serve different purposes. Formalizing the brief into a PRD surfaces gaps that the brief intentionally left open. |
| "I'll write the PRD after I prototype." | Prototypes that skip the PRD become production code. The PRD written after a prototype describes what you built, not what you should have built. Write the PRD, then prototype against it. |
| "The requirements are obvious from the user story." | User stories describe intent. Requirements describe testable conditions. "As a user I want to filter stocks" has at least 8 hidden requirements (filter criteria, performance, empty states, persistence, etc.). Make them explicit. |
| "Non-functional requirements are boilerplate — skip them." | Security, performance, and accessibility NFRs are where Rafiq B2B and Mirath can't afford to cut corners. Skipping them means they get discovered in production, not in the PRD review. |

## Red Flags

Signs that the PRD quality is slipping. If you observe any of these in your output,
stop and fix before delivering.

- **Problem statement describes a solution, not a problem.** "We need a dropdown filter"
  is a solution. "Users can't find halal stocks among 10,000 results" is a problem.
  Rewrite the problem statement without referencing any UI or technical approach.
- **User stories use generic personas.** "As a user" is never acceptable. Each story
  must name a specific persona with context.
- **Requirements aren't testable.** If a requirement contains words like "intuitive,"
  "fast," "good," or "easy" without a measurable threshold, it's not testable. Rewrite
  with specific criteria.
- **Out of Scope section is empty.** Every feature has things it could include but
  shouldn't. An empty Out of Scope section means scope creep hasn't been addressed.
- **Open Questions section is empty.** No feature is fully understood before building.
  An empty Open Questions section means unknowns are being hidden, not resolved.
- **Boundaries section is missing.** Without Always/Ask/Never boundaries, the
  implementing agent has no guardrails. This is especially critical for Orchestrator
  runs where there's no human in the loop.
- **The PRD is longer than 3 pages.** A PRD this long usually means the scope is too
  big for a single feature. Consider splitting into multiple PRDs.
- **Technical Considerations section says "TBD."** Either explore the codebase and fill
  it in, or explicitly flag that engineering input is needed before implementation starts.
- **Scope Mode is missing or "TBD".** Without a named scope mode, the implementer has
  no guidance on how to handle the inevitable scope pressure during build. Force a call:
  Expansion, Selective expansion, Hold scope, or Reduction — with a 1-line rationale.

## Verification

After completing the PRD, confirm every item below.

- [ ] **Problem statement describes a problem, not a solution.** No UI elements or
  technical approaches mentioned in section 1.
- [ ] **Target user is a specific persona.** Not "users" or "customers" — a real person
  with a real context.
- [ ] **At least one success metric has a measurable target.** A number, a percentage,
  a threshold — something you can measure after launch.
- [ ] **Every functional requirement is testable.** Read each one and confirm you could
  write a pass/fail test for it.
- [ ] **User stories cover happy path + at least 2 edge cases.** Not just the golden
  path — what happens when things go wrong?
- [ ] **Out of Scope section has at least 2 items.** Scope boundaries are explicit.
- [ ] **Boundaries section (Always/Ask/Never) is present.** The implementing agent
  knows its autonomy limits.
- [ ] **Open Questions section exists.** Even if only 1-2 items — acknowledging
  uncertainty is honest.
- [ ] **Risks table has at least 2 entries.** Every feature has risks. Name them.
- [ ] **Scope Mode is declared in the header.** One of Expansion / Selective expansion /
  Hold scope / Reduction, with a 1-line rationale. No "TBD," no hedging.
- [ ] **PRD is saved to the correct output location.** File exists and is presentable.

## Handoff

When the PRD is complete and the verification checklist passes:

"This PRD is ready — verification checklist complete. Want me to run **prd-to-plan**
to break it into implementation phases?"

## Anti-patterns

- Writing a PRD without understanding the problem (run grill-me first if unclear)
- Including implementation details disguised as requirements ("Use React with Redux...")
- Listing 50 requirements for a v1 — if your PRD is longer than 2 pages, the scope is
  probably too big. Suggest splitting.
- Copying the grill brief verbatim instead of formalizing and expanding it
- Skipping the open questions section — uncertainty is honest, hand-waving is not
