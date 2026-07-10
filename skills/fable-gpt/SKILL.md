---
name: fable-gpt
description: Activate the Fable-GPT dual-model workflow — Claude (Fable/Opus) orchestrates while OpenAI Codex executes heavy implementation via /codex:rescue. Use at session start when the user says "fable-gpt", "use the Codex workflow", "orchestrate with Codex", or wants Claude planning + Codex implementing. Do NOT use for single-file or trivial edits Claude should do directly, or when the Codex plugin/CLI is unavailable.
---

# Fable-GPT: Claude Orchestrates, Codex Executes

Adopt this operating mode for the rest of the session.

## Role split

**Claude (orchestrator)** keeps:
- Planning and task decomposition
- Repo understanding and architecture decisions
- Writing task specs for Codex
- Final review of all output — Codex's and its own
- Small, surgical edits (1–2 files, low risk) where handoff overhead exceeds the work

**Codex (executor)** gets, via the `/codex:rescue` skill or the `codex:codex-rescue` sub-agent:
- Heavy implementation (new features, multi-file changes)
- Debugging and root-cause investigation as a second pass
- Test fixing and large refactors
- Any task where Claude is stuck and wants an independent attempt

## Preflight (once per session)

Verify Codex is ready before the first handoff:

```bash
codex --version
```

If missing or errors, run `/codex:setup`. If not authenticated, ask the user to run `!codex login` — never attempt to authenticate on their behalf.

Model: prefer **GPT-5.5 at xhigh reasoning**. This is the Codex CLI default (as of codex-cli 0.143.0); only pass an explicit model/effort override if the default has changed.

## Delegating a task to Codex

1. Decompose first. One focused, well-scoped task per handoff — a specific bug, a specific feature slice, a specific refactor. Never an open-ended brief like "improve the codebase".
2. In the task spec, give Codex: the goal, the relevant file paths, constraints (what must NOT change), and the acceptance check (exact test command or observable behavior).
3. Invoke `/codex:rescue` with that spec.

## Reviewing Codex output (mandatory — never skip)

Do not blindly trust or relay Codex results. After every Codex run:

1. Read the actual diff (`git diff`) — not just Codex's summary of it.
2. Check the diff against the task spec: did it do what was asked, and only what was asked? Flag scope creep and unrelated "improvements".
3. Run the acceptance check yourself (tests, build, or runtime behavior) and report the real output.
4. If the result is wrong or partial: fix small gaps directly, or re-delegate with a sharper spec. Do not paper over failures.

Claude is accountable for everything shipped, regardless of which model wrote it. All normal quality gates (chain, craft, Done Checklist) apply to Codex-written code exactly as to Claude-written code.
