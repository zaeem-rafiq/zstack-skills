---
name: design-an-interface
description: >
  Generate 3 or more radically different interface designs for an API, module, CLI,
  or UI component. Use this skill whenever someone says "design it twice", "API options",
  "interface design", "explore different approaches", "what are my options", "how should
  I structure this API", or when a feature could be implemented in fundamentally different
  ways. Also trigger when someone is designing an interface (API, SDK, CLI, UI component)
  and seems locked into one approach — offer to explore alternatives before committing.
  The principle is "design it twice" (from A Philosophy of Software Design) — you can't
  know if your design is good unless you've compared it to alternatives.
---

# Design an Interface

You generate radically different interface designs so the user can make an informed
choice. Not variations on a theme — genuinely different approaches that make different
tradeoffs.

## Philosophy

From John Ousterhout's "A Philosophy of Software Design": you can't evaluate a design
in isolation. You need at least two alternatives to understand the tradeoffs you're
making. We go further — generate three or more, because the third option often reveals
something the first two missed.

"Interface" here means any boundary between components:
- API endpoints (REST, GraphQL, RPC)
- Function/method signatures
- CLI commands and flags
- SDK/library public API
- UI component props/contracts
- Database schema designs
- Module boundaries and responsibilities

## Process

### Step 1: Understand the contract

Before designing anything, clarify:
- **Who calls this?** (Human? Other code? External service?)
- **What do they need to accomplish?** (The job-to-be-done, not how)
- **What constraints exist?** (Performance, backward compatibility, platform limits)
- **What will change?** (What's likely to evolve — design for that flexibility)

Ask the user 2-3 questions max if the context is unclear.

### Step 2: Generate 3+ designs

Each design should be **genuinely different**, not cosmetic variations. They should
make different fundamental choices about:

- **Granularity**: Fine-grained many-method vs. coarse-grained few-method
- **Control**: Declarative ("what") vs. imperative ("how")
- **Coupling**: Tightly integrated vs. loosely coupled
- **Flexibility**: Simple-and-rigid vs. complex-and-flexible
- **Discoverability**: Explicit-and-verbose vs. concise-and-magical

For each design, provide:

```markdown
### Option [N]: [Evocative Name]

**Philosophy:** [One sentence — the core idea behind this approach]

**Interface:**
[Code showing the public API/interface — what the caller sees and uses]

**Example usage:**
[A realistic code example showing how this feels to use]

**Tradeoffs:**
- ✅ [Strength 1]
- ✅ [Strength 2]
- ⚠️ [Weakness 1]
- ⚠️ [Weakness 2]

**Best when:** [Scenario where this design shines]
```

### Step 3: Compare and recommend

After presenting all options, provide:

| Dimension | Option 1 | Option 2 | Option 3 |
|-----------|----------|----------|----------|
| Simplicity | ... | ... | ... |
| Flexibility | ... | ... | ... |
| Testability | ... | ... | ... |
| Learning curve | ... | ... | ... |

Then give your recommendation with reasoning — but make it clear the user should
choose based on their specific context.

## Tips for Generating Good Alternatives

- If your first instinct is a class-based OOP approach, make one option functional
- If your first instinct is REST, explore a command pattern or event-driven approach
- If your first instinct is a single method with options, explore a builder pattern
- Look at how other domains solve the same structural problem
- Ask: "What would this look like with zero configuration? With maximum configuration?"

## Environment Detection & Output

### Claude.ai
- Present the designs in conversation (they're usually best read inline)
- If the user wants to save, write to `/mnt/user-data/outputs/design-[name].md`

### Claude Code
- Present in conversation
- Save to `./docs/design-[name].md` if requested
- In Claude Code, you can also explore the existing codebase to make designs
  context-aware (matching existing patterns, types, conventions)

## Handoff

Once the user picks a direction:
"Great choice. Want me to run **write-a-prd** to formalize this, or jump straight
to **tdd** to start building?"

## Anti-patterns

- Three options that are really the same thing with different syntax
- Recommending without showing alternatives
- Only showing the "obvious" approach and two strawmen
- Designing without understanding who uses the interface and how
- Over-engineering all options — at least one should be the simplest thing that works
