---
name: triage-issue
description: >
  Investigate a bug report and produce a root cause analysis with a TDD fix plan.
  Use this skill whenever someone says "bug", "triage", "investigate", "broken",
  "not working", "error", "crash", "regression", or describes unexpected behavior in
  their app. Also trigger when someone pastes an error message, stack trace, or
  screenshot of broken UI. The output is a structured triage report that feeds
  directly into tdd for the fix. Don't just guess at the fix — investigate
  systematically, reproduce the issue, and identify the root cause before proposing
  a solution.
---

# Triage Issue

You are a senior engineer investigating a bug. Your job is NOT to guess at a fix —
it's to systematically narrow down the root cause, document what you find, and
produce a fix plan that feeds into TDD.

## Philosophy

Most bugs get "fixed" by guessing. The developer reads the error, thinks "oh it's
probably X," changes something, and deploys. Sometimes it works. Sometimes it
introduces a new bug. Sometimes the original bug comes back three weeks later.

Real triage is detective work: gather evidence, form hypotheses, test them, narrow
down, confirm. It takes slightly longer but produces durable fixes.

## The Triage Process

### Step 1: Gather the report

Get the facts. Don't start investigating until you have:
- **What happened**: The observed behavior (not the user's theory about why)
- **What was expected**: What should have happened instead
- **Reproduction steps**: Exactly how to trigger it (if known)
- **Environment**: Device, OS, app version, user account state
- **Frequency**: Always? Sometimes? Only on Tuesdays?
- **Screenshots/logs**: Any error messages, stack traces, console output

If the user gives a vague report ("it's broken"), ask targeted questions to fill gaps.
Don't ask for all of the above at once — prioritize what's missing.

### Step 2: Reproduce (if possible)

In Claude Code:
- Follow the reproduction steps in the codebase
- Read the relevant code paths
- Check recent commits that touch the affected area (`git log --oneline -20 -- path/`)
- Look at test coverage for the affected area

In Claude.ai:
- Walk through the code logic mentally based on what the user describes
- Ask the user to confirm specific behaviors ("When you tap X, does Y appear first?")
- Review any code files the user provides

### Step 3: Form hypotheses

Based on the evidence, list 2-4 possible root causes ranked by likelihood:

```
Hypothesis 1 (most likely): [description]
  Evidence for: [what supports this]
  Evidence against: [what contradicts this]
  Test: [how to confirm or rule out]

Hypothesis 2: [description]
  Evidence for: ...
  Evidence against: ...
  Test: ...
```

### Step 4: Narrow down

For each hypothesis, describe the test that would confirm or eliminate it. In Claude
Code, actually run those tests. In Claude.ai, guide the user through them.

### Step 5: Root cause confirmed

Once you've identified the root cause, document it clearly:
- What exactly is wrong (the mechanism, not the symptom)
- Why it wasn't caught (missing test? edge case? race condition?)
- What the fix should do (behavior change, not implementation details)

## Triage Report Template

```markdown
# Triage Report: [Bug Title]

**Date:** [current date]
**Severity:** [Critical / High / Medium / Low]
**Status:** Root cause identified

---

## Bug Summary
[One sentence: what's broken]

## Reproduction
1. [Step 1]
2. [Step 2]
3. [Observe: description of the bug]

**Expected:** [What should happen]
**Actual:** [What does happen]

## Investigation

### Evidence gathered
- [Log output, error messages, relevant code snippets]

### Hypotheses tested
1. **[Hypothesis]** — [Confirmed/Eliminated] — [Evidence]
2. **[Hypothesis]** — [Confirmed/Eliminated] — [Evidence]

## Root Cause
[Clear explanation of the mechanism. Why does this happen?]

## Why It Wasn't Caught
[Missing test? Untested edge case? Race condition? Integration gap?]

## Fix Plan
[What needs to change, described as behaviors not implementation]

### Acceptance Criteria for Fix
- [ ] [Testable criterion — the bug no longer occurs]
- [ ] [Testable criterion — regression test added]
- [ ] [Testable criterion — edge cases covered]

## Affected Areas
[Other code/features that might be impacted by the fix]
```

## Environment Detection & Output

### Claude.ai
- Save report to `/mnt/user-data/outputs/triage-[bug-name].md`
- Present to user

### Claude Code
- Save to `./triage/triage-[bug-name].md`
- If GitHub is available, offer to create as an issue with `bug` label
- Include relevant file paths and line numbers

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "The fix is obvious — I can skip the investigation." | Obvious fixes that skip investigation have a 40% regression rate. The "obvious" fix addresses the symptom, not the cause. Investigate anyway — it takes 10 minutes and prevents the bug from coming back. |
| "I can't reproduce it, so it's probably a user error." | Non-reproducible bugs are often race conditions, state-dependent issues, or environment-specific problems. "Can't reproduce" means "need more information," not "not a real bug." |
| "This is a minor UI glitch — not worth a full triage." | Minor UI glitches are user-facing. They erode trust. The triage can be lightweight (skip the hypothesis table), but still needs reproduction steps, root cause, and a regression test in the fix plan. |
| "The error message tells me exactly what's wrong." | The error message tells you what happened, not why. A null pointer exception tells you something was null. Triage tells you *why* it was null — missing validation? Race condition? Stale cache? Those have different fixes. |
| "We should just fix it and move on — we're behind schedule." | Fast fixes without root cause analysis are how bugs recur. The Orchestrator will implement your fix and move on, but if the root cause isn't addressed, the same bug surfaces in a different form next sprint. |
| "The test suite is green, so this can't be a real regression." | Green tests mean the tests pass, not that the code is correct. If the bug exists and tests are green, you have a *test gap* — which is itself a finding that belongs in the "Why It Wasn't Caught" section. |
| "I'll add the regression test later." | The regression test IS the fix verification. Without it, you can't prove the fix works, and you can't prevent the same bug from reappearing. The test comes first (TDD), then the fix. |

## Red Flags

Signs that the triage process is being violated. If you observe any of these, stop
and course-correct.

- **A fix is proposed before a root cause is identified.** Fixes without root causes
  are guesses. Complete the investigation before proposing solutions.
- **Only one hypothesis was considered.** Real triage considers multiple possibilities.
  If you jumped to the first explanation, you may be anchoring on the wrong cause.
  List at least 2 hypotheses.
- **The root cause explanation uses the word "probably" or "likely."** Root cause
  should be confirmed, not speculated. If you're not sure, you need more evidence.
  State what additional investigation is needed.
- **No reproduction steps in the report.** If you can't reproduce it, say so explicitly
  and document what you tried. Don't skip the section silently.
- **"Why It Wasn't Caught" section is empty.** Every bug that reaches users represents
  a gap in the quality process. Name the gap — missing test, missing edge case,
  integration not covered, monitoring blind spot.
- **The fix plan describes implementation, not behavior.** "Change line 42 to use
  parseInt" is implementation. "Ensure numeric inputs are parsed correctly when
  received as strings from the API" is behavior. The fix plan should be behavioral
  so TDD can drive the implementation.
- **Affected Areas section is empty.** Every bug fix has a blast radius. Other code
  paths that share the same pattern, similar logic in other features, downstream
  consumers of the affected function — name them.

## Verification

After completing the triage report, confirm every item below.

- [ ] **Reproduction steps are documented.** Either steps to reproduce, or explicit
  documentation of what was tried and why reproduction failed.
- [ ] **At least 2 hypotheses were considered.** Each with evidence for/against and
  a test to confirm or eliminate.
- [ ] **Root cause is confirmed, not speculated.** The explanation uses definitive
  language backed by evidence (code path, log output, test result).
- [ ] **"Why It Wasn't Caught" is filled in.** The quality gap is named.
- [ ] **Fix plan has 2+ acceptance criteria.** At minimum: the bug no longer occurs,
  and a regression test is added.
- [ ] **Affected areas are identified.** Other code/features that share the same
  pattern or could be impacted by the fix.
- [ ] **Severity is assigned.** Critical/High/Medium/Low with justification.
- [ ] **Report is saved to the correct output location.** File exists and is
  presentable.

## Handoff

When the triage report is complete and the verification checklist passes:

"Root cause identified — triage report complete, verification checklist passed.
Ready to fix this with **tdd**? The acceptance criteria are ready to become test
cases."

## Anti-patterns

- Jumping to a fix without understanding the root cause
- Asking the user 15 questions before investigating anything yourself
- Blaming the user ("are you sure you did it right?")
- Fixing the symptom instead of the cause
- Not adding a regression test for the fix
