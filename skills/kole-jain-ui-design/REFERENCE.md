# Design Reference

Load this file only for substantial UI work — full pages, dashboards, design systems, multi-screen flows. For quick outputs, SKILL.md alone is sufficient.

---

## Color system

### Light theme
```
Page bg:       #fafafa
Surface:       #ffffff
Elevated:      #ffffff + border #e5e5e5
Border:        #e5e5e5
Border hover:  #d4d4d4
Text primary:  #0a0a0a
Text body:     #374151
Text secondary:#6b7280
Text muted:    #9ca3af
Accent:        #171717
Accent bg:     #f5f5f5
```

### Dark theme (X / Vercel style)
```
Page bg:       #0a0a0a
Surface:       #141414
Elevated:      #1a1a1a
Border:        #262626
Border hover:  #404040
Text primary:  #ededed
Text body:     #a3a3a3
Text secondary:#737373
Text muted:    #525252
Accent:        #ededed
Accent bg:     #1a1a1a
```

Rules: Never pure #000 background. Elevation = lighter surfaces (not shadows). Reduce color saturation 15-20% vs light mode. Test with real content, not placeholders.

### Semantic colors (both modes)
```
Danger:    #dc2626 / dark: #f87171
Success:   #16a34a / dark: #4ade80
Warning:   #d97706 / dark: #fbbf24
Info:      #2563eb / dark: #60a5fa
```

Use semantic colors ONLY for their meaning. Never as decoration.

---

## Typography

### Scale (1.25 ratio, Inter)
```
Display:    36px / 600 / -0.025em / 1.1
H1:         30px / 600 / -0.025em / 1.2
H2:         24px / 600 / -0.02em  / 1.3
H3:         20px / 600 / normal   / 1.4
Body:       15px / 400 / normal   / 1.6
Body small: 13px / 400 / normal   / 1.5
Caption:    12px / 500 / 0.02em   / 1.4
```

### Rules
- Two weights only: 400 (body) and 600 (headings/emphasis). Never 700/800.
- Tighten letter-spacing on all text ≥24px. This single fix eliminates 50% of amateur feel.
- Body text max-width: 65ch. No exceptions.
- Use color AND weight for hierarchy, not just size. Secondary text = #6b7280, not smaller-same-color.
- Monospace only for code and data tables. Never for decorative effect.

### Responsive
```
Desktop H1 30px → Mobile 24px
Desktop H2 24px → Mobile 20px
Desktop body 15px → Mobile 15px (don't shrink body)
Use clamp(): font-size: clamp(1.5rem, 1.25rem + 1vw, 1.875rem)
```

---

## Layout patterns

### Dashboard (Linear style)
```
Sidebar:     240px fixed, collapsible to 48px icon-only
Header:      48px height, border-bottom, breadcrumb + actions
Content:     fluid, max-width 1200px, padding 32px
```
- Metric cards at top: label (13px #6b7280) + value (24px #0a0a0a) + optional trend
- Primary content = table. Not cards. Tables are the correct default for data.
- Sidebar nav: 32px item height, 8px vertical gap, active = #f5f5f5 bg + #0a0a0a text

### Landing page (Vercel style)
```
Section padding: 80px top/bottom (desktop), 48px (mobile)
Content max-width: 1080px centered
Hero: headline + one-liner + CTA. Nothing else.
```
- No alternating bg colors between sections. White bg throughout, separated by 1px border or whitespace.
- Features: 2-column grid (visual left, text right) or simple stacked blocks. NOT icon+title+description card grids.
- Social proof: logos in grayscale, single row, no "trusted by" headline needed.

### Consumer fintech (Robinhood style)
```
Large type: hero numbers at 48-64px
Generous whitespace: 96px+ section padding
Cards: minimal border, large internal padding (32px)
Data: big number primary, small label secondary, chart below
```
- Color: nearly monochrome with one green accent for positive, one red for negative
- Charts: clean, no gridlines, no axis labels unless necessary, direct-label key points
- Trust through simplicity — fewer elements = more trust

### Information-dense (X style)
```
Compact rows: 52px height
Tight spacing: 12px between items
Dense but hierarchical: primary text 15px + secondary 13px on same line
Border separators, not whitespace
```
- Dark mode native. Light mode as secondary.
- No cards — use flat list items with border-bottom
- Avatar + name + handle + timestamp + content in a predictable scan pattern
- Actions: icon-only, gray, no labels. Hover to reveal counts.

---

## Components

### Buttons
```
Primary:     #171717 bg, #fff text, 6px radius, 36px height, 600 weight
Secondary:   transparent bg, #e5e5e5 border, #374151 text
Ghost:       transparent bg, no border, #6b7280 text, hover: #f5f5f5 bg
Danger:      #dc2626 bg, #fff text
Disabled:    0.5 opacity, pointer-events none

Hover:       filter brightness(1.2) for dark buttons, bg #f5f5f5 for light
Active:      transform scale(0.98)
Transitions: 150ms ease-out
Padding:     0 16px (default), 0 12px (small), 0 20px (large)
```

### Inputs
```
Height:       36px
Border:       1px solid #e5e5e5
Radius:       8px
Padding:      0 12px
Focus:        border-color #171717 + ring 2px rgba(23,23,23,0.1)
Error:        border-color #dc2626
Placeholder:  #9ca3af
Label:        13px, 600 weight, #374151, 6px margin-bottom
```
Labels above inputs always. Never placeholder-only.

### Cards
```
Background:   #ffffff
Border:       1px solid #e5e5e5
Radius:       8px
Padding:      24px
Shadow:       none (prefer border)
Hover:        border-color #d4d4d4 (if interactive)
```
No shadow. Linear and Stripe both use border-only cards. Shadow = dated.

### Tables
```
Header:       13px, 600 weight, #6b7280, uppercase, bg #fafafa
Row height:   48px
Row border:   1px solid #f5f5f5
Text:         15px, #374151
Numbers:      right-aligned, tabular-nums
Actions:      right column, icon-only, #9ca3af, hover #374151
```
No alternating row colors. Use border-bottom only (Stripe style).

### Navigation (sidebar)
```
Width:        240px
Item height:  32px
Item padding: 8px 12px
Item radius:  6px
Active:       bg #f5f5f5, text #0a0a0a, weight 600
Inactive:     text #6b7280, weight 400
Hover:        bg #f5f5f5
Section label: 12px, 600 weight, #9ca3af, uppercase, 0.05em tracking
Gap between sections: 24px
```

### Modals
```
Backdrop:     rgba(0,0,0,0.5) + backdrop-filter blur(4px)
Width:        480px (confirm), 560px (form), 720px (complex)
Radius:       12px (the one place larger radius is correct)
Padding:      24px
Animation:    opacity 0→1 + scale 0.97→1, 200ms ease-out
```

### Badges / Pills
```
Height:       22px
Padding:      0 8px
Radius:       4px (subtle) or 9999px (pill)
Font:         12px, 500 weight
Colors:       Tinted bg + dark text from same hue family
              e.g., success: bg #dcfce7 text #166534
              e.g., danger: bg #fef2f2 text #991b1b
```

---

## Animation

### Timing
```
Hover/toggle:     150ms ease-out
Expand/collapse:  200ms ease-out
Modal/drawer:     200ms ease-out
Page transition:  250ms ease-out
```
Never exceed 300ms for any UI transition. Linear is fast. Stripe is fast. Slow = cheap.

### What to animate
- Button hover: background-color transition
- Card hover (if interactive): border-color transition
- Modal: opacity + scale entrance
- Accordion: max-height + opacity
- Toast: translate + opacity from edge

### What NOT to animate
- Color-shifting backgrounds
- Floating/bobbing elements
- Parallax (unless specifically requested for marketing)
- Typewriter text effects
- Anything that loops continuously

---

## Cross-format

### Presentations (pptx)
- One idea per slide. No exceptions.
- Title slide: 36pt title, 18pt subtitle, nothing else
- Content slide: headline states the insight ("Revenue grew 23%") not the topic ("Revenue")
- 28-36pt titles, 18-20pt body. Nothing below 16pt.
- One font family. One accent color + black + gray.
- No transitions. No animations. No clip art.

### Spreadsheets (xlsx)
- Freeze row 1 + column A
- Headers: 600 weight, #f5f5f5 background, border-bottom
- Numbers right-aligned, text left-aligned
- Conditional formatting: green/red/amber only, subtle tints not full color fills
- Charts: no 3D, no gradients, no gridlines, direct-label when possible
- Title states insight, not metric name

### Documents (pdf/docx)
- 1.25" margins minimum
- Body: 11pt, 1.5 line-height, single column
- Headings: clear size steps, max 3 levels
- No more than 2 colors beyond black
- Tables: clean borders, no heavy cell shading
- Page numbers in footer, nothing in header unless letterhead
