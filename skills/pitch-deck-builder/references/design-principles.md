# Design Principles & Technical Patterns

## Core Design Philosophy

Pitch decks must balance professionalism with visual impact. The guiding principle: **when in doubt, remove elements rather than add them.**

## Whitespace

Each slide should have 40-60% whitespace. Crowded slides lose impact and signal amateur design. Whitespace is not empty space — it's strategic breathing room that directs attention to what matters.

## Typography

### Hierarchy
- **Headlines**: 36-48pt, bold, assertive statements (not questions or labels)
- **Body text**: 18-24pt, limited to 3-5 bullet points maximum
- **Data callouts**: 48-72pt for key numbers that need to pop
- **Captions/labels**: 12-14pt for chart labels, footnotes, sources

### Rules
- Never use more than 2 font families (1 for headlines, 1 for body)
- Avoid paragraphs on slides — use short phrases or bullets
- Left-align body text (centered text is harder to scan beyond 1 line)
- Ensure sufficient contrast — dark text on light backgrounds or vice versa

## Color Strategy

### Palette Construction
- **Primary**: Brand color — used for key elements, charts, CTAs
- **Accent**: Complementary color — used sparingly for emphasis and highlights
- **Neutral dark**: Dark gray (#333 or similar, NOT pure black) for body text
- **Neutral light**: Light gray (#F5F5F5 or similar) for slide backgrounds
- **White**: For cards, content containers, breathing room

### Rules
- Limit palette to 3-4 colors total
- Use color consistently — same color should always mean the same thing
- Avoid gradients unless they're part of the brand identity
- Test colors at low brightness/projector settings — some colors wash out

## Data Visualization

### Chart Selection
- **Line charts**: Trends over time (growth, revenue, users)
- **Bar charts**: Comparisons between categories (market segments, features)
- **Pie/donut charts**: Composition (use of funds, market share) — max 4-5 segments
- **Large numbers**: Single key metrics that need maximum impact

### Chart Design Rules
- Always annotate the "so what?" — add a callout explaining the insight
- Remove chart junk: no 3D effects, excessive gridlines, decorative elements
- Use brand colors consistently in all charts
- Label directly on the chart — avoid separate legends when possible
- Highlight the key data point — gray out less important elements

### Tables
- Avoid tables when possible — they're hard to read at presentation distance
- If you must use a table, limit to 3-4 columns and 5-6 rows
- Alternate row shading for readability
- Bold the key column or row

## Layout Patterns

### Full-Bleed
Image or color background covering the entire slide with text overlay. Best for cover slides, section dividers, and vision/impact statements.

### Two-Column (60/40 or 50/50)
Text on one side, visual on the other. The most versatile layout — works for most content slides. Put the more important element on the left (for left-to-right reading cultures).

### Centered
Single key message, data point, or quote centered on the slide. High impact but use sparingly — works for "headline" moments like a key metric or provocative statement.

### Grid (2x2 or 3x3)
Multiple items of equal importance arranged in a grid. Works for team photos, customer logos, feature comparisons, or multi-metric displays. Keep grid items visually consistent.

### Top-Heavy
Large visual or chart in the top 2/3, supporting text in the bottom 1/3. Good for product screenshots, architecture diagrams, or detailed charts that need explanation.

## Slide-Specific Design Patterns

### Cover Slide
- Company name: large, prominent
- Tagline: 1 line, immediately below
- Minimal additional elements (date, presenter name, contact)
- Consider a bold background color or subtle brand imagery
- No clutter — this sets the tone

### Problem Slide
- Lead with the pain point as a headline
- Use a striking statistic or quote
- Consider a "before" visual showing the painful current state
- Emotional resonance matters here — make the audience feel the problem

### Traction Slide
- Lead with the most impressive number (largest font)
- Growth chart as the hero visual
- Supporting metrics as smaller callouts around the chart
- Show trajectory, not just a snapshot

### Team Slide
- Professional headshots in a consistent style
- Name, title, and 1-line credential for each person
- Highlight relevant logos (previous companies, schools) if impressive
- 3-5 team members max on one slide — use appendix for extended team

### Funding Ask Slide
- Amount: large and clear
- Use of funds: simple pie/donut chart or 3-4 line items
- Timeline: what this funding enables over 12-18 months
- Do NOT make this the last slide — follow with vision

### Competition Slide
- Avoid generic 2x2 matrices unless they genuinely show differentiation
- Consider "feature comparison" with checkmarks only if you win on most items
- Alternative: position yourself on a unique axis competitors can't claim
- Never disparage competitors — show your unique value

## CSS Variable Template

When building slides, establish consistent design tokens:

```css
:root {
  /* Brand Colors */
  --color-primary: #2563EB;
  --color-accent: #10B981;
  --color-dark: #1F2937;
  --color-text: #374151;
  --color-text-light: #6B7280;
  --color-bg: #FFFFFF;
  --color-bg-alt: #F9FAFB;
  
  /* Typography */
  --font-display: 'Inter', sans-serif;
  --font-body: 'Inter', sans-serif;
  --size-headline: 42px;
  --size-subhead: 28px;
  --size-body: 20px;
  --size-caption: 14px;
  --size-metric: 64px;
  
  /* Spacing */
  --space-xs: 8px;
  --space-sm: 16px;
  --space-md: 24px;
  --space-lg: 40px;
  --space-xl: 64px;
  
  /* Slide dimensions */
  --slide-width: 960px;
  --slide-height: 540px;
}
```

Adapt these values to the user's brand. If they provide hex codes or brand guidelines, use those. If not, use a professional, modern palette and offer to adjust.
