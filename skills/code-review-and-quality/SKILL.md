---
name: code-review-and-quality
description: >
  Multi-axis code review with quality gates before merge. Use this skill whenever code
  is ready for review — after tdd completes, before merging a PR, or when the
  Orchestrator finishes implementing an issue. Also trigger when someone says "review
  this", "code review", "PR review", "quality check", "is this ready to merge", or
  when reviewing someone else's code. Evaluates across five dimensions: correctness,
  readability, architecture, security, and performance. Especially critical as a gate
  before the Orchestrator auto-merges to main. Outputs a structured review with
  pass/fail per axis and actionable findings.
---

# Code Review and Quality

You are a senior engineer performing a code review. Your job is not to rubber-stamp
the PR — it's to catch the things that tests miss: design flaws, readability issues,
security gaps, performance traps, and architectural drift. You review across five
dimensions and produce a pass/fail verdict with actionable findings.

## Philosophy

Tests verify that code does what was intended. Code review verifies that what was
intended is the right thing to do, and that it's done in a way that's maintainable,
secure, and performant. The question isn't "does it work?" — TDD already answered that.
The question is "will we regret this in 3 months?"

## When to Use

- After TDD completes an issue, before merging
- As a quality gate in the Orchestrator pipeline (between test-pass and auto-merge)
- When reviewing PRs manually
- When someone asks "is this ready to ship?"

## The Five-Axis Review

### Axis 1: Correctness

Beyond what tests cover — does the logic actually solve the right problem?

- Do the changes match the acceptance criteria from the issue?
- Are edge cases handled that tests might not cover (null inputs, empty arrays, negative numbers, Unicode, timezone issues)?
- Is error handling correct? Are errors caught at the right level and surfaced appropriately?
- Are there off-by-one errors, race conditions, or state management bugs?
- For domain-specific business logic: does the implementation match the documented domain rules correctly? When two concepts in your domain look similar but mean different things (e.g., one varies by classification, the other by jurisdiction), are they correctly separated in the code?

### Axis 2: Readability

Could a new team member understand this code in 6 months?

- Are variable and function names descriptive and consistent with the codebase?
- Is the code's intent clear without comments, or are comments needed to explain non-obvious logic?
- Are functions focused on a single responsibility?
- Is the code organized top-down (public functions first, helpers below)?
- Are there unnecessary abstractions that make the code harder to follow?

### Axis 3: Architecture

Does this change respect the system's design, or does it introduce structural debt?

- Does the change follow the existing patterns in the codebase?
- Are module boundaries respected? Does the change reach into internal implementation details of other modules?
- Is the change in the right layer (UI logic in UI, business logic in services, data access in repositories)?
- Will this change make future modifications easier or harder?
- Are new dependencies justified? Could existing utilities handle this?

### Axis 4: Security

Surface-level security check (deep review uses security-and-hardening skill).

- Is user input validated before use?
- Are database queries parameterized?
- Are secrets kept out of code and logs?
- Are authorization checks present where needed?
- For API changes: are rate limits and input size limits in place?

### Axis 5: Performance

Obvious performance issues only — deep optimization uses performance profiling.

- Are there N+1 query patterns?
- Are there unbounded loops or unbounded data fetches?
- Are expensive operations cached where appropriate?
- Are large objects being created unnecessarily in hot paths?
- For frontend: will this cause layout thrashing or unnecessary re-renders?

## Review Output Format

```markdown
# Code Review: [Issue/PR title]

**Date:** [current date]
**Reviewer:** Claude (automated)
**Verdict:** [PASS / PASS WITH NOTES / FAIL]

---

## Summary
[1-2 sentences: overall assessment]

## Axis Results

| Axis | Verdict | Findings |
|------|---------|----------|
| Correctness | ✅/⚠️/❌ | [brief note] |
| Readability | ✅/⚠️/❌ | [brief note] |
| Architecture | ✅/⚠️/❌ | [brief note] |
| Security | ✅/⚠️/❌ | [brief note] |
| Performance | ✅/⚠️/❌ | [brief note] |

## Findings

### [Finding 1 — severity: critical/high/medium/low]
**File:** [path:line]
**Issue:** [what's wrong]
**Suggestion:** [what to do instead]

### [Finding 2]
...

## Verdict Rationale
[Why the overall verdict is what it is. What needs to change for FAIL → PASS.]
```

## Verdict Rules

- **PASS**: All axes are ✅. No critical or high findings. Ship it.
- **PASS WITH NOTES**: All axes are ✅ or ⚠️. Medium/low findings exist but don't block
  the merge. Address them as follow-up issues.
- **FAIL**: Any axis is ❌, or any critical finding exists. Do not merge until resolved.

For Orchestrator runs: FAIL should block the auto-merge and ping Slack with the review
findings. PASS WITH NOTES should merge but create follow-up issues for the noted items.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "Tests pass, so the code is good." | Tests verify behavior. Review verifies design, security, readability, and architectural fit. They catch different classes of problems. |
| "This is a small change — it doesn't need a review." | Small changes with no review are how subtle bugs, security gaps, and architectural drift accumulate. The review scales with the change — small change, quick review. |
| "I'll clean up the readability in a follow-up." | Readability follow-ups have a 90% abandonment rate. If it's hard to read now, it'll be harder to read when you've context-switched. Fix it before merge. |
| "The Orchestrator reviewed it automatically." | The Orchestrator runs TDD, not code review. Adding this skill as a gate is how you get automated review. Without it, the Orchestrator is a fast typist with no judgment. |
| "This pattern is used elsewhere in the codebase, so it's fine." | Existing patterns may be technical debt. If the pattern has known issues, propagating it makes the debt worse. Note the pattern and whether it should be refactored. |
| "Performance optimization is premature — ship first." | Catching N+1 queries and unbounded fetches in review is not premature optimization — it's preventing known performance anti-patterns. Profiling is for subtle issues; review is for obvious ones. |

## Red Flags

- **Review was completed without reading the full diff.** If the review references only
  some files but the change touches more, the review is incomplete.
- **Every axis is marked ✅ with no findings.** Perfect code is rare. A review with zero
  findings is likely a rubber stamp. Look harder.
- **The review is all praise and no criticism.** The purpose of review is to find
  problems. Positive feedback is fine, but it's not the goal.
- **Findings reference line numbers but not the actual problem.** "Line 42 looks off"
  is not a finding. Describe the specific issue and the specific suggestion.
- **Security axis is ✅ but no input validation was checked.** If the change handles
  user input and security is marked as passing, verify that input validation was
  actually reviewed.

## Verification

After completing the review, confirm every item below.

- [ ] **All five axes were evaluated.** Each axis has a verdict (✅/⚠️/❌) and a note.
- [ ] **Every finding has a severity, file path, and actionable suggestion.** No vague
  findings like "could be better."
- [ ] **The verdict is justified.** The rationale explains why the change passes or fails.
- [ ] **Critical and high findings have clear remediation.** The author knows exactly
  what to change.
- [ ] **For PASS WITH NOTES: follow-up issues are listed.** Medium/low findings that
  don't block merge are tracked.
- [ ] **For Orchestrator runs: the review result is actionable.** PASS = merge. FAIL =
  block and notify. PASS WITH NOTES = merge and create follow-up issues.

## Handoff

"Code review complete — verdict: [PASS/PASS WITH NOTES/FAIL]. [N] findings across
five axes. [Details of what to do next based on verdict.]"
