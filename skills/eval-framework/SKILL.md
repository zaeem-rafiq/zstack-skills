---
name: eval-framework
description: >
  Design and implement AI evaluation systems using the Hamel Husain methodology:
  error analysis → binary pass/fail evals → LLM-as-judge → production monitoring.
  Use this skill whenever building, shipping, or iterating on any LLM-powered feature —
  Ask Rafiq, Mirath education, Orchestrator agent, stock screening, tatheer, faraid
  calculator, or any new AI pipeline. Also trigger when someone says "eval", "evals",
  "how do I know this is working", "quality check", "LLM judge", "error analysis",
  "trace logging", "is this AI good enough to ship", "production monitoring for AI",
  "my AI is hallucinating", "how do I test this LLM", or when post-deployment QA
  reveals bugs in AI output. Trigger proactively when a PRD or feature involves an
  LLM pipeline and no eval plan exists — evals are as essential as the PRD itself.
  This skill pairs naturally with tdd (code assertions), write-a-prd (eval criteria
  in requirements), and triage-issue (error analysis feeds eval creation).
---

# Eval Framework

You build evaluation systems that catch AI failures before users do. The methodology
is Hamel Husain's 4-step loop, adapted for founder-led teams shipping fast.

## Philosophy

Evals are to LLM products what unit tests are to traditional software — except harder,
because LLM outputs are non-deterministic. A response can be factually correct but
tonally wrong, or sound confident while being completely hallucinated.

Vibe-checking IS a form of eval. But it stops scaling the moment you have more than
a handful of users. The goal is to systematize your intuition so software does what
your brain was doing — at scale, consistently, 24/7.

**Core principles:**
- Binary pass/fail beats scoring scales. Business decisions are binary: fix it or don't.
- Domain-specific failure modes beat generic metrics. "Did the stock screen match AAOIFI
  criteria" > "was the response helpful."
- Error analysis is the highest-leverage activity. More important than the LLM judge,
  more important than the observability tool.
- The PM/CEO owns error analysis. Engineers don't have full context on whether the
  product experience is good. You do.
- Evals are durable. They survive model swaps, framework changes, and prompt rewrites.

## The 4-Step Loop

### Step 1: Collect Traces

A trace is the complete record of a single interaction: user input → system processing
→ LLM calls → tool use → final output. Before you can evaluate anything, you need traces.

**What to log:**
- User's original query/input
- System prompt or context sent to the LLM
- Raw LLM response (before any post-processing)
- Tool calls and their results (if agent-based)
- Final output shown to the user
- Metadata: timestamp, user ID, session ID, model version, prompt version

**For Rafiq Labs products specifically:**
- Ask Rafiq: full conversation thread, madhab context, sources cited
- Stock screening: ticker, screening criteria applied, AAOIFI thresholds, pass/fail result
- Tatheer/purification: fund holdings evaluated, purification calculation steps, final amount
- Faraid calculator: family composition input, madhab selected, share calculations, PDF output
- Mirath AI education: question asked, explanation generated, citations
- Orchestrator: Linear issue input, Claude Code output, test results, git diff

**Minimum viable tracing:**
If you don't have a tracing system yet, start with structured JSON logging to a file or
Supabase table. You can build a proper observability pipeline later. The important thing
is that traces exist and are reviewable.

```
Trace storage priority:
1. Supabase table (already in stack) — structured, queryable
2. JSON log files — simple, exportable
3. Spreadsheet — Hamel literally does evals in Google Sheets. Don't overthink it.
```

### Step 2: Error Analysis (The Most Important Step)

This is where you learn what's actually broken. Most teams skip this. Don't.

**The process:**
1. Pull a sample of 30-50 traces (more if you have them, but start here)
2. Review each trace yourself — not an LLM, not an intern. YOU.
3. For each trace, make a binary judgment: PASS or FAIL
4. For each FAIL, write a short critique explaining WHY it failed
5. After labeling all traces, categorize the failures (open coding → axial coding)
6. Count the categories. Make a pivot table. This tells you what to fix first.

**Failure taxonomy template:**

| Category | Example | Type | Eval approach |
|----------|---------|------|---------------|
| Wrong calculation | Zakat computed at 2% instead of 2.5% | Deterministic | Code assertion |
| Wrong madhab applied | Hanafi rules used when user selected Shafi'i | Deterministic | Code assertion |
| Hallucinated source | Cited a fatwa that doesn't exist | Semi-deterministic | Code + LLM judge |
| Poor explanation | Technically correct but confusing to user | Subjective | LLM-as-judge |
| Missed escalation | Should have said "consult a scholar" but didn't | Subjective | LLM-as-judge |
| Format error | PDF export missing wasiyyah section | Deterministic | Code assertion |

**After categorization:**
- Rank categories by frequency
- Fix the top 1-2 categories FIRST
- Write evals for those categories
- Then move to the next set

### Step 3: Build Evals

Two types of evaluators for two types of failures:

#### Code-Based Assertions (for deterministic failures)

Use when there's a clear right/wrong answer. These are fast, cheap, and reliable.

```
Examples:
- Zakat rate MUST be 2.5% (not 2%, not 3%)
- Faraid shares MUST sum to 1.0 (or the correct denominator)
- Stock screening: financial ratios MUST use the correct AAOIFI thresholds
- Date/time parsing: "July 4th" MUST resolve to 2026-07-04
- PDF export: all sections MUST be present in output
```

Structure assertions as:
```
Feature: [What capability]
  Scenario: [Specific case]
    Given: [Input/context]
    When: [Action taken]
    Then: [Expected output — binary, checkable]
```

Pair naturally with the `tdd` skill — when building a new AI feature via TDD, the
assertions you write ARE your code-based evals.

#### LLM-as-Judge (for subjective failures)

Use when the judgment requires nuance — tone, quality of explanation, when to escalate.

**Building a judge that works:**

1. Start with a SIMPLE prompt. Don't over-engineer.
```
You are evaluating a [product]'s response to determine if [specific failure mode].
Return ONLY true or false.

true = the response has this problem
false = the response does not have this problem

[Optionally: 2-3 examples of pass and fail]
```

2. BINARY SCORES ONLY. No 1-5 scales. No percentages. Pass or fail.
   - With binary, you verify two things: does it catch real failures? does it pass good outputs?
   - With 1-5, you verify five things. That's 5x the calibration work for zero extra value.

3. Test the judge against your human labels from Step 2.
   - You already labeled 30-50 traces. Those are your ground truth.
   - Run the judge on those same traces.
   - Measure True Positive Rate (catches real failures) and True Negative Rate (passes good outputs).
   - If TPR or TNR is below ~85%, iterate on the judge prompt.

4. Deploy the validated judge on new traces at scale.

**Judge prompt template for Rafiq Labs:**
```
You are evaluating an Islamic finance AI assistant's response.

Task: Determine if the response contains a [SPECIFIC FAILURE MODE].

Rules:
- [Rule 1 specific to this failure mode]
- [Rule 2]
- [Rule 3]

Return ONLY: true (has the problem) or false (no problem)
```

### Step 4: Deploy + Monitor

Once your judges are validated:

1. Run judges on all new production traces automatically
2. Calculate error rates per failure category
3. Set alerts when error rates spike (e.g., > 10% failure on any category)
4. Do manual re-labeling periodically (weekly or bi-weekly)
   - This catches judge drift and discovers NEW failure categories
   - The manual round feeds back into Step 2, creating a continuous loop

**The continuous loop:**
```
Ship feature → Collect traces → Error analysis → Build evals →
Deploy judges → Monitor → Discover new failures → Error analysis → ...
```

## When to Use This Skill

### Proactive triggers (before something breaks)
- Writing a PRD for an AI feature → add eval criteria to the PRD
- About to ship an AI feature → "what are our evals?"
- Switching models or updating prompts → run existing evals before and after
- New product launch (Mirath Hajj window) → eval plan alongside launch plan

### Reactive triggers (after something breaks)
- User reports wrong output → triage-issue + create eval for that failure mode
- Post-deployment QA finds bugs → categorize, then build evals
- Error rate spikes in production → error analysis on recent traces

## Integration with Other Skills

| Skill | Integration |
|-------|-------------|
| `write-a-prd` | Add "Eval Criteria" section to every PRD |
| `tdd` | Code assertions ARE deterministic evals |
| `triage-issue` | Root cause analysis feeds eval creation |
| `prd-to-issues` | Create eval tickets alongside feature tickets |
| `grill-me` | Challenge: "what's your eval plan?" |

## Anti-Patterns

- **Generic metrics obsession**: "Helpfulness: 4.2/5" tells you nothing actionable
- **Eval theater**: Having evals that never fail (if nothing fails, your evals aren't specific enough)
- **Outsourcing error analysis**: Having an LLM do ALL your trace review. You lose product insight.
- **Scoring scales**: 1-5 creates calibration nightmares and isn't actionable
- **One-and-done**: Building evals once and never updating them. Failure modes evolve.
- **Building judges before error analysis**: You can't judge what you don't understand
- **Skipping trace infrastructure**: "We'll add logging later." No. Traces first.

## Quick Start Checklist

For any AI feature about to ship:

- [ ] Traces are being logged (user input, LLM response, tool calls, final output)
- [ ] You've personally reviewed 30+ traces and labeled pass/fail
- [ ] You've written critiques for every failure
- [ ] Failures are categorized and counted (pivot table)
- [ ] Top 2-3 failure categories have evals (code assertions or LLM judges)
- [ ] Judges are validated against your human labels (TPR/TNR > 85%)
- [ ] Evals run automatically on new traces
- [ ] You have a schedule for periodic manual re-labeling

## Environment Notes

### Claude.ai
- Use this skill conversationally: walk through the 4-step loop together
- Create eval criteria as markdown files in `/mnt/user-data/outputs/`
- Build judge prompts interactively and test on example traces

### Claude Code / Orchestrator
- Integrate code assertions into test suites (pytest, Jest, XCTest)
- Add LLM judge calls as CI/CD gates
- Store judge prompts in the repo alongside the features they evaluate
- Run evals in the Orchestrator pipeline before pushing to main
