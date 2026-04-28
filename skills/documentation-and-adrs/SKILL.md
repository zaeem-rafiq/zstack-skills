---
name: documentation-and-adrs
description: >
  Document architectural decisions, not just code. Use this skill whenever a significant
  technical decision is made — database schema design, API transport choice, auth provider
  selection, infrastructure architecture, or any decision where the "why" matters more
  than the "what." Also trigger when someone says "ADR", "decision record", "document
  this decision", "why did we choose", "architecture decision", or when reviewing old
  code and the reasoning behind a choice is unclear. Outputs Architecture Decision Records
  (ADRs) as markdown files. Feeds into the project's institutional memory.
---

# Documentation and ADRs

You document decisions, not just code. Your primary output is Architecture Decision
Records (ADRs) — short documents that capture what was decided, why, what alternatives
were considered, and what the consequences are. The goal is that six months from now,
anyone (including an AI agent) can understand not just WHAT the system does, but WHY
it's built this way.

## Philosophy

Code tells you what the system does. Tests tell you what the system should do. Neither
tells you WHY — why this database instead of that one, why this auth provider, why this
API transport, why this data model shape. That context lives in people's heads, and it
evaporates when they context-switch, leave the project, or forget.

ADRs are cheap insurance. They take 10 minutes to write and save hours of "why is it
like this?" conversations later. They're especially critical for AI-assisted development
where the implementing agent needs to understand constraints and tradeoffs, not just
requirements.

## When to Use

- When choosing between technical alternatives (database, auth, hosting, framework)
- When making a design tradeoff (performance vs. simplicity, flexibility vs. consistency)
- When changing an existing architectural decision
- When someone asks "why did we do it this way?" and the answer isn't obvious from code
- When the Orchestrator makes an implementation choice that deviates from the expected pattern

## The ADR Process

### Step 1: Identify the Decision

A decision worth recording is one where:
- There were multiple reasonable alternatives
- The choice has lasting consequences (hard to reverse)
- Future engineers (or agents) might question the choice
- The reasoning depends on context that won't be obvious later

### Step 2: Write the ADR

Use this template:

```markdown
# ADR-[NNN]: [Decision Title — verb-first]

**Date:** [current date]
**Status:** [Proposed / Accepted / Deprecated / Superseded by ADR-XXX]
**Deciders:** [who made or is making this decision]

## Context

[What is the situation? What forces are at play? What problem are we solving?
Include technical constraints, business constraints, and timeline pressures.
2-4 sentences.]

## Decision

[What did we decide? State it clearly in one sentence, then expand if needed.
This should be specific enough that someone could verify whether the system
matches the decision.]

## Alternatives Considered

### [Alternative 1: name]
[Brief description. Why it was rejected or deprioritized.]

### [Alternative 2: name]
[Brief description. Why it was rejected or deprioritized.]

## Consequences

### Positive
[What gets better because of this decision?]

### Negative
[What gets harder or worse? What tradeoffs did we accept?]

### Risks
[What could go wrong with this decision? Under what conditions should we revisit it?]

## References
[Links to PRDs, issues, research, documentation that informed the decision.]
```

### Step 3: Number and File

ADRs are numbered sequentially: ADR-001, ADR-002, etc. Store them in
`docs/adrs/` or `docs/decisions/` in the project root.

## Example ADR Candidates

Decisions in any non-trivial codebase that typically deserve an ADR:

- **Transport choice for an API.** (e.g., HTTP vs SSE vs stdio for an MCP
  server, REST vs GraphQL vs gRPC for a service)
- **Domain-model boundaries.** When two concepts look similar but mean
  different things, encode the separation as an ADR so it survives refactors.
- **Auth provider.** (e.g., Clerk vs Auth0 vs Supabase Auth vs roll-your-own)
- **CI / agent execution model.** (e.g., GitHub Actions vs a self-hosted
  pipeline vs a managed agent platform)
- **Hosting / deploy target.** (e.g., Cloud Run vs Lambda vs Vercel vs
  Fly.io — the trade-offs are real and worth documenting)
- **Scope of feature support.** When you intentionally choose breadth over
  simplicity (or vice versa), capture the reasoning so it isn't reversed by
  accident later.
- **Primary data layer.** (e.g., Supabase vs Firebase vs Planetscale vs
  self-hosted Postgres)

## Environment Detection & Output

### Claude.ai
- Save ADR to `/mnt/user-data/outputs/adr-[NNN]-[short-name].md`
- Present the file to the user

### Claude Code
- Save to `docs/adrs/adr-[NNN]-[short-name].md` (create directory if needed)
- Update an index file `docs/adrs/README.md` if it exists

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The code is self-documenting." | Code documents WHAT, not WHY. Why did you choose Supabase over Firebase? Why Streamable HTTP over SSE? That context is never in the code. |
| "We'll remember why we made this decision." | You won't. Context evaporates after 2-3 weeks of working on other things. And the Orchestrator agent has no memory of past reasoning unless it's written down. |
| "ADRs are bureaucratic overhead." | An ADR takes 10 minutes. Rediscovering the reasoning behind a decision takes hours, and sometimes leads to accidentally reversing a decision that was made for good reason. |
| "This decision is obvious — no one will question it." | If it's obvious, the ADR will be short. But "obvious" decisions are often obvious only in the current context — a new team member, a new agent session, or a changed business requirement makes them non-obvious. |
| "We're moving too fast to document." | Moving fast is exactly when decisions get made implicitly and lost. The ADR captures the decision in 10 minutes so you don't spend a day reconstructing it later. |

## Red Flags

- **A major technical choice was made with no ADR.** If you chose a database, auth
  provider, hosting platform, or API design pattern without documenting why, write the
  ADR retroactively.
- **The ADR has no alternatives.** Every decision implies alternatives that were rejected.
  If none are listed, the decision-making process wasn't rigorous enough.
- **The consequences section is all positive.** Every decision has tradeoffs. A
  consequences section with only upsides means the downsides are being hidden.
- **The ADR status is stuck at "Proposed."** ADRs should move to "Accepted" promptly.
  A backlog of proposed-but-never-accepted ADRs means decisions are being made without
  formal commitment.

## Verification

After writing an ADR, confirm every item below.

- [ ] **Decision is stated in one clear sentence.** Someone could verify whether the
  system matches the decision.
- [ ] **At least 2 alternatives are documented.** Each with a reason for rejection.
- [ ] **Consequences include both positive and negative.** Tradeoffs are explicit.
- [ ] **Context includes the forces at play.** Technical constraints, business
  constraints, timeline pressures — not just the technical facts.
- [ ] **ADR is numbered sequentially.** No gaps, no duplicates.
- [ ] **ADR is saved in the correct location.** `docs/adrs/` directory.

## Handoff

"ADR written — [ADR-NNN: title]. Want me to write ADRs for any of the other
undocumented decisions, or move on to the next task?"
