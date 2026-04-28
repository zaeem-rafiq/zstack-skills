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

## Handoff

"Root cause identified. Ready to fix this with **tdd**? The acceptance criteria
are ready to become test cases."

## Anti-patterns

- Jumping to a fix without understanding the root cause
- Asking the user 15 questions before investigating anything yourself
- Blaming the user ("are you sure you did it right?")
- Fixing the symptom instead of the cause
- Not adding a regression test for the fix
