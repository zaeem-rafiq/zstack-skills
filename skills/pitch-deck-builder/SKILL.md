---
name: pitch-deck-builder
description: >
  Comprehensive pitch deck creation with conversational discovery, narrative structuring, 
  and professional slide design. Use this skill whenever the user asks to create a pitch deck, 
  investor presentation, fundraising deck, startup presentation, sales deck, partnership deck, 
  or any business presentation. Also trigger when users mention 'slides', 'deck', 'pitch', 
  'investor presentation', 'fundraising materials', or want to present their business, product, 
  or startup to any audience including investors, customers, or partners. Always consult this 
  skill before creating any presentation-style business deliverable, even if the user doesn't 
  explicitly say 'pitch deck'. This includes requests like 'help me prepare for my investor 
  meeting', 'I need to present my startup', or 'make slides for my fundraise'.
---

# Pitch Deck Builder

Create professional pitch decks through conversational discovery, narrative structuring, and polished slide design. This skill balances compelling storytelling with strategic information architecture.

## Core Workflow Overview

The process has four phases:
1. **Discovery Interview** — Understand the business, audience, and goals
2. **Narrative Planning** — Structure the story arc and slide sequence
3. **Design & Execution** — Build the actual slides using pptx skill
4. **Refinement & Delivery** — Iterate and polish

Never skip straight to slide creation. The discovery and narrative phases are what separate great decks from mediocre ones.

---

## Phase 1: Discovery Interview

Conduct a structured but conversational interview before creating any slides. Ask 2-3 questions at a time, building naturally on responses. Listen more than prescribe — let the user's story emerge.

For the full question bank organized by stage, read `references/discovery-questions.md`.

### Discovery Stages (Summary)

**Stage 1 — Foundation (3-5 questions):** Pitch type, audience, core narrative, stage/goals, constraints.

**Stage 2 — Business Fundamentals (5-8 questions):** Problem, solution, market, business model, traction, competition.

**Stage 3 — Narrative Elements (4-6 questions):** Founding story, customer evidence, vision, team, milestones.

**Stage 4 — Data & Materials (3-4 questions):** Key metrics, visual assets, must-include elements.

### Discovery Best Practices

- Ask "why" and "so what" to uncover deeper insights
- Notice what the user emphasizes — these are often the strongest narrative elements
- Validate understanding by reflecting back key points
- Don't treat discovery as a rigid questionnaire — adapt based on responses

### Context Window Management

Before proceeding to Phase 2, assess whether chunking is needed:

- **< 15 slides**: Build in one pass
- **15-20 slides**: Recommend chunking into 2-3 phases
- **> 20 slides**: Require chunking strategy

If chunking is needed, propose phases to the user:
- **Phase A**: Opening slides (Cover through Product/Demo)
- **Phase B**: Business slides (Market through Competition)
- **Phase C**: Closing slides (Team through Contact)

Document phase boundaries clearly for handoff consistency.

---

## Phase 2: Narrative Planning

After discovery, create a detailed narrative plan before touching any design tools.

### Step 1: Determine Slide Sequence

Select and adapt a structure based on pitch type. For detailed templates, read `references/narrative-frameworks.md`.

**Common structures:**

| Pitch Type | Slides | Focus |
|---|---|---|
| Pre-Seed/Seed Investor | 12-15 | Team, problem, early traction |
| Series A+ Investor | 15-18 | Growth metrics, unit economics, moats |
| Sales/Product | 10-15 | Customer value, ROI, implementation |
| Partnership | 8-12 | Strategic alignment, mutual value |

Adapt the sequence to the user's strengths. If traction is exceptional, move it earlier. If the team is the strongest asset, elevate it. Build momentum toward the most compelling elements.

### Step 2: Create Detailed Content Outline

For each slide, document:

1. **Slide title** — Assertive statement, not a generic label ("We're Growing 40% Monthly" not "Traction")
2. **Core message** — The single most important point
3. **Supporting points** — 2-4 key facts or arguments
4. **Visual strategy** — How it should be presented visually
5. **Speaker notes** — 1-3 sentences for the presenter
6. **Data requirements** — Specific numbers or facts needed

**Example:**
```
Slide 7: "We've Grown 40% Month-Over-Month for 6 Months"

Core message: Consistent growth demonstrates product-market fit

Supporting points:
- 10,000+ active users, up from 500 six months ago
- 85% 30-day retention (industry benchmark: 25%)
- NPS score of 72
- Zero paid marketing — all organic/referral

Visual strategy: Large growth chart with key metric callouts

Speaker notes: "This isn't a spike — it's sustained, compounding growth 
driven by genuine product love. Our users are becoming our sales team."
```

### Step 3: Validate Narrative Arc

Before proceeding, check:

1. **Opening strength** — Do the first 3 slides hook attention?
2. **Logical flow** — Does each slide build to the next?
3. **Peak placement** — Is the strongest material in slides 6-9 (for a 15-slide deck)?
4. **Emotional resonance** — Are there human connection moments?
5. **Objection handling** — Are likely concerns addressed proactively?
6. **Clear ask** — Is the CTA unambiguous?

Present the complete outline to the user for approval before proceeding to design.

---

## Phase 3: Design & Technical Execution

Once the narrative plan is approved, build the slides. For detailed design principles and patterns, read `references/design-principles.md`.

### Key Design Rules

1. **Whitespace is strategic** — 40-60% whitespace per slide. Crowded slides lose impact.
2. **One idea per slide** — If a slide communicates multiple ideas, split it.
3. **Typography hierarchy** — Headlines 36-48pt (bold, assertive), body 18-24pt (3-5 bullets max), data callouts 48-72pt.
4. **Color discipline** — 3-4 colors max: primary (brand), accent (highlights), neutral (text/backgrounds).
5. **Data over bullets** — Prefer charts over tables, visualizations over text whenever possible.
6. **Readability test** — Key points should be readable at thumbnail size.

### Layout Patterns

- **Full-bleed**: Image/color background with text overlay (cover, section dividers)
- **Two-column**: Text left, visual right (most content slides)
- **Centered**: Single key message or data point (impact slides)
- **Grid**: Multiple items of equal importance (team, customers, features)

### Technical Implementation

Follow this sequence:

1. **Read pptx skill**: `view /mnt/skills/public/pptx/SKILL.md` — read the entire file
2. **Read html2pptx docs**: `view /mnt/skills/public/pptx/html2pptx.md` — read the entire file
3. **Verify html2pptx**: `npm list -g @anthropic/html2pptx` — install if needed
4. **Create shared CSS**: Define variables for colors, typography, and spacing
5. **Create HTML files**: One per slide, 960×540px (16:9), using row/col/fit classes (NOT flexbox)
6. **Convert to PPTX**: Write and run conversion script
7. **Validate**: Generate thumbnail grid for visual review
8. **Iterate**: Fix layout issues, text overflow, or visual problems

### Chunking Execution (for multi-phase builds)

When building in phases:

1. Build Phase A completely → validate → save to `/mnt/user-data/outputs/`
2. Build Phase B → append to existing PPTX → validate
3. Repeat for remaining phases
4. Final validation of complete deck

**Phase handoff checklist:**
- Save phase PPTX to outputs
- Save narrative plan for next phase
- Save CSS file for design consistency
- Document design decisions and current slide number

---

## Phase 4: Refinement & Delivery

After initial creation:

1. **Visual review** — Examine thumbnail grid for layout consistency
2. **Content refinement** — Adjust messaging, data presentation, or flow based on feedback
3. **Design iteration** — Styling, color, or layout modifications
4. **Export** — Final PPTX to `/mnt/user-data/outputs/` with clear filename
5. **Presentation tips** — Brief guidance on delivering the deck effectively

---

## Quick Reference: Slide Title Guidelines

Bad titles (generic labels):
- "Problem", "Solution", "Market Size", "Team", "Financials"

Good titles (assertive claims):
- "Small Businesses Lose $50K/Year to Manual Invoicing"
- "We Automate Invoicing in Under 60 Seconds"
- "A $12B Market Growing 25% Annually"
- "Built by the Team That Scaled Stripe's Infrastructure"
- "Profitable Unit Economics from Day One"

The title alone should tell the story if someone only reads headlines.
