---
name: shipping-and-launch
description: >
  Ship with confidence using a pre-launch checklist and post-launch verification. Use
  this skill whenever preparing to deploy to production — feature launches, new products,
  major updates, or hotfixes. Also trigger when someone says "ready to ship", "launch
  checklist", "go live", "deploy to production", "pre-launch", "ship it", "launch gate",
  or when the final phase of a prd-to-plan is complete. Covers pre-launch verification,
  rollback planning, staged rollouts, monitoring setup, and post-launch confirmation.
  Outputs a launch checklist with pass/fail gates. Based on the Mirath launch gate
  pattern, formalized for reuse across Rafiq Labs products.
---

# Shipping and Launch

You are the release engineer responsible for getting this feature safely to production.
Your job is to verify everything is ready, ensure a rollback plan exists, and confirm
the launch succeeded. You don't rush — a delayed launch is better than a broken one.

## Philosophy

Shipping is not deploying. Deploying is pushing code to a server. Shipping is confirming
that the code works for real users in the real environment. The gap between "it works
on staging" and "it works in production" is where launches fail.

This skill exists because the Orchestrator can deploy code autonomously, but it can't
verify that the deployment actually works for users. The launch checklist bridges that gap.

## When to Use

- Before any production deployment
- When completing the final phase of an implementation plan
- Before time-sensitive launches (Hajj season, Ramadan, investor demos)
- When the Orchestrator completes all issues for a feature and is ready to merge to main
- When hotfixing a production issue

## The Launch Process

### Step 1: Pre-Launch Checklist

Every item must pass before deploying. Items are ordered by severity — if an early item
fails, stop and fix before continuing.

#### Gate 1: Code Quality
- [ ] All tests pass (paste CI output)
- [ ] Code review completed with PASS verdict (link to review)
- [ ] No critical or high findings from security review
- [ ] No linting or type-check errors
- [ ] No `TODO` or `FIXME` comments related to this feature remain

#### Gate 2: Functionality
- [ ] All acceptance criteria from original issues are met (list the mapping)
- [ ] Happy path tested end-to-end in staging/preview
- [ ] Key edge cases tested (empty states, error states, boundary values)
- [ ] Mobile/responsive behavior verified (if applicable)
- [ ] Cross-browser tested (if web — Chrome, Safari, Firefox at minimum)

#### Gate 3: Data & Infrastructure
- [ ] Database migrations tested (up and down)
- [ ] Supabase RLS policies verified for new tables/columns
- [ ] Environment variables set in production (not just staging)
- [ ] API keys and secrets rotated if any were exposed during development
- [ ] DNS and domain configuration verified (for new domains/subdomains)

#### Gate 4: Monitoring & Rollback
- [ ] Error monitoring active (Sentry, Vercel analytics, or equivalent)
- [ ] Key metrics dashboards updated to track the new feature
- [ ] Rollback plan documented (how to revert if things go wrong)
- [ ] Feature flag configured (if applicable — can disable without redeploy)
- [ ] On-call contact identified (who to ping if something breaks)

#### Gate 5: Communication
- [ ] Changelog updated (if user-facing changes)
- [ ] App Store release notes drafted (if iOS update)
- [ ] Partner/affiliate communications sent (if relevant — Mirath mosque partners)
- [ ] Internal team notified (Slack message with what's shipping)

### Step 2: Deploy

Execute the deployment. For Rafiq Labs projects:
- **Mirath (Vercel):** Merge to main triggers auto-deploy. Verify preview URL first.
- **Rafiq B2B (Cloud Run):** Deploy via CI/CD pipeline. Verify health endpoint.
- **Rafiq iOS:** Archive, upload to App Store Connect, submit for review.

### Step 3: Post-Launch Verification

After deployment, verify in production (not staging):

- [ ] The feature works as expected in production (test the happy path manually)
- [ ] Error monitoring shows no new errors in the first 15 minutes
- [ ] Performance metrics are within acceptable range (no degradation)
- [ ] Key user flows unrelated to this feature still work (regression check)
- [ ] Affiliate tracking and analytics events fire correctly (if applicable)

### Step 4: Celebrate or Rollback

If post-launch verification passes: announce the launch and close the feature's issues.

If post-launch verification fails: execute the rollback plan immediately. Don't debug
in production — revert first, investigate second.

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "It works on staging, it'll work in production." | Staging and production differ in data volume, user behavior, environment variables, third-party API keys, DNS, caching, and CDN configuration. Always verify in production. |
| "We don't need a rollback plan for this change." | Every deployment needs a rollback plan. Even "safe" changes can interact with existing code in unexpected ways. The plan can be simple ("revert commit X"), but it must exist. |
| "We'll set up monitoring after launch." | Launching without monitoring means you won't know something is broken until users tell you. By then, the damage is done. Monitoring goes in before the feature ships. |
| "This is a small change — skip the checklist." | Small changes with no checklist are how typos reach production, env vars get forgotten, and RLS policies get missed. The checklist scales with the change — small change, quick checklist. |
| "We're launching during Hajj season — no time for the full process." | Hajj season is exactly when you can't afford a broken launch. High traffic + high stakes = full checklist, no shortcuts. |
| "The Orchestrator deployed it and tests pass — we're good." | The Orchestrator verifies code correctness. It doesn't verify production configuration, third-party integrations, or real user flows. Post-launch verification is a human responsibility (or an explicit automated check). |

## Red Flags

- **Deployment happened before the pre-launch checklist was completed.** Revert and
  complete the checklist.
- **No rollback plan exists.** Stop and write one before deploying.
- **Post-launch verification was skipped.** "It deployed successfully" is not the same
  as "it works for users." Test in production.
- **Environment variables differ between staging and production.** This is the #1 cause
  of "works on staging, broken in production." Diff them.
- **New Supabase tables were deployed without RLS verification.** Always verify RLS
  in production after migration.

## Verification

After launch, confirm every item below.

- [ ] **All pre-launch gates passed.** Every checkbox in Gates 1-5 is checked with
  evidence.
- [ ] **Deployment succeeded.** Build/deploy output confirms success.
- [ ] **Post-launch verification passed.** Feature works in production. No new errors.
  Performance is within range.
- [ ] **Rollback plan was documented before deployment.** Even if not needed.
- [ ] **Stakeholders are notified.** Internal team, partners, users (as appropriate).

## Handoff

"Launch complete — all gates passed, post-launch verification confirmed. Feature is
live in production. [Summary of what shipped and any follow-up items.]"
