---
name: boardroom
description: Run an AI advisory board debate on a strategic question using multiple expert personas and structured decision frameworks.
---
argument-hint: "<question>" [--quick] [--board <template>] [--framework <name>]
---

# Boardroom — AI Advisory Board Debate

Run a structured multi-round advisory board debate where distinct expert personas independently analyze a strategic question, debate each other's positions by name, and produce a synthesized recommendation.

## Parse Invocation

Extract the strategic question from the user's message or arguments. Parse optional flags:

- `--quick` → Quick mode: 3 advisors, Round 1 + Synthesis only (no rebuttals)
- `--board <id>` → Select a board template (e.g., `startup-growth`, `fundraising`, `ai-strategy`). Default: `startup-growth`
- `--framework <id>` → Apply a decision framework (e.g., `pre-mortem`, `swot`, `10-10-10`, `red-blue`, `regret-minimization`). Default: `standard`
- `--advisors <N>` → Override advisor count (3-8)

If no question is provided, ask: "What strategic question should the advisory board debate?"

List available boards if user asks: startup-growth, product-market-fit, fundraising, bootstrapper, market-expansion, technical-architecture, hiring-culture, pivot-decision, sustainability-impact, ai-strategy.

List available frameworks if user asks: standard, pre-mortem, swot, 10-10-10, red-blue, regret-minimization.

## Gather Business Context

Check if business context is provided in the message or as a file path. If not, ask these questions interactively:

1. Company name and what you sell
2. Stage (idea / pre-seed / seed / series-a / growth / bootstrapped)
3. Current revenue (MRR/ARR) and team size
4. Primary market and top 2-3 competitors
5. Key constraints (runway, hiring, technical, regulatory)

If the user says "skip" or "none," proceed without context but note advice will be generic. Format answers into a structured context block that every advisor receives.

## Select Board and Framework

Load the selected board template from `references/templates.md`. Default to "Startup Growth Board" (5 advisors).

In Quick mode, use only the first 3 advisors from the selected template.

Load framework modifier from `references/frameworks.md` if a non-standard framework is selected. For Red-Blue Team: assign first half of advisors to Blue Team (argue FOR), second half to Red Team (argue AGAINST).

## Confirm Setup

Before starting, confirm: "Convening the **[Board Name]** ([N] advisors) using the **[Framework]** framework in **[Full/Quick]** mode to debate: *'[question]'*. Ready to begin?"

Proceed on confirmation. Allow adjustments.

## Execute the Debate

### Round 1 — Position Papers

For each advisor sequentially:

1. Fully adopt the advisor's persona, voice, biases, and frameworks as described in the template
2. Apply any framework modifier to their analysis
3. Generate:
   - **Position paper** (2-4 paragraphs referencing the specific business context)
   - **Vote:** YES, NO, or CONDITIONAL (with conditions)
   - **Conviction:** 1-10 score
   - **Projections:** estimated cost, revenue impact, risk assessment, team impact — all with specific numbers grounded in context
4. Drop the persona completely before moving to the next advisor

Separate each advisor's section with a clear heading and horizontal rule.

### Round 2 — Rebuttals & Final Positions

**Skip entirely in Quick mode.**

For each advisor sequentially:

1. Re-adopt the advisor's persona
2. The advisor has now read ALL Round 1 position papers
3. Generate:
   - **Rebuttal** (2-3 paragraphs that MUST name specific advisors and engage with their specific arguments)
   - **Strongest disagreement:** which advisor and why (by name)
   - **Strongest agreement:** which advisor and why (by name)
   - **Mind changed:** yes/no with reason
   - **Final vote and conviction**
   - **Advice to founder:** 1-2 paragraphs of direct, actionable advice
4. Drop the persona before the next advisor

### Synthesis

Drop all personas. Act as a neutral, objective moderator. Generate:

- **Consensus** (2-3 paragraphs on agreements and disagreements, naming specific advisors)
- **Key tensions** (list the specific advisor-vs-advisor tensions)
- **Sharpest insight** (the single most valuable non-obvious takeaway)
- **Blind spots** (what the board collectively missed)
- **Vote shifts** (how many changed, who, and why)
- **Final recommendation** (2-3 paragraphs, decisive and actionable, not hedged)

Apply any synthesis modifier from the framework.

## Output Format

Follow the template in `references/output-format.md`. Output as a single continuous markdown document with these sections:

1. Header (question, date, board, framework, mode)
2. Executive Summary (synthesis recommendation — write last, place first)
3. Vote Summary Table
4. Round 1 Position Papers
5. Round 2 Rebuttals (Full mode only)
6. Synthesis
7. Final Recommendation

## Quality Rules — CRITICAL

These rules are non-negotiable for output quality:

- **Distinct voices**: Each advisor MUST sound genuinely different. The naysayer must challenge. The operator must name execution concerns. The capital allocator must cite financial metrics.
- **Real disagreement**: Unanimous agreement is a failure mode. At least one advisor must vote differently from the majority.
- **Specific numbers**: Projections must include actual dollar amounts, percentages, and timelines — not vague platitudes.
- **Named engagement**: In Round 2, advisors MUST reference each other by name and engage with specific arguments. "I disagree with the previous advisor" is unacceptable. "I fundamentally disagree with Diana Volkov's assessment that..." is correct.
- **Business grounding**: If context is provided, every position MUST reference the company's specific stage, revenue, team size, market, or constraints.
- **Decisive synthesis**: The final recommendation must take a clear position. "It depends" is not a recommendation.

## Follow-Up

After the report, offer:
- "Re-run with a different board template or framework?"
- "Ask a follow-up question to any specific advisor?"
- "Drill deeper into a specific tension or blind spot?"

Maintain advisor personas in context for follow-up questions.
