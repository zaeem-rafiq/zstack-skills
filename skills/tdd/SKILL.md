---
name: tdd
description: >
  Build features using strict test-driven development: red-green-refactor. Use this
  skill whenever someone says "TDD", "test first", "red green refactor", "write tests
  then implement", or when an issue from prd-to-issues is ready to build. Also trigger
  when someone asks to implement a feature and you want to suggest a disciplined
  approach — offer TDD as the method. Each cycle writes ONE failing test, makes it pass
  with minimal code, then refactors. Vertical slices, behavior-based tests, no mocking
  unless necessary. Works in any language/framework.
---

# TDD

You build features one test at a time. The rhythm is sacred: **Red → Green → Refactor.**
No exceptions. No skipping ahead. No writing implementation before the test exists.

## Philosophy

TDD isn't about testing — it's about design. Writing the test first forces you to think
about the interface before the implementation. It forces small steps. It forces you to
know what "done" looks like before you start typing.

The discipline matters most when you're tempted to skip it — when the implementation
seems obvious, when you're "just adding one thing," when you're in a hurry. That's
exactly when bugs breed.

## The Cycle

### 🔴 Red: Write ONE failing test

Write a single test that describes one behavior you want. Run it. Watch it fail.
The failure message should be clear and specific — if it says "undefined is not a
function," your test isn't good enough yet.

Rules for the red step:
- ONE test. Not two. Not "a few related ones." One.
- Test behavior, not implementation. "User can filter stocks by halal status" not
  "filterStocks function returns array."
- The test name should read like a sentence: `test_zakat_calculation_uses_hanafi_nisab_threshold`
- Start from the outside in — what does the user/caller see? Work inward.

### 🟢 Green: Make it pass with minimal code

Write the absolute minimum code to make the test pass. This is not the time for
elegance. Hardcoded return values are fine. Ugly conditionals are fine. The ONLY
goal is a green test.

Rules for the green step:
- Don't write code the test doesn't demand
- Don't refactor yet — resist the urge
- Don't write the next test yet
- If you need to change an existing test to make the new one pass, something is wrong
  with your design — stop and think

### 🔄 Refactor: Clean up while green

Now — and only now — improve the code. Extract functions. Remove duplication. Improve
names. The tests are your safety net.

Rules for the refactor step:
- All tests must stay green throughout
- Change structure, not behavior
- If you're adding behavior, you need a new red test first
- This is also when you refactor the tests themselves — remove duplication, improve
  clarity

## Working with Issues

When building from a prd-to-issues ticket:

1. Read the acceptance criteria — each criterion is roughly one TDD cycle
2. Start with the simplest criterion (the tracer bullet through the feature)
3. Work through the criteria one by one, each as a red-green-refactor cycle
4. When all criteria have passing tests, the issue is done

## Practical Guidance

### Choosing what to test first

Start with the **happy path's simplest case**. Not the edge cases. Not the error
handling. The most basic version of "it works."

For a zakat calculator:
1. First test: "calculates zakat on cash above nisab at 2.5%"
2. Second test: "returns zero when cash is below nisab"
3. Third test: "uses gold nisab threshold for Hanafi madhab"
4. Fourth test: "uses different nisab threshold for Ja'fari madhab"

Each test adds ONE new behavior.

### When to mock (and when not to)

Mock only when:
- The real dependency is slow (network calls, databases)
- The real dependency is non-deterministic (time, random)
- The real dependency doesn't exist yet

Don't mock:
- Your own code (if you're mocking your own modules, your design has coupling problems)
- Simple data transformations
- Anything you can run quickly with real data

### Test structure

Every test follows Arrange → Act → Assert:

```
// Arrange: set up the preconditions
// Act: do the thing
// Assert: verify the result
```

One assert per test is ideal. Two is sometimes acceptable. Three means you're testing
multiple behaviors — split the test.

## Language/Framework Detection

Detect the project's language and testing framework from the codebase:

| Language | Look for | Default framework |
|----------|----------|-------------------|
| Swift | *.swift, Package.swift | XCTest |
| Python | *.py, pyproject.toml | pytest |
| TypeScript/JS | *.ts, package.json | Jest or Vitest |
| Go | *.go, go.mod | built-in testing |
| Rust | *.rs, Cargo.toml | built-in #[test] |

Follow the project's existing test patterns. If tests exist, match their style.
If no tests exist, set up the simplest possible test infrastructure first.

## Environment Detection

### Claude.ai
- TDD works best in Claude Code where you can run tests. In Claude.ai, you can:
  - Write the test and implementation code as files
  - Use the code execution environment to run tests if the language supports it
  - Save files to `/mnt/user-data/outputs/`
  - Walk through the TDD cycle conversationally

### Claude Code
- Run tests after each step: `🔴 Red` → run and confirm failure → `🟢 Green` → run
  and confirm pass → `🔄 Refactor` → run and confirm still passing
- Commit after each green-refactor cycle with a descriptive message
- Use the project's test runner

## Common Rationalizations

These are excuses that surface mid-implementation. When you catch yourself reaching
for one, stop — the rebuttal is the correct path.

| Rationalization | Reality |
|---|---|
| "This is a simple UI change, no test needed." | UI regressions are the #1 user-facing bug type. A snapshot or interaction test takes 30 seconds to write and catches the next person's accidental breakage. |
| "I'll add tests after the feature works." | Tests-after verify what code *does*. Tests-first verify what code *should do*. You lose the design signal, and "after" rarely comes — especially in a headless Orchestrator run. |
| "The Orchestrator will catch it in CI." | CI catches build failures and lint errors. It does not catch logic bugs, wrong business rules, or silent data corruption. TDD catches those. |
| "Mocking the Supabase/API client is too complex." | If mocking is painful, the module boundary is wrong. Write a thin adapter, mock the adapter. If test helpers don't exist, creating them IS the refactor step. |
| "I already know the implementation, writing the test first is redundant." | If you know the implementation, the test will take 60 seconds. If you're wrong about the implementation, the test will save you 60 minutes. Either way, write it first. |
| "This is just a refactor, existing tests cover it." | Run the tests. If they pass, great — the refactor is safe. If you haven't run them, you don't know that. The green bar is the proof, not your confidence. |
| "I need to spike/prototype first, then backfill tests." | Spikes are for learning, not shipping. If you learned what you need, delete the spike and rebuild with TDD. Spike code that survives into production always rots. |
| "There's a deadline — testing slows me down." | Untested code ships bugs during your highest-traffic window. Hajj season, Ramadan launch, investor demo — those are exactly when you cannot afford regressions. |

## Red Flags

Signs that TDD discipline is slipping. If you observe any of these in your own
output, **stop and course-correct before continuing.**

- **Implementation exists but no test file was created or modified.** This means the
  red step was skipped entirely. Delete the implementation and start over with a test.
- **All tests pass on the first run.** Suspicious. Either the test isn't asserting
  what you think, or you wrote implementation before the test. Deliberately break the
  test to confirm it catches failures.
- **Test names describe implementation, not behavior.** `test_filterStocks_returns_array`
  is an implementation test. `test_user_sees_only_halal_stocks_after_filtering` is a
  behavior test. Rename and reconsider what you're actually verifying.
- **Multiple acceptance criteria addressed in a single test.** This means you're taking
  steps that are too large. Split into one test per criterion.
- **Refactor step was skipped after green.** The commit history should show
  red → green → refactor rhythm. Three greens in a row with no refactor means
  duplication and structural debt are accumulating.
- **Tests mock internal modules.** Mocking your own code means your test is coupled
  to implementation structure, not behavior. It will break on any refactor even when
  behavior is unchanged.
- **Test file was committed but was never run.** In Claude Code, the terminal output
  must show the test runner executing. In Orchestrator runs, the CI log must show the
  test suite. No run = no evidence = not done.

## Verification

After completing all TDD cycles for an issue, confirm every item below. Each checkbox
requires **evidence** — paste the output, attach the screenshot, or reference the
commit hash. "I checked and it's fine" is not evidence.

- [ ] **All tests pass.** Paste the test runner output showing the full suite green.
- [ ] **No skipped or pending tests.** Search for `.skip`, `.only`, `xit`, `xtest`,
  `@pytest.mark.skip`, `pending` — none should exist in the final commit.
- [ ] **Each acceptance criterion has a corresponding test.** List the mapping:
  criterion → test name.
- [ ] **Coverage meets project threshold.** If a coverage tool is configured, paste
  the coverage report. If not configured, note that as a follow-up item.
- [ ] **Red step was verified for every test.** Each test was observed to fail before
  implementation was written. (In Claude Code, the terminal log shows the failure. In
  Orchestrator runs, the CI log shows it.)
- [ ] **Refactor step was performed.** At least one refactor cycle occurred. If the
  code was clean enough to skip refactoring, state what you reviewed and why no
  changes were needed.
- [ ] **Build succeeds.** Paste build output or CI green status.
- [ ] **Commit messages follow red-green-refactor rhythm.** Each commit is attributable
  to a TDD phase. No "WIP" or "fix tests" commits in the final history.

## Handoff

When all acceptance criteria have passing tests and the verification checklist is
complete:

"All tests passing. Verification checklist complete — evidence attached above.
This issue is done. Ready for the next issue, or want to review the code first?"

## Anti-patterns

- Writing all tests first, then all implementation (defeats the purpose of feedback)
- Testing implementation details instead of behavior
- Skipping the refactor step (technical debt accumulates)
- Giant tests that verify 10 things at once
- Mocking everything (your tests become a mirror of your implementation)
- Not running the test before writing implementation (how do you know it fails?)
