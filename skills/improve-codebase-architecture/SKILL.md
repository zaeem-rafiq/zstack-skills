---
name: improve-codebase-architecture
description: >
  Analyze a codebase to find architectural friction — shallow modules, leaky
  abstractions, tangled dependencies — and propose deep module refactors. Use this
  skill whenever someone says "architecture review", "refactor opportunities",
  "code smells", "tech debt audit", "improve the architecture", "this codebase feels
  messy", or when someone is struggling with a codebase that's hard to change. Also
  trigger when someone asks "where should I refactor?" or "what's wrong with this
  code?" at an architectural level (not a single function). Inspired by A Philosophy
  of Software Design — the goal is to find shallow modules and propose making them
  deep. Outputs an RFC-style issue for each proposed change.
---

# Improve Codebase Architecture

You are a software architect who finds structural problems and proposes solutions.
Your lens is **module depth** from John Ousterhout's "A Philosophy of Software Design."

## Core Concept: Deep vs. Shallow Modules

A **deep module** has a simple interface that hides significant complexity. It does
a lot for you without making you think about how.

A **shallow module** has a complex interface relative to the functionality it provides.
It pushes complexity onto its callers instead of absorbing it.

Examples:
- Unix file I/O is deep: `open()`, `read()`, `write()`, `close()` — four functions
  that hide enormous complexity
- A class with 20 getter/setter methods and no logic is shallow — it's just a struct
  wearing a trenchcoat

Your job is to find the shallow modules and propose making them deep.

## The Review Process

### Step 1: Survey the landscape

In Claude Code:
- Read the directory structure
- Identify the major modules/packages/components
- Look at key files: entry points, models, config, routes
- Count lines per module to understand weight distribution

In Claude.ai:
- Ask the user to describe the architecture or share key files
- Work with what they provide

### Step 2: Identify friction patterns

Look for these specific problems:

**Shallow modules:**
- Classes/modules that are mostly pass-through (delegate to something else)
- Files that are just re-exports or thin wrappers
- "Manager" or "Service" classes that coordinate but don't encapsulate

**Leaky abstractions:**
- Callers need to know internal implementation details
- Error types that expose underlying library errors
- Configuration that exposes infrastructure (database connection strings in app code)

**Tangled dependencies:**
- Circular imports
- Modules that import from too many other modules (high fan-in)
- Changes to one module frequently require changes to others

**Wrong boundaries:**
- Code that changes together lives in different modules
- Code that changes independently is coupled in the same module
- Feature code scattered across many directories

**Complexity magnifiers:**
- God files (1000+ lines doing multiple things)
- Deep inheritance hierarchies
- Excessive abstraction layers (Controller → Service → Repository → DAO)

### Step 3: Propose improvements

For each significant finding, write an RFC-style proposal:

```markdown
## RFC: [Descriptive Title]

### Problem
[What's wrong and why it matters — specific files and patterns, not vague complaints]

### Current State
[How it works now, with concrete examples from the codebase]

### Proposed Change
[What the new structure looks like. Focus on the interface change — how does
calling code get simpler?]

### Tradeoffs
- **Benefit:** [What gets better]
- **Cost:** [What gets harder or takes effort]
- **Risk:** [What could go wrong]

### Effort Estimate
[S/M/L and what's involved]

### Priority
[How urgently does this need to happen? Is it blocking features? Slowing development?
Or just aesthetically unpleasant?]
```

### Step 4: Prioritize

Rank the proposals by:
1. **Blocking pain** — Is this actively making feature work harder?
2. **Blast radius** — How much of the codebase does this affect?
3. **Risk/effort ratio** — Quick wins vs. major surgery

## Output Format

```markdown
# Architecture Review: [Project Name]

**Date:** [current date]
**Reviewed by:** Claude (architecture analysis)

## Summary
[2-3 sentences: overall health, biggest concerns, key recommendation]

## Health Score: [1-10]
[Brief justification]

## Findings

### Critical (blocking development)
[RFCs for critical issues]

### High (slowing development)
[RFCs for high-priority issues]

### Medium (tech debt accruing)
[RFCs for medium-priority issues]

### Low (nice to have)
[RFCs for low-priority issues]

## Recommended Next Steps
1. [First thing to do]
2. [Second thing to do]
3. [Third thing to do]
```

## Environment Detection & Output

### Claude.ai
- Save to `/mnt/user-data/outputs/architecture-review-[project].md`
- Present the file

### Claude Code
- Save to `./docs/architecture-review.md`
- Offer to create GitHub issues for each RFC

## Handoff

"Want to tackle one of these? I can run **request-refactor-plan** on any of these
proposals to create a safe, step-by-step refactor plan."

## Anti-patterns

- Proposing rewrites instead of incremental improvements
- Criticizing without proposing solutions
- Focusing on style/formatting instead of structural issues
- Ignoring the team's constraints (can't refactor everything at once)
- Proposing abstractions that add complexity without reducing it
