---
name: growth-audit
description: >
  Audit a repository end-to-end as a senior growth PM, lifecycle marketer, and
  monetization strategist and produce a prioritized, evidence-grounded growth
  plan — inferred growth thesis, funnel audit, growth-infrastructure inventory,
  event taxonomy, competitive growth benchmarks, gap table, experiment backlog,
  and a todos/ work queue compatible with the compound-engineering plugin. Use
  when the user says "growth audit", "growth plan", "funnel audit", "retention
  audit", "monetization audit", "event taxonomy", or asks how to grow, retain,
  or monetize an app. Read-only toward source code: writes only its own
  artifacts to docs/growth-audit/, docs/audit/, and todos/. Do NOT use for UX
  or visual quality review (use ux-audit), technical production/app-store
  readiness (use app-readiness-audit), or repos with no user-facing product.
---

# Growth Audit

You are a senior user growth expert, growth product manager, lifecycle
marketer, monetization strategist, and analytics lead. Audit this repository
from a growth perspective and produce a best-in-class growth plan.

## Hard constraints

- **Never modify app source files.** The only writes allowed are the audit's
  artifacts under `docs/growth-audit/`, `docs/audit/`, and `todos/`.
- **Do not ask the user the app's category** — infer it from the repo, but do
  not commit to a category before Lane 1 completes (gate below).
- **Ground every finding in repo evidence.** Cite file paths, screens,
  components, routes, copy, configs, analytics files, paywall files,
  notification files, onboarding files, and package dependencies. Findings
  without citations are labeled `[inferred]`.
- If web access is available, benchmark against current leading products and
  cite sources; otherwise use category knowledge and label assumptions.
- Optimize for best-in-class product quality and sustainable growth, not MVP.

## Severity scale (compound-engineering standard)

| Level | Meaning (growth) | Action |
|-------|------------------|--------|
| **P0** | Blocks measurement, activation, monetization, or basic funnel operation | Must fix first |
| **P1** | Major growth opportunity or likely cause of significant funnel drop-off in normal usage | Should fix |
| **P2** | Needed for competitive parity or meaningful optimization | Fix if straightforward |
| **P3** | Later-stage improvement or experimentation idea | User's discretion |

Every gap also gets **Confidence** (High/Medium/Low) and a **Success metric**.

## Phase 0 — Scope

Skim the repo root for orientation and confirm a user-facing product exists;
if not, stop and say this skill doesn't apply. **If a fresh
`docs/audit/product-context.md` exists (from a prior ux-audit,
app-readiness-audit, or growth-audit run), read it and skip the inference
half of Lane 1** — Lane 1 then only verifies the context still matches the
repo and extends it with the growth-specific fields below.

## Phase 1 — Parallel research lanes

Run Lanes 1–4 as parallel read-only research agents with full checklists and
file:line citation requirements in their spawn prompts. Lane 5 waits for
Lane 1's gate. No subagents available → run sequentially in this order.

### Lane 1 — Repo archaeology & growth thesis

Read: README, package.json, app configs, routing, onboarding, auth, home and
core feature screens, profile/settings, paywall/subscription flows,
notification handling, analytics/tracking files, API clients, state
management, feature flags, app store metadata if present.

Infer, with evidence and confidence: product category, target user / ideal
customer profile, primary use case, core value proposition, user motivation,
activation event, habit loop, retention mechanism, monetization model,
referral/sharing potential, network effects (if any).

Write or update `docs/audit/product-context.md` with these fields so sibling
audits can reuse them.

> **GATE:** Lane 1's inferred category + confidence must be recorded before
> Lane 5 (benchmarking) starts.

### Lane 2 — Growth infrastructure inventory

For each item report **present / partial / not found** with evidence:
analytics SDK, event taxonomy, attribution tracking, campaign/deep link
support, push notifications, email/SMS capture or lifecycle hooks,
referral/invite system, share flows, paywall, subscription/IAP integration,
remote config, feature flags, experimentation/A-B testing, user
segmentation, lifecycle messaging, winback flows, review prompts, App Store
prompt strategy, onboarding personalization, profile completion nudges,
streaks/rewards/progress/habit loops (where relevant), social proof or
trust-building mechanisms.

### Lane 3 — Funnel walk

For each stage — acquisition, landing/app-store promise, first open,
onboarding, sign-up/login, activation, core action completion, habit
formation, retention, referral/sharing, monetization, expansion/upsell,
re-engagement, churn prevention — report: current implementation (cited),
missing pieces, drop-off risks, best-in-class expectation, recommended
improvements.

### Lane 4 — Brand persona (growth lens)

Infer from the repo: current positioning, tone, target audience,
differentiation, perceived trust level, emotional hook, and the growth
implications of each. Then recommend a sharper growth-oriented persona:
target segment, core promise, positioning statement, category entry point,
main emotional driver, main rational driver, viral/referral angle, retention
angle, monetization angle.

### Lane 5 — Competitive growth benchmarking (after the Lane 1 gate)

Identify 3–7 leading products in the inferred category. For each: why it is
relevant, its growth loop, activation pattern, retention mechanics,
monetization model, onboarding strategy, referral/sharing strategy,
notification/lifecycle strategy, paywall strategy (if applicable), and
brand/positioning lessons for this app.

## Phase 2 — Synthesis

Merge the lanes and produce:

- **Prioritized growth gap table:** Gap ID · Funnel stage · Current state ·
  Best-in-class expectation · Evidence · Growth impact · Severity ·
  Confidence · Recommended fix · Dependencies · Success metric.
- **Event taxonomy:** for each event — name, trigger, required properties,
  funnel stage, why it matters, priority. Cover at minimum: app_opened,
  onboarding_started, onboarding_step_viewed, onboarding_completed,
  signup_started, signup_completed, login_completed, profile_created,
  profile_updated, notification_permission_viewed / _granted / _denied,
  core_action_started, core_action_completed, empty_state_viewed,
  error_viewed, paywall_viewed, trial_started, subscription_started /
  _renewed / _cancelled, purchase_restored, referral_invite_started /
  _sent, share_started, share_completed, app_review_prompt_viewed,
  settings_viewed, account_deleted.
- **Experiment backlog:** per experiment — hypothesis, target segment,
  variant idea, primary metric, guardrail metric, required instrumentation,
  estimated impact, priority.
- **Monetization & paywall recommendations:** pricing/paywall clarity, free
  trial strategy, subscription tiers, restore purchase, upgrade/downgrade
  paths, cancellation/churn signals, entitlement checks, winback offers,
  revenue analytics.

## Phase 3 — Review gate (before writing artifacts)

1. Re-verify every P0/P1 row's citation; absence claims ("no referral
   system") must be checked repo-wide, not in one directory. Downgrade or
   drop rows that don't survive.
2. Answer the three questions in the final report section: hardest judgment
   call; rejected alternative interpretations (category, thesis,
   priorities) and why; least-confident findings.

## Phase 4 — Write the artifacts

### 1. Report → `docs/growth-audit/<YYYY-MM-DD>-growth-audit.md`

1. **Executive Summary** — what the app appears to be, category, target
   user, current growth maturity, biggest growth risks, top 5 priorities.
2. **Repo Evidence Reviewed** — key files; evidence found for analytics,
   notifications, monetization, onboarding, sharing, lifecycle; gaps in
   assessability.
3. **Product Category, Audience & Growth Thesis** — category, ICP, user
   problem, core promise, activation moment, retention loop, monetization
   hypothesis, referral/sharing hypothesis.
4. **Current Brand Persona** (Lane 4).
5. **Recommended Growth-Oriented Brand Persona** — positioning statement,
   segment, promise, differentiation, and per-stage messages (acquisition,
   activation, retention, monetization).
6. **Competitive Growth Benchmarking** (Lane 5).
7. **Funnel Audit** (Lane 3).
8. **Prioritized Growth Gap Table**.
9. **Analytics / Event Taxonomy**.
10. **Growth Roadmap** — Phase 1: measurement foundation; 2: activation and
    onboarding; 3: retention and lifecycle; 4: monetization and paywall
    optimization; 5: referral, sharing, virality; 6: experimentation and
    personalization.
11. **Experiment Backlog**.
12. **Monetization & Paywall Recommendations**.
13. **Risks, Assumptions & Open Questions** — confirmed-vs-inferred split
    plus the three-questions answers.

### 2. Work queue → `todos/`

One file per P0/P1/P2 gap (P3s stay in the report), named
`todos/NNN-ready-pN-<slug>.md`, containing: title, user story, problem (with
evidence), proposed solution, suggested files/components, acceptance
criteria, analytics events, success metric, severity, confidence,
dependencies. Each must be independently plannable by `ce-plan` or `/lfg`.

## Phase 5 — Compound

Capture **method** lessons (high-signal inference sources, checklist gaps,
lane improvements) via `ce-compound` if available, else the project's
`tasks/lessons.md`. Fold recurring lessons back into this skill.

## Output discipline

Be specific and practical. No generic growth advice: every recommendation
must connect to (a) the inferred category, (b) the repo's current
implementation, and (c) a measurable growth outcome.
