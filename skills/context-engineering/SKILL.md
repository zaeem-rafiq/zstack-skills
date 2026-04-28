---
name: context-engineering
description: >
  Feed AI agents the right information at the right time to maintain high output quality.
  Use this skill whenever starting a new session, switching tasks, noticing output quality
  degradation, or setting up a project for AI-assisted development. Also trigger when
  someone says "context", "CLAUDE.md", "rules file", "the agent doesn't know about",
  "start of session", "context window", "lost context", or when an agent produces
  output that misses project-specific constraints. Covers CLAUDE.md design, memory
  edits, MCP context, hierarchical context packing, and the art of giving agents exactly
  what they need without overwhelming the context window.
---

# Context Engineering

You are a context architect. Your job is to ensure that AI agents — whether Claude.ai
sessions, Claude Code, or the Orchestrator — have the right information at the right
time to produce high-quality output. Too little context and the agent guesses wrong.
Too much context and the agent drowns in noise. The skill is in the curation.

## Philosophy

Context is the agent's working memory. Every token of context you provide displaces a
token of reasoning capacity. The goal is maximum signal per token: the agent should know
everything it needs and nothing it doesn't.

This is especially critical for Rafiq Labs where domain knowledge (Islamic finance,
madhab distinctions, AAOIFI standards) is specialized and easy to get wrong. An agent
without the right context will conflate methodology with madhab, use the wrong nisab
threshold, or ignore the screening-vs-purification boundary. Context engineering prevents
these errors at the source.

## When to Use

- At the start of any new project or feature
- When setting up CLAUDE.md or rules files
- When an agent produces output that ignores known constraints
- When onboarding a new tool or MCP server
- When the Orchestrator processes issues in a domain it hasn't worked in recently
- When context window limits are approaching

## The Context Hierarchy

Context is organized in layers, from most persistent to most ephemeral:

### Layer 1: Identity — CLAUDE.md / Rules File

The project's permanent context. Loaded automatically at the start of every session.
This is where you encode:

- **Project overview.** What is this? Who is it for? What stack?
- **Architecture constraints.** Key patterns, boundaries, naming conventions.
- **Domain rules.** The screening-vs-purification boundary. Madhab definitions.
  AAOIFI compliance requirements.
- **Workflow conventions.** Always assign Linear issues to a project. Always use TDD.
  Always run the skill chain.
- **Tool configuration.** MCP servers, API keys locations, deployment targets.
- **What to never do.** Hard constraints that prevent common agent mistakes.

CLAUDE.md should be under 500 lines. If it's longer, extract domain knowledge into
reference files that are loaded on demand.

### Layer 2: Memory Edits — Cross-Session Persistence

Memory edits (Claude.ai's memory system) persist across sessions and encode:

- **User identity and role.** CEO, co-founder, Columbia EMBA.
- **Active priorities.** What's top of mind right now (Mirath launch, Hajj deadline).
- **Standing instructions.** Skill chain routing, workflow preferences.
- **Project status.** Where each product is in its lifecycle.

Memory edits should be concise, factual, and updated when priorities shift. Stale
memory edits are worse than no memory — they send the agent down wrong paths.

### Layer 3: Session Context — Conversation + Uploaded Files

The current conversation plus any files, PRDs, or code loaded into the session.
This is the most detailed layer but the most ephemeral.

- **Front-load critical constraints.** Put the most important information in the first
  message. Agents pay more attention to early context.
- **Reference, don't repeat.** If a PRD is already in memory or a file, reference it
  by name rather than pasting it again.
- **Prune when switching tasks.** If you shift from Mirath to Rafiq B2B mid-session,
  explicitly state the switch so the agent deprioritizes Mirath context.

### Layer 4: Tool Context — MCP + Web Search + File System

Context gathered dynamically through tool use:

- **MCP servers** provide live data from Linear, Slack, GitHub, Supabase.
- **Web search** provides current information the model doesn't have.
- **File system access** (Claude Code) provides codebase context.

Tool context is expensive (tokens) but high-fidelity (real data vs. training data).
Use it for verification and current state, not for general knowledge.

## Context Packing Strategies

### For Claude.ai Sessions (Your daily workflow)

The standing instruction to ask which workflow (Dev/Marketing/Creative/Product/Meta) at
the start of each chat is itself a context engineering technique — it routes the agent
to the right skill chain and mental model.

Additional strategies:
- Keep memory edits current. After major milestones (Mirath launch, YC application),
  update memory to reflect new priorities.
- Use the RAFIQ_CONTEXT.md pattern: a shared document that encodes the full project
  state, loadable at the start of any session to eliminate re-establishment overhead.
- When pasting code or files, include the file path and a one-line description of what
  it is and why you're sharing it.

### For Claude Code Sessions

- CLAUDE.md is auto-loaded. Keep it lean and correct.
- Use `.claude/` directory for supplementary rules files that are loaded on demand.
- In the Orchestrator pipeline, each issue should contain enough context in its body
  that the agent can work without additional human input.

### For Orchestrator Runs

The Orchestrator processes issues headlessly. Each issue must be self-contained:
- Context section explains WHY this issue exists
- Technical notes reference specific files and patterns
- Acceptance criteria are specific enough to verify programmatically
- The project assignment routes to the correct codebase

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The agent should know this from training data." | Training data is stale, incomplete, and generic. Your project's specific constraints — madhab boundaries, Orchestrator conventions, Supabase RLS patterns — aren't in training data. Provide them explicitly. |
| "I'll add context when the agent gets confused." | Reactive context is expensive — the agent has already produced wrong output that needs to be corrected. Proactive context prevents the wrong output from being generated. |
| "The CLAUDE.md is already long enough." | If CLAUDE.md is over 500 lines, it's too long. Extract reference material into separate files. The CLAUDE.md should contain rules and constraints, not tutorials. |
| "Memory edits are set — I don't need to update them." | Memory edits reflect priorities, and priorities change. Stale memory sends agents down outdated paths. Review and update after major milestones. |
| "The issue body has enough context." | For Orchestrator runs, the issue body IS the context. If it's missing the "why," the implementing agent will make assumptions. Add a Context section to every issue. |

## Red Flags

- **An agent produces output that ignores a known constraint.** This means the constraint
  isn't in the agent's context. Add it to CLAUDE.md or memory edits.
- **An agent conflates methodology with madhab.** The screening-vs-purification boundary
  isn't in context. Add the domain rule explicitly.
- **The same context is re-established at the start of every session.** This is a signal
  that the context should be in memory edits or CLAUDE.md, not in conversation.
- **The agent asks for information that's available in a connected tool.** This means
  the agent doesn't know the tool exists or how to use it. Add tool awareness to
  CLAUDE.md.
- **CLAUDE.md hasn't been updated in over a month.** Projects evolve. If the rules file
  is stale, the agent is working from outdated constraints.

## Verification

After setting up or updating context for a project, confirm every item below.

- [ ] **CLAUDE.md exists and is under 500 lines.** Contains project overview, architecture
  constraints, domain rules, workflow conventions, and hard boundaries.
- [ ] **Memory edits are current.** Reflect active priorities, not last month's priorities.
- [ ] **Domain-specific rules are explicit.** Screening vs. purification boundary.
  Madhab definitions. AAOIFI compliance. Whatever is specific to the project's domain.
- [ ] **Issues are self-contained for Orchestrator runs.** Each issue has Context,
  Acceptance Criteria, and Technical Notes.
- [ ] **Connected tools are documented.** The agent knows which MCP servers are available
  and what they provide.
- [ ] **A test interaction produces correct output.** Start a fresh session and verify
  that the agent's first response demonstrates awareness of project constraints.

## Handoff

"Context engineering complete — [project name] is configured for AI-assisted
development. CLAUDE.md is [N] lines, memory edits are current, and a test interaction
confirmed the agent is working with the right constraints."
