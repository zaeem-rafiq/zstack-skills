---
name: frontend-design
description: Create distinctive, production-grade frontend interfaces with high design quality. Use this skill when the user asks to build web components, pages, artifacts, posters, or applications (examples include websites, landing pages, dashboards, React components, HTML/CSS layouts, or when styling/beautifying any web UI). Generates creative, polished code and UI design that avoids generic AI aesthetics.
license: Complete terms in LICENSE.txt
---

This skill produces designer-grade, production-ready frontend code. Every output should look like it was built by a senior frontend engineer working with a design system — not like a creative coding experiment.

The user provides frontend requirements: a component, page, application, or interface to build. They may include context about the purpose, audience, or technical constraints.

---

## Design Principles

Before writing any code, establish three things:

1. **Purpose & audience**: Who is this for? What action should they take? Every design decision flows from this.
2. **Tone**: Choose ONE word — corporate, editorial, warm, technical, luxury, playful, clean. This word governs every subsequent choice.
3. **Reference class**: What does the best version of this type of site look like? A SaaS landing page has different conventions than a portfolio, a fintech dashboard, or a restaurant site. Design within the conventions of the category, then elevate — don't reinvent.

**The golden rule: Restraint is the hallmark of professional design.** A production site earns trust through consistency, alignment, and breathing room — not through novelty for its own sake. Every element must justify its existence.

---

## Design System Foundation

Every output MUST establish these CSS custom properties at the root. This is non-negotiable — it's what separates a designed site from a vibe-coded one.

### Spacing Scale (8px base unit)

```css
:root {
  --space-1: 0.25rem;   /* 4px  - tight padding, icon gaps */
  --space-2: 0.5rem;    /* 8px  - inline element spacing */
  --space-3: 0.75rem;   /* 12px - compact padding */
  --space-4: 1rem;      /* 16px - standard padding */
  --space-5: 1.5rem;    /* 24px - card padding, form gaps */
  --space-6: 2rem;      /* 32px - section inner padding */
  --space-8: 3rem;      /* 48px - between components */
  --space-10: 4rem;     /* 64px - between page sections */
  --space-12: 5rem;     /* 80px - major section breaks */
  --space-16: 8rem;     /* 128px - hero/section vertical padding */
  --space-20: 10rem;    /* 160px - hero/section vertical padding (desktop) */
}
```

**Rules:**
- ONLY use values from this scale. Never use arbitrary values like `padding: 27px` or `margin: 3.7rem`.
- Vertical rhythm between page sections should use `--space-12` to `--space-20`. Generous vertical spacing is the single biggest differentiator between amateur and professional layouts.
- Inner padding on cards/containers should use `--space-5` to `--space-6`.
- Don't crowd elements. When in doubt, add MORE space, not less.

### Typography Scale (Major Third — 1.25 ratio)

```css
:root {
  --text-xs: 0.75rem;     /* 12px - captions, fine print */
  --text-sm: 0.875rem;    /* 14px - secondary text, metadata */
  --text-base: 1rem;      /* 16px - body text */
  --text-lg: 1.125rem;    /* 18px - large body, lead text */
  --text-xl: 1.25rem;     /* 20px - small headings */
  --text-2xl: 1.5rem;     /* 24px - card headings */
  --text-3xl: 1.875rem;   /* 30px - section headings */
  --text-4xl: 2.25rem;    /* 36px - page headings */
  --text-5xl: 3rem;       /* 48px - hero headings (mobile) */
  --text-6xl: 3.75rem;    /* 60px - hero headings (desktop) */
  --text-7xl: 4.5rem;     /* 72px - display headings */

  --leading-tight: 1.15;   /* headings */
  --leading-snug: 1.3;     /* subheadings */
  --leading-normal: 1.6;   /* body text */
  --leading-relaxed: 1.75; /* long-form reading */
}
```

**Rules:**
- Body text is ALWAYS `--text-base` (16px) minimum. Never go smaller for primary content.
- Headings use `--leading-tight` (1.15). Body uses `--leading-normal` (1.6).
- Line length for body text MUST be 45–75 characters (use `max-width: 65ch` on text containers).
- Each heading level should be visibly distinct from adjacent levels. Skip at most one level in the scale between adjacent headings.

### Font Selection

**Approach: One distinctive font + one workhorse font.**

- **Display/heading font**: This is where personality lives. Choose ONE high-quality display font from Google Fonts that matches the tone. Examples by tone:
  - Corporate/clean: DM Sans, Plus Jakarta Sans, Outfit
  - Editorial/sophisticated: Playfair Display, Fraunces, Newsreader, Libre Baskerville
  - Technical/modern: JetBrains Mono (sparingly), Space Mono (headings only), Sora
  - Warm/friendly: Nunito, Quicksand, Poppins
  - Luxury: Cormorant Garamond, Tenor Sans
  - Playful: Baloo 2, Fredoka
- **Body font**: Readability is king. Use a clean, well-hinted sans-serif: Inter, Source Sans 3, Lato, Noto Sans, IBM Plex Sans, or DM Sans. Yes — Inter is fine for body text. The goal is readability, not novelty.

**Rules:**
- Maximum TWO font families total. Three is almost always too many.
- Never use a display/decorative font for body text.
- Always include proper `font-display: swap` and a system font fallback stack.
- NEVER use: Comic Sans, Papyrus, Impact, or any novelty font for anything serious.
- Vary font choices across different generations — don't always reach for the same pair.

### Color System

```css
:root {
  /* Neutrals — every site needs a full neutral scale */
  --neutral-50:  /* near-white */;
  --neutral-100: /* light gray */;
  --neutral-200: /* border gray */;
  --neutral-300: /* disabled state */;
  --neutral-400: /* placeholder text */;
  --neutral-500: /* secondary text */;
  --neutral-600: /* body text (light theme) */;
  --neutral-700: /* strong text */;
  --neutral-800: /* headings */;
  --neutral-900: /* near-black */;
  --neutral-950: /* deepest dark */;

  /* Brand — one primary, one accent, used sparingly */
  --brand-primary: /* main brand color */;
  --brand-primary-hover: /* darker/lighter for interaction states */;
  --brand-accent: /* secondary accent — used VERY sparingly */;

  /* Semantic */
  --color-success: #16a34a;
  --color-warning: #d97706;
  --color-error: #dc2626;
  --color-info: #2563eb;

  /* Surfaces */
  --bg-primary: /* main page background */;
  --bg-secondary: /* cards, offset sections */;
  --bg-tertiary: /* nested elements, code blocks */;
}
```

**Rules:**
- The neutral scale does 90% of the work. Brand color is used for CTAs, links, active states, and key accents — NOT for large background areas (unless the design explicitly calls for it, like a hero).
- For light themes: body text should be `--neutral-700` or `--neutral-800`, NOT pure black.
- For dark themes: body text should be `--neutral-200` or `--neutral-300`, NOT pure white. Background should be `--neutral-900` or `--neutral-950`, NOT #000000.
- Every interactive element needs three states: default, hover, and active/focus. Define these upfront.
- Check color contrast: body text on background must meet WCAG AA (4.5:1 ratio minimum).

---

## Layout Architecture

### Page Structure Convention

Most production websites follow this skeleton. Don't deviate unless the brief specifically requires it:

```
┌─────────────────────────────────────┐
│  Nav (sticky or fixed)              │
├─────────────────────────────────────┤
│  Hero Section                       │
│  (headline + subline + CTA)         │
├─────────────────────────────────────┤
│  Social Proof / Logos               │
├─────────────────────────────────────┤
│  Features / Value Props             │
├─────────────────────────────────────┤
│  How It Works / Process             │
├─────────────────────────────────────┤
│  Testimonials / Case Studies        │
├─────────────────────────────────────┤
│  Pricing or CTA Section             │
├─────────────────────────────────────┤
│  FAQ (if applicable)                │
├─────────────────────────────────────┤
│  Footer                             │
└─────────────────────────────────────┘
```

Not every page needs all sections. Include only what the content supports. But the ORDER matters — it follows a persuasion arc: attention → credibility → value → proof → action.

### Grid System

- Use CSS Grid or Flexbox — never floats.
- Standard content width: `max-width: 1200px` with `margin: 0 auto` and horizontal padding of `--space-5` to `--space-6`.
- For text-heavy sections, use a narrower container: `max-width: 720px` (or `65ch`).
- Standard grid: 12-column for complex layouts, or simple 2/3-column auto-fit grids for cards.
- Consistent gutters: use `gap: var(--space-5)` or `gap: var(--space-6)` for grid items.

```css
.container {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding-inline: var(--space-5);
}
.container--narrow {
  max-width: 720px;
}
```

### Responsive Design (Mobile-First, Non-Negotiable)

Write CSS mobile-first, then layer on complexity with `min-width` breakpoints:

```css
/* Breakpoints */
--bp-sm: 640px;    /* large phones */
--bp-md: 768px;    /* tablets */
--bp-lg: 1024px;   /* laptops */
--bp-xl: 1280px;   /* desktops */
```

**Rules:**
- Start with a single-column layout. Add columns only at `--bp-md` or `--bp-lg`.
- Hero headline: `--text-4xl` on mobile, `--text-6xl` or `--text-7xl` on desktop. Use `clamp()` for fluid scaling: `font-size: clamp(2.25rem, 5vw, 4.5rem)`.
- Navigation: hamburger/slide-out on mobile. Horizontal links on desktop (`--bp-lg`).
- Touch targets: minimum 44×44px on mobile for all interactive elements.
- Images must be responsive (`max-width: 100%; height: auto;`).
- Test mental model: "Does this look right on a 375px-wide iPhone SE screen?" If the answer is no, fix it first.

---

## Component Patterns

### Navigation Bar

```
Desktop: [Logo]  [Links ...]  [CTA Button]
Mobile:  [Logo]  [Hamburger ☰] → slide-out menu
```

- Sticky nav with subtle `backdrop-filter: blur(12px)` and a `border-bottom` or `box-shadow` on scroll.
- Nav height: 60–80px. Logo max-height: 32–40px.
- CTA in the nav should be visually distinct (filled button while nav links are text).
- Active page link gets a visual indicator (underline, color, weight).

### Hero Section

- Padding: `--space-16` to `--space-20` vertical.
- Headline: short, benefit-driven, 5-12 words ideal. `--text-5xl` to `--text-7xl`.
- Subheadline: 1-2 sentences max. `--text-lg` or `--text-xl`, in `--neutral-500` or `--neutral-600`.
- One primary CTA button. Optionally one secondary (text link or ghost button).
- Text alignment: center for SaaS/product pages, left-aligned for editorial/agency.
- If using a hero image, keep it on one side (split layout) or as a subtle background with overlay.

### Buttons

```css
.btn-primary {
  background: var(--brand-primary);
  color: white;
  padding: var(--space-3) var(--space-6);
  border-radius: 8px;        /* or use a --radius variable */
  font-weight: 600;
  font-size: var(--text-base);
  border: none;
  cursor: pointer;
  transition: background 150ms ease, transform 150ms ease;
}
.btn-primary:hover {
  background: var(--brand-primary-hover);
  transform: translateY(-1px);
}
.btn-primary:active {
  transform: translateY(0);
}
```

**Rules:**
- Every button needs hover AND active states. No exceptions.
- Consistent border-radius across the entire page. If buttons are `8px`, cards are `8px` (or `12px` — pick one radius language).
- Primary buttons are filled. Secondary buttons are outlined or ghost.
- Minimum button padding: `12px 24px`. Buttons should never feel cramped.

### Cards

- Consistent border-radius (define a `--radius-md: 12px` and `--radius-lg: 16px`).
- Card padding: `--space-5` to `--space-6`.
- Shadow or border — pick one approach and apply it globally. Shadows: `box-shadow: 0 1px 3px rgba(0,0,0,0.08), 0 1px 2px rgba(0,0,0,0.06)` for subtle, or `0 4px 6px -1px rgba(0,0,0,0.1)` for elevated.
- Cards in a grid should all be the same height (use `align-items: stretch` or `grid-auto-rows`).

### Section Spacing

- Each section gets consistent vertical padding: `padding-block: var(--space-12)` minimum, `var(--space-16)` to `var(--space-20)` for major sections.
- Alternate backgrounds between sections for visual rhythm: white → `--neutral-50` → white → `--neutral-50`.
- Section headings: centered, `--text-3xl` to `--text-4xl`, with a short subtitle in `--neutral-500`.

### Footer

- Background: `--neutral-900` or `--neutral-950` (dark footer) or `--neutral-50` (light footer).
- Grid layout: logo + description column, then 2-4 link columns.
- Bottom bar: copyright, legal links, separated by a `border-top`.
- Don't neglect the footer — it's the last impression.

---

## Motion & Animation

### Philosophy: Purposeful, not decorative

Animations should GUIDE attention, CONFIRM interactions, and CREATE continuity — not entertain.

### What to animate (and how)

- **Page load**: Fade-in + subtle translateY for hero content. Stagger children by 50-100ms. Total orchestration under 800ms.
- **Scroll reveals**: Use `IntersectionObserver` (or a library). Fade-in + translateY(20px) as elements enter viewport. Keep it subtle — 400-600ms duration, `ease-out` timing.
- **Hover states**: Transform, color, shadow transitions. Keep under 200ms. `transition: all 150ms ease`.
- **Navigation**: Smooth scroll for anchor links. Menu transitions 200-300ms.

### What NOT to animate

- Do NOT animate everything on the page. If every element bounces in, nothing has emphasis.
- No parallax scrolling unless specifically requested. It usually hurts more than it helps.
- No auto-playing carousels. Ever.
- No animations longer than 800ms for UI elements (loading states excepted).
- No bouncy/elastic easing on UI — use `ease-out` or `cubic-bezier(0.16, 1, 0.3, 1)` for smooth deceleration.

### CSS-first animation

Prefer CSS transitions and `@keyframes` over JavaScript animation libraries when building HTML. For React, the Motion library (framer-motion) is acceptable.

```css
/* Reusable fade-in-up */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
.animate-in {
  animation: fadeInUp 500ms ease-out forwards;
}
```

---

## Visual Polish Checklist

Before considering any output complete, verify ALL of these:

### Alignment & Consistency
- [ ] All text left-edges align within their container
- [ ] Card heights match in a row
- [ ] Button sizes are consistent across the page
- [ ] Border-radius is consistent (all 8px, all 12px — not a mix)
- [ ] Icon sizes are consistent within a section

### Typography
- [ ] Heading hierarchy is clear (each level visually distinct)
- [ ] Body text line-length ≤ 75 characters
- [ ] Body text line-height is 1.5–1.7
- [ ] No orphaned words on critical headlines (use `text-wrap: balance` where supported)
- [ ] Font weights vary intentionally: 400 body, 500 subheadings, 600-700 headings

### Spacing
- [ ] Vertical padding between sections is generous (minimum 80px)
- [ ] No elements feel cramped — when in doubt, add space
- [ ] Padding inside cards/containers is at least 24px
- [ ] Related elements are grouped tightly; unrelated elements have clear separation

### Interaction
- [ ] Every link and button has a hover state
- [ ] Focus states exist for keyboard accessibility (outline or ring)
- [ ] Interactive elements have `cursor: pointer`
- [ ] Disabled states are visually distinct (opacity or color change)

### Responsiveness
- [ ] Page is usable at 375px width (iPhone SE)
- [ ] No horizontal scroll at any viewport
- [ ] Text is readable without zooming on mobile
- [ ] Touch targets are ≥ 44px

---

## Background & Texture (Use Sparingly)

Backgrounds create depth and atmosphere, but they must serve the design — not compete with content.

**Acceptable techniques:**
- Subtle gradient backgrounds: `background: linear-gradient(to bottom, var(--neutral-50), white)`
- Soft radial glows behind hero sections (low opacity, large blur radius)
- Fine dot grids or line patterns at 3-5% opacity as section backgrounds
- Subtle noise/grain overlay at 2-4% opacity for texture

**Avoid:**
- Gradient meshes that compete with text readability
- Heavy pattern backgrounds behind content
- Multiple competing background effects on the same page
- Any background that makes text harder to read

---

## What NOT to Do

These patterns flag a site as "AI-generated" or "vibe-coded" instantly:

1. **Purple-to-blue gradients on white backgrounds** — the #1 AI cliché.
2. **Massive border-radius on everything** (border-radius: 24px on buttons, 32px on cards). Keep it grounded: 8-12px is professional.
3. **Glowing neon effects and glassmorphism everywhere** — one glass element is fine. Ten is a theme park.
4. **Inconsistent spacing** — the biggest tell. If padding varies randomly between sections, it looks undesigned.
5. **No hover states** — immediately feels like a prototype.
6. **Text over busy images without overlay** — unreadable = undesigned.
7. **Auto-playing anything** — videos, carousels, animations. Let the user initiate.
8. **Thin, low-contrast text** — gray-on-light-gray is not "minimalist", it's inaccessible.
9. **Every section using a different layout pattern** — consistency creates professionalism.
10. **Decorative elements that serve no communication purpose** — floating shapes, random gradients, blob backgrounds with no meaning.

---

## Implementation Notes

- Load Google Fonts via `<link>` in the `<head>` with `display=swap`.
- Use semantic HTML: `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<footer>`.
- Images: always include `alt` text, use `loading="lazy"` for below-fold images.
- For placeholder images, use `https://placehold.co/WIDTHxHEIGHT` or solid color blocks with text.
- Prefer CSS custom properties over hardcoded values — every color, spacing, and font reference should use a variable.
- For React: use functional components, hooks, and Tailwind utility classes that map to the design system values above. Still define CSS variables for colors and apply via Tailwind's arbitrary value syntax or a tailwind config.

---

## Summary Mantra

**Consistency over creativity. Spacing over spectacle. Convention over cleverness.**

A production website earns trust through rhythm, restraint, and relentless attention to the small things — not through visual fireworks. Make every pixel intentional.
