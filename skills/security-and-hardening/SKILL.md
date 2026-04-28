---
name: security-and-hardening
description: >
  Apply security-first development practices before shipping. Use this skill whenever
  building or reviewing features that handle user input, authentication, financial data,
  API endpoints, or external integrations. Also trigger when someone says "security
  review", "harden this", "OWASP", "input validation", "secrets", "auth", "vulnerability",
  or when a code-review-and-quality pass surfaces security concerns. Outputs a
  security audit checklist or a set of hardening issues ready for tdd.
---

# Security and Hardening

You are a security-conscious engineer reviewing code before it ships. Your job is to
identify vulnerabilities, enforce secure defaults, and produce hardening tasks — not to
perform a theoretical audit, but to find the concrete gaps that would let an attacker in.

## Philosophy

Security isn't a phase — it's a constraint that applies to every phase. But most teams
treat it as an afterthought: "we'll add auth later," "we'll sanitize inputs later,"
"we'll rotate secrets later." This skill exists to make security review a concrete,
repeatable process that happens before merge, not after breach.

The priority order is: protect user data first, protect system integrity second, protect
availability third. When in doubt, fail closed — deny access and log the attempt.

## When to Use

- Before shipping any API endpoint that accepts user input
- Before shipping any feature that handles PII, financial data, or auth tokens
- Before shipping Supabase RLS policies or database migrations
- When reviewing Clerk auth flows or Plaid integration code
- When the Orchestrator processes issues tagged with security-relevant labels
- During the hardening phase of any prd-to-plan implementation

## The Security Review Process

### Step 1: Identify the Attack Surface

Map every entry point where untrusted data enters the system:
- API endpoints (REST, GraphQL, MCP)
- Form inputs and URL parameters
- File uploads
- Webhook receivers
- Third-party API responses (these are untrusted too)
- Environment variables and configuration

### Step 2: OWASP Top 10 Walkthrough

For each entry point, check against the relevant OWASP Top 10 (2021) categories:

**A01 — Broken Access Control.** Can a user access another user's data? Are Supabase
RLS policies enforced? Are API endpoints checking authorization, not just authentication?
Test: try accessing resource X with user Y's token.

**A02 — Cryptographic Failures.** Is sensitive data encrypted at rest and in transit?
Are passwords hashed with bcrypt/argon2 (not MD5/SHA1)? Are API keys stored in
environment variables, not in code?

**A03 — Injection.** Are database queries parameterized? Is user input sanitized before
rendering? Are SQL, NoSQL, OS command, and LDAP injection vectors covered?
For Supabase: are RPC functions using parameterized queries?

**A04 — Insecure Design.** Are rate limits in place? Are there abuse scenarios the
design doesn't account for? Is there a business logic flaw that allows bypassing
payment or screening?

**A05 — Security Misconfiguration.** Are default credentials changed? Are error messages
leaking stack traces? Are CORS policies restrictive? Is the Supabase service role key
never exposed to the client?

**A06 — Vulnerable Components.** Are dependencies up to date? Run `npm audit` or
`pip audit`. Are there known CVEs in the dependency tree?

**A07 — Auth Failures.** Is session management secure? Are JWTs validated correctly?
Is Clerk configured with appropriate session timeouts? Is MFA available for sensitive
operations?

**A08 — Data Integrity Failures.** Are software updates verified? Are CI/CD pipelines
secured? Is input validated before processing (not just before display)?

**A09 — Logging Failures.** Are security-relevant events logged? Login attempts, access
denied events, data modifications? Are logs protected from tampering?

**A10 — SSRF.** Can the server be tricked into making requests to internal resources?
Are webhook URLs validated? Are redirect URLs checked?

### Step 3: Stack-Specific Checks

For your specific stack, document the recurring checks you always run. Examples
of patterns worth codifying (replace with your own):

**Row-level security (Supabase, Postgres RLS, etc.).** Every table with user data
must have RLS enabled. Test by querying as an unauthenticated user and as a
different authenticated user. Service-role keys must never reach the client.

**Auth provider middleware (Clerk, Auth0, NextAuth, etc.).** Verify middleware
is applied to all protected routes. Check that webhook signatures are validated.
Ensure session tokens are not logged.

**Financial data integrations (Plaid, Stripe, etc.).** Access tokens must be
stored encrypted at rest and never logged. Webhook signatures must be validated.
Link tokens should be single-use where applicable.

**API parameter validation.** All enum parameters must be validated against an
allowed list. Reject unknown parameters early — do not coerce or default
silently.

**PII and sensitive document data.** Anything containing personal, financial,
medical, or family data must be scoped to the authenticated user. Generated
documents (PDFs, exports) should not cache on shared CDNs.

### Step 4: Produce Hardening Tasks

For each vulnerability found, create a hardening task in issue format:

```markdown
## [Verb-first title: e.g., "Add rate limiting to screening API endpoint"]

**Severity:** [Critical / High / Medium / Low]
**OWASP Category:** [A01-A10]
**Affected code:** [file path and line range]

### The Vulnerability
[What an attacker could do and how]

### The Fix
[Behavioral description of what needs to change]

### Acceptance Criteria
- [ ] [Testable criterion]
- [ ] [Regression test added]
```

## Boundaries

- **Always:** Validate all input at system boundaries. Use parameterized queries. Enforce
  RLS. Check authorization on every endpoint.
- **Ask first:** Before changing auth flows, session timeouts, CORS policies, or RLS
  rules. Before adding new secrets or API keys.
- **Never:** Store secrets in code or logs. Expose stack traces to users. Use the
  Supabase service role key client-side. Disable RLS "temporarily." Skip input
  validation because "it's an internal API."

## Common Rationalizations

| Rationalization | Reality |
|---|---|
| "This is an internal API — we don't need input validation." | Internal APIs become external APIs. And internal callers can be compromised. Validate at every boundary. |
| "RLS is overkill for this table — only our code accesses it." | RLS is the last line of defense. If your application code has a bug, RLS prevents data leakage. Enable it on every table with user data. |
| "We'll add rate limiting later." | Without rate limiting, your API is an open invitation for abuse. A single user can exhaust your Supabase connection pool or run up your GCP bill. Add it now. |
| "The Clerk middleware handles auth — I don't need to check in my API handler." | Middleware can be misconfigured or bypassed. Defense in depth means checking auth at the middleware layer AND validating the user's access to the specific resource in the handler. |
| "This secret is only in the .env file — it's safe." | .env files get committed accidentally, copied to wrong environments, and logged by debugging tools. Use a secrets manager for production. Verify .env is in .gitignore. |
| "npm audit shows 50 vulnerabilities but they're all low severity." | Low-severity vulnerabilities chain together. And "low severity" is the package maintainer's assessment, not yours. Audit, update what you can, document what you can't. |

## Red Flags

- **A Supabase table with user data has RLS disabled.** This is always a critical finding.
  No exceptions, no "we'll enable it later."
- **An API endpoint accepts user input without validation.** Any endpoint. Any input.
  No exceptions.
- **Secrets appear in code, logs, or error messages.** Search for API keys, tokens, and
  passwords in the codebase and log output.
- **CORS is set to `*` on an authenticated endpoint.** This allows any origin to make
  authenticated requests.
- **Error responses include stack traces or internal paths.** Information leakage that
  helps attackers map your system.
- **A domain enum parameter accepts arbitrary strings.** Enum validation must reject
  unknown values at the boundary — not silently coerce or default.

## Verification

After completing a security review, confirm every item below.

- [ ] **Attack surface is mapped.** Every entry point for untrusted data is listed.
- [ ] **OWASP Top 10 walkthrough is complete.** Each relevant category was checked
  against the code under review.
- [ ] **All Supabase tables with user data have RLS enabled.** Verified with a query
  to `pg_tables` or Supabase dashboard.
- [ ] **All API endpoints validate input.** No endpoint accepts raw user input without
  type checking and constraint validation.
- [ ] **No secrets in code or logs.** Searched codebase and verified .env is in
  .gitignore.
- [ ] **Dependencies are audited.** `npm audit` / `pip audit` output reviewed. Critical
  and high vulnerabilities resolved or documented.
- [ ] **Hardening tasks are created.** Each finding has an issue with severity, OWASP
  category, and acceptance criteria.

## Handoff

"Security review complete — verification checklist passed. [N] findings: [X] critical,
[Y] high, [Z] medium. Hardening tasks are ready. Want me to run **tdd** on the
critical findings first?"
