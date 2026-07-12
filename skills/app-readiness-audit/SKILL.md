---
name: app-readiness-audit
description: >
  Audit a React mobile app repository (React Native, Expo, or similar) as a
  senior mobile architect and release engineer for production readiness — auth,
  editable profile, settings, notifications, StoreKit/IAP/subscriptions,
  analytics, crash reporting, deep linking, accessibility, security, app-store
  readiness, and testing — producing a status matrix, remediation plan, runtime
  verification checklist, and a todos/ work queue compatible with the
  compound-engineering plugin. Use when the user says "production readiness",
  "readiness audit", "app store readiness", "is this app ready to ship",
  "completeness audit", or "what's missing before launch". Read-only toward
  source code: writes only its own artifacts to docs/readiness-audit/,
  docs/audit/, and todos/. Do NOT use for UX/design quality (use ux-audit),
  growth/funnel strategy (use growth-audit), or reviewing a single diff.
---

# App Readiness Audit

You are a senior React mobile app developer, mobile platform architect,
release engineer, and app store readiness reviewer. Audit this repository for
basic app completeness, production readiness, monetization readiness,
analytics readiness, and best-in-class mobile fundamentals.

## Hard constraints

- **Never modify app source files.** The only writes allowed are the audit's
  artifacts under `docs/readiness-audit/`, `docs/audit/`, and `todos/`.
- **Do not ask the user the app's category** — infer it from the repo.
- **Cite evidence for every finding:** file paths, dependencies, components,
  screens, configs, native files, routes, API clients, service integrations.
- **Absence discipline:** when a feature is not found, report "Not found in
  inspected repo evidence" — never "definitely absent" — unless the repo
  clearly proves absence. Absence claims are checked repo-wide before the
  report is written.
- Include iOS StoreKit requirements; include Google Play Billing when the
  repo targets Android. Include usage analytics and event tracking.
- Optimize for best-in-class production readiness, not MVP. Recommendations
  must be practical for the identified React mobile stack.

## Status vocabulary

Every capability gets exactly one status: **Built** · **Partially built** ·
**Not found** · **Misconfigured risk** · **Unknown / needs runtime
verification**.

## Severity scale (compound-engineering standard)

| Level | Meaning (readiness) | Action |
|-------|---------------------|--------|
| **P0** | Blocks production release, monetization, auth, data safety, or core app usability | Must fix before release |
| **P1** | Major missing fundamental likely to harm users, reviews, retention, or revenue | Should fix |
| **P2** | Important for quality, reliability, or competitive expectations | Fix if straightforward |
| **P3** | Nice-to-have polish, scalability, or later-stage improvement | User's discretion |

## Phase 0 — Stack identification

In the main loop (fast, before dispatching lanes), identify: React Native vs
Expo vs other; navigation library; state management; backend/API client; auth
provider; analytics provider; push provider; IAP/subscription provider;
crash reporting provider; build/release tooling (EAS/Fastlane/CI);
environment/config management. Key files: README, package.json,
app.json/app.config.*, eas.json, ios/ and android/ (Info.plist,
AndroidManifest.xml), src|app|screens|components|navigation|services|hooks|
lib|utils, test files, CI files, env examples.

**If a fresh `docs/audit/product-context.md` exists** (from a sibling
ux-audit/growth-audit run), read it for category/audience context instead of
re-inferring; otherwise note category briefly — deep product inference is not
this skill's job.

## Phase 1 — Parallel audit lanes

Dispatch as parallel read-only agents, each returning status-matrix rows and
findings with citations. Pass each lane the stack summary from Phase 0.

### Lane 1 — Account, identity, profile, settings (areas A–C)

- **Account & identity:** sign up, login, logout, session persistence,
  password reset / magic link, social login (if applicable), account
  deletion, privacy policy and terms links, auth error handling.
- **Editable profile:** profile screen, edit flow, avatar/photo upload,
  name/username editing, bio/relevant fields, save/cancel states,
  validation, optimistic update or loading state, error handling, profile
  completion state, public/private rules (if relevant).
- **Settings & preferences:** account settings, notification preferences,
  privacy settings, subscription/billing management, theme/dark mode,
  language/localization, help/support/contact, legal links, delete account,
  logout.

### Lane 2 — Notifications & deep linking (areas D, H)

- **Notifications:** provider dependency, permission request flow,
  rationale screen, device token registration, backend token sync,
  foreground/background handling, deep linking from notifications,
  preferences, quiet hours/frequency control, analytics on prompt and
  engagement.
- **Navigation & deep linking:** navigation structure, authed vs unauthed
  routes, deep link config, universal/app links, notification deep links,
  deferred deep links, invalid route handling.

### Lane 3 — IAP, subscriptions, paywall (area E)

StoreKit integration (iOS), Google Play Billing (if Android target),
RevenueCat or equivalent abstraction, product/package configuration, paywall
screen, trial support, subscription purchase flow, one-time purchases,
restore purchases, receipt validation, server-side entitlement validation,
client entitlement checks, expiration/grace-period handling,
cancellation/refund/revocation handling, upgrade/downgrade/crossgrade,
billing error states, sandbox/test setup, paywall and purchase funnel
analytics.

### Lane 4 — Analytics & crash reporting (areas F, G)

- **Analytics:** SDK, event taxonomy, user identification, anonymous ID
  handling, consent/privacy handling, screen tracking, funnel tracking,
  error events, paywall/purchase events, notification events,
  profile/settings events, retention/cohort support, super/user properties,
  debug logging control.
- **Crash/error reporting:** Sentry/Bugsnag/Crashlytics or equivalent,
  error boundaries, global JS exception handling, native crash reporting,
  source maps, release/version tagging, user context, network/API error
  logging.

### Lane 5 — Onboarding, app state, accessibility (areas I–K)

- **Onboarding & activation:** first-run experience, permission sequencing,
  personalization questions, value proposition, progress indicators,
  skip/back behavior, activation event, post-onboarding empty state.
- **App state & data:** loading/empty/error states, offline behavior,
  retry, caching, pagination, optimistic updates, API timeout handling,
  token refresh, secure storage.
- **Accessibility:** labels, touch target sizes, dynamic text scaling,
  screen reader support, color contrast, reduced motion, keyboard behavior,
  focus management.

### Lane 6 — Security, release readiness, testing (areas L–N)

- **Security & privacy:** secure token storage, secrets not committed, env
  var handling, PII handling, privacy policy access, consent management,
  data delete/export paths, sensitive-data logging risk, API auth
  boundaries.
- **App store & release:** app icon, splash screen, bundle identifiers,
  version/build numbers, iOS permission descriptions, Android permissions,
  EAS/Fastlane/CI setup, build profiles, OTA update strategy (if Expo), App
  Store review risks, TestFlight/internal testing readiness,
  production/staging separation.
- **Testing & quality:** unit/component/integration/E2E tests, type
  checking, linting, formatting, CI checks, mocking strategy, coverage of
  purchases/auth/profile/notifications.

## Phase 2 — Synthesis

- **Status matrix:** feature area · expected best-in-class capability ·
  current status · evidence · risk · priority · recommended next step —
  covering all fourteen areas above.
- **Detailed findings:** Finding ID · area · status · evidence · why it
  matters · risk · severity · recommended fix · dependencies · runtime
  verification needed (if any).
- **Per-system plans**, each ending in acceptance criteria and analytics
  events:
  - *StoreKit/paywall/subscription plan* — architecture, StoreKit/RevenueCat
    approach, product configuration assumptions, paywall requirements, trial
    flow, purchase flow, restore, receipt validation, server entitlement
    model, subscription state handling, cancellation/refund/grace handling,
    sandbox testing checklist.
  - *Notifications plan* — provider recommendation for the current stack,
    permission UX, token registration, backend requirements, preferences,
    deep linking, foreground/background handling.
  - *Profile & settings plan* — required screens/fields, validation,
    save/cancel, avatar upload, loading/error/success states, API needs.
  - *Analytics plan* — event taxonomy, screen tracking, identification,
    user properties, funnel/monetization/notification/profile/error events,
    privacy/consent considerations.
- **Runtime verification checklist** — everything static inspection cannot
  confirm: sign up/login/logout, session restore after restart, edit profile
  persistence, push permission prompt, push receipt foreground/background,
  notification deep link, paywall display, trial start, purchase success,
  purchase cancellation, restore purchases, expired entitlement handling,
  offline state, API error state, crash reporting delivery, analytics event
  delivery, iOS build, Android build (if applicable).

## Phase 3 — Review gate (before writing artifacts)

1. Re-verify every P0/P1 finding's citation. Re-check every "Not found"
   repo-wide (alternate directories, naming conventions, native folders)
   before it ships; anything not provably absent stays "Not found in
   inspected repo evidence" with the inspected paths listed.
2. Answer the three questions in the final section: hardest judgment call;
   rejected alternative interpretations; least-confident findings.

## Phase 4 — Write the artifacts

### 1. Report → `docs/readiness-audit/<YYYY-MM-DD>-readiness-audit.md`

1. **Executive Summary** — inferred app type, stack, overall production
   readiness, biggest release blockers, top 5 technical priorities.
2. **Repo Evidence Reviewed** — key files, dependencies found,
   native/platform configs reviewed, unassessable areas.
3. **Stack & Architecture Summary** (Phase 0 output).
4. **Mobile App Basics Status Matrix** (all fourteen areas).
5. **Detailed Findings**.
6. **StoreKit, Paywall & Subscription Plan**.
7. **Notifications Plan**.
8. **Editable Profile & Settings Plan**.
9. **Usage Analytics Plan**.
10. **Production Readiness Roadmap** — Phase 1: release blockers and core
    fundamentals; 2: monetization and analytics foundation; 3:
    notifications, lifecycle, retention; 4: reliability, testing,
    accessibility, store polish; 5: best-in-class enhancements.
11. **Runtime Verification Checklist**.
12. **Risks, Assumptions & Open Questions** — four buckets: confirmed by
    repo evidence · inferred from repo structure · unknown until runtime
    testing · product decisions needed later; plus the three-questions
    answers.

### 2. Work queue → `todos/`

One file per P0/P1/P2 finding (P3s stay in the report), named
`todos/NNN-ready-pN-<slug>.md`, containing: title, user story, technical
goal, problem (with evidence), proposed solution, suggested
files/components, dependencies, acceptance criteria, analytics events, test
plan, severity, confidence. Each must be independently plannable by
`ce-plan` or `/lfg`.

## Phase 5 — Compound

Capture **method** lessons (detection heuristics that worked, checklist
gaps, stack-specific pitfalls) via `ce-compound` if available, else the
project's `tasks/lessons.md`. Fold recurring lessons back into this skill.

## Output discipline

Be specific, technical, and evidence-based. No generic mobile advice: every
missing or partial feature gets a plan a developer could turn directly into
implementation work.
