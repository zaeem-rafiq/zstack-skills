---
name: product-audit
description: >
  One-command pipeline that layers the audit skill family with the session's
  delegation policies: run ux-audit (and optionally growth-audit /
  app-readiness-audit) with lanes delegated to worker-research, pass the review
  gate, then implement a capped set of the resulting todos/ tickets via the
  fable-gpt Codex workflow with independent worker-verify proof per ticket. Use
  when the user says "product audit", "audit and fix", "overhaul this app",
  "run the full audit pipeline", or wants audit → implementation in one go.
  Do NOT use for an audit-only request (invoke the audit skill directly), a
  single known bug or feature (no audit needed), or when the Codex plugin/CLI
  is unavailable (fall back to worker-implement and say so).
---

# Product Audit

You orchestrate the full audit → implement → verify pipeline in one session.
This skill encodes the layering; the method lives in the skills it invokes.

## Arguments

`<repo-path> [--audits ux[,growth,readiness]] [--cap <spec>] [--stop-after-audit]`

Defaults: `--audits ux`, `--cap P0` (implement P0 tickets only), continuous
run. `--cap` accepts a severity (`P0`, `P0-P1`) or a count (`top3`).
`--stop-after-audit` ends the run after the report + todos are written, for a
human checkpoint before any implementation.

## Phase 0 — Activate policies (in this order, before the task skill)

1. Invoke `fable-gpt` — Codex executes heavy implementation, Claude
   orchestrates and reviews. If the Codex plugin/CLI is unavailable, say so
   and substitute `worker-implement` for every Codex dispatch below.
2. Invoke `orchestrate-workers` — worker routing for research and
   verification.
3. State the division of labor once, explicitly, so routing never drifts
   mid-session:
   - Audit lanes → `worker-research` (read-only, cited digests).
   - Ticket implementation → Codex via `/codex:rescue` (or the fallback).
   - Independent proof → `worker-verify` (never fixes).
   - Trivial exception: a ticket touching one file with <10 changed lines is
     implemented inline — a fresh Codex context costs more than it saves.
4. **Gate check:** if the repo matches the chain-gated set (currently
   rafiq-google-challenge, Advocate, orchestrator — see CHAIN_REPO_PATTERNS),
   warn the user now that implementation commits will hit `require-chain.sh`
   unless the SDLC chain runs per ticket, and ask whether to run the chain,
   proceed and answer the gate's ask at commit time, or stop after the audit.

## Phase 1 — Audit

Invoke each requested audit skill (`ux-audit`, then `growth-audit`, then
`app-readiness-audit` when asked) on `<repo-path>`, dispatching lanes to
`worker-research` per the division of labor. The first audit's Lane 1 writes
`docs/audit/product-context.md`; later audits reuse it — do not re-infer.

Each audit runs its own review gate before writing artifacts. Do not weaken
it: P0/P1 evidence re-verified, absence claims checked repo-wide, three
questions answered.

If `--stop-after-audit`: report the executive summary, the gap table, and
the todos/ queue, then stop.

## Phase 2 — Implement the capped ticket set

1. Select tickets from `todos/` per `--cap`, ordered by severity then gap ID.
   Announce the selected set and what was excluded before starting.
2. For each ticket, sequentially:
   a. Read the ticket; confirm its cited evidence still matches the repo.
   b. Dispatch Codex with the full ticket as context (Codex does not see the
      conversation): problem, evidence, proposed solution, file boundaries,
      acceptance criteria.
   c. **Inspect the Codex diff before accepting** — never merge it sight
      unseen. Show the user the diff with your review verdict.
   d. Dispatch `worker-verify` to independently prove the acceptance
      criteria: run tests/linters and drive the affected behavior. Evidence,
      not "looks good."
   e. Mark the todo done (rename `-ready-` → `-complete-` or per repo
      convention) only when verification passes. A failed verification goes
      back to Codex once; a second failure stops the pipeline and reports.
3. One ticket lands fully (implemented, verified, committed if the repo's
   gates allow) before the next dispatch. No parallel Codex dispatches into
   the same working tree — parallel tickets require worktrees, which is out
   of scope for this skill's default run.

## Phase 3 — Close out

- Report: tickets implemented + verified, tickets remaining in todos/,
  verification evidence per ticket, and anything the gates blocked.
- Run the compound step: method lessons via `ce-compound` if available, else
  `tasks/lessons.md`. Fold recurring pipeline lessons back into this skill.
- Complete the Done Checklist with per-ticket test evidence.

## Guardrails

- The audit phases never modify app source; only Phase 2 does, and only
  within the selected tickets' file boundaries.
- Never expand the cap mid-run because "it was quick" — finishing the capped
  set and offering the next batch is the contract.
- If anything goes sideways mid-pipeline (verification failures, gate
  denials, Codex unavailable), stop and re-plan with the user rather than
  improvising around it.
