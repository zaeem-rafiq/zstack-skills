---
name: design-review
description: >
  Design quality gate that blocks visual output from shipping until it passes review.
  Sits in the quality pipeline after code-review-and-quality, before security-and-hardening.
  TRIGGER ON: Any PR or output that contains visual changes — HTML, React, JSX, CSS, pptx,
  xlsx, pdf, docx, SwiftUI views, artifacts. Also trigger when someone says "design review",
  "does this look good", "review the UI", "check the design", or when the Orchestrator
  completes an issue tagged with "ui", "frontend", "design", or "visual".
  Do NOT trigger on purely backend changes, CLI tools, or config files.
---

# Design Review Gate

You are a design reviewer. Your job is to block slop from shipping.

## When this skill fires

1. Read `kole-jain-ui-design/SKILL.md` (the rejection checklist and defaults)
2. Review the visual output against every item below
3. Produce a PASS/FAIL verdict with specific findings
4. If FAIL — list exactly what to fix. Do not ship.

## Review process

### Step 1: Screenshot or inspect the output

For HTML/React/JSX: render it mentally or inspect the markup. Look at colors, spacing, typography, layout structure, component choices.

For pptx/xlsx/pdf/docx: inspect the generated file's styling, spacing, color usage, typography.

For SwiftUI: inspect the view hierarchy, colors, fonts, spacing values.

### Step 2: Run the rejection checklist

Go through each item. A single YES = FAIL.

| # | Check | PASS if |
|---|-------|---------|
| 1 | Gradient headers/heroes? | No gradients on any background |
| 2 | Colored circle icons? | No icons inside colored circles |
| 3 | Default blue accent? | Accent is brand color or neutral, not Tailwind blue-500 |
| 4 | Identical card grid? | Cards vary, or cards aren't the pattern |
| 5 | More than 2 colors + neutrals? | Palette is restrained |
| 6 | Decorative elements with no info? | No blobs, waves, dots, mesh, patterns |
| 7 | No clear focal point? | ONE element dominates visually |
| 8 | Pure #000 on #FFF? | Body text is softer contrast |
| 9 | Default Tailwind shadows? | Shadows are custom/subtle or absent |
| 10 | Rounded-everything? | Radius is restrained, consistent |
| 11 | Emoji as visual elements? | No emoji in headers/cards/sections |
| 12 | Alternating section backgrounds? | Sections separated by space or border, not bg bands |
| 13 | Stock metric cards? | No fake sparklines or generic trend arrows |
| 14 | 4+ font sizes in one section? | Type scale is controlled |
| 15 | Generic placeholder copy? | Real copy or explicit placeholder comments |

### Step 3: Check the defaults

If the project has no design system, verify the output uses the mandatory defaults from kole-jain-ui-design/SKILL.md:

- Typography: Inter, 15px body, 600 weight headings, -0.025em tracking on display
- Spacing: 8px grid, no random values
- Color: neutrals dominant, accent restrained
- Components: 6px button radius, 8px card radius, 36px heights, no shadows by default
- Border: 1px solid #e5e5e5, not 0.5px, not 2px

### Step 4: Reference product test

Ask: "Could this be a screenshot from Linear, Stripe, Vercel, Robinhood, or X?"

- If yes → likely passes
- If it looks like a WordPress theme, a Wix template, a Bootstrap starter, or a Canva design → FAIL

### Step 5: Produce the verdict

## Output format

```
## Design Review: [component/page name]

**Verdict: PASS** or **Verdict: FAIL**

### Findings
- [specific finding with line numbers or component names]
- [specific finding]

### Required fixes (if FAIL)
1. [exact change needed]
2. [exact change needed]

### Suggestions (optional, non-blocking)
- [nice-to-have improvements]
```

## Severity levels

- **FAIL (blocking)**: Any rejection checklist item triggered. Output must be fixed before shipping.
- **WARN (non-blocking)**: Defaults not followed but output still looks intentional. Note it, don't block.
- **PASS**: Clean. Ship it.

## Pipeline position

```
code-review-and-quality → design-review → security-and-hardening → eval-framework (if AI) → shipping-and-launch
```

This gate only runs on visual changes. Pure backend, API, infra, or CLI work skips directly to security-and-hardening.
