---
name: kole-jain-ui-design
description: >
  Universal design quality gate for ALL visual outputs — HTML, React, pptx, xlsx, pdf, docx, artifacts.
  This is a GATE, not advice. Every visual output must pass the rejection checklist before delivery.
  TRIGGER ON: Any request with a visual/layout component. Layers on top of format-specific skills.
---

# Design Quality Gate

This skill is a **rejection filter**, not a design tutorial. Read the rejection list. If your output matches ANY item, fix it before delivering.

## Reference anchors

Every visual output should feel like it belongs in one of these products:

- **Linear** — Minimal, monochrome, precise spacing, subtle borders, no decoration
- **Stripe** — Confident typography, restrained color, deep polish on details
- **Vercel** — Black/white dominance, geometric, developer-confident, no filler
- **Robinhood** — Bold simplicity, large type, generous whitespace, consumer-friendly data
- **X (Twitter)** — Dense information, clean hierarchy, dark-mode native, zero ornamentation

If your output doesn't look like it could ship inside one of these products, it's not ready.

---

## Rejection checklist — NEVER ship if any of these are true

1. **Gradient headers or hero sections** — Flat solid colors only. No linear-gradient backgrounds.
2. **Colored circle icons** — No icons sitting inside colored circles (the #1 AI slop tell).
3. **Blue as the default accent** — If the project has no brand color defined, use neutral grays with a single sharp accent. Never default to Tailwind blue-500.
4. **Card grid where every card is identical** — If you have 3+ cards in a row with icon + title + description, you've built a template. Vary the layout or question whether cards are the right pattern.
5. **More than 2 colors beyond neutrals** — One brand accent + one semantic color max. Everything else is gray.
6. **Decorative elements that carry no information** — Blobs, waves, dots, mesh gradients, decorative SVG shapes, background patterns. Delete them.
7. **Equal visual weight everywhere** — If you can't point to the ONE thing the user should look at first, the hierarchy is broken.
8. **Pure black (#000) text on pure white (#FFF)** — Body text: `#1a1a1a` on `#fafafa` minimum. Never max contrast for body copy.
9. **Default Tailwind shadows** — `shadow-sm`, `shadow-md` out of the box look generic. Either no shadow (border-only like Linear) or a custom subtle one.
10. **Rounded-everything** — Not every element needs `rounded-xl`. Use sharp corners by default, round only buttons and inputs. Match Linear's restraint.
11. **Emoji as visual elements** — No emoji in headers, cards, or section markers.
12. **Alternating light/dark section backgrounds** — (The "SaaS landing page" cliche.) Use whitespace to separate sections, not background color bands.
13. **Stock-looking metric cards** — No green up-arrow + red down-arrow trend indicators unless the data actually calls for it. Don't add fake sparklines.
14. **More than 3 font sizes visible at once** — If a section has 4+ distinct font sizes, the scale is broken.
15. **Generic placeholder copy** — "Lorem ipsum", "Your amazing feature", "We help you do X better." Use real copy or leave blank with a comment.

---

## Mandatory defaults

When no project design system exists, use these exact values. Do not improvise.

### Typography
```
Font:          'Inter', system-ui, -apple-system, sans-serif
Heading color: #0a0a0a
Body color:    #374151
Secondary:     #6b7280
Hint/muted:    #9ca3af

Display:  36px, weight 600, letter-spacing -0.025em, line-height 1.1
H1:       30px, weight 600, letter-spacing -0.025em, line-height 1.2
H2:       24px, weight 600, letter-spacing -0.02em, line-height 1.3
H3:       20px, weight 600, line-height 1.4
Body:     15px, weight 400, line-height 1.6, max-width 65ch
Small:    13px, weight 400, line-height 1.5
```

### Spacing (8px grid, no exceptions)
```
4px   micro (icon-to-label gap)
8px   tight (related elements)
12px  compact
16px  standard (most component gaps)
24px  comfortable (between form groups, card internals)
32px  section-sub
48px  section
64px  major division
```

### Color (when no brand exists)
```
Background:    #fafafa
Surface:       #ffffff
Border:        #e5e5e5
Border-hover:  #d4d4d4
Accent:        #171717  (yes — black as accent, like Linear/Vercel)
Accent-subtle: #f5f5f5
Danger:        #dc2626
Success:       #16a34a
Warning:       #d97706
```

### Components
```
Border radius: 6px buttons, 8px inputs, 8px cards (NOT 12px, NOT 16px — restraint)
Border:        1px solid #e5e5e5 (not 0.5px, not 2px)
Shadow:        none by default. If needed: 0 1px 2px rgba(0,0,0,0.04)
Button height: 36px default, 32px small, 40px large
Input height:  36px
Transitions:   150ms ease-out (hover), 200ms ease-out (state changes)
```

---

## Self-review gate (run before every delivery)

Before showing any visual output to the user, answer these five questions. If ANY answer is "no," fix it.

1. **Could this be a screenshot from Linear, Stripe, or Vercel?** If it looks like a Wix template, a WordPress theme, or a Canva creation — it fails.
2. **Can I remove something?** If yes, remove it. Then ask again.
3. **Is there ONE clear focal point?** Cover 80% of the screen with your hand. Can you still identify what matters?
4. **Are neutrals doing 80%+ of the work?** If color is doing more, you've over-decorated.
5. **Would I show this to a design-conscious investor?** Not "is it functional" but "does it signal taste?"

---

## When deep design work is needed

For detailed component specs, dark mode rules, animation timing, dashboard layouts, cross-format guidelines (pptx/xlsx/pdf/docx), and the full design system: read `REFERENCE.md` in this skill directory.

Only load REFERENCE.md when doing substantial UI work (full pages, dashboards, design systems). For quick outputs (a chart, a simple card, a data display), this file is sufficient.
