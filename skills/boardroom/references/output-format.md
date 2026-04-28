# Output Format Template

Generate the report following this exact structure. Replace bracketed placeholders with actual content.

---

```markdown
# Board Decision Report

**Question:** [the strategic question]
**Date:** [today's date]
**Board:** [template name, e.g. "Startup Growth Board"]
**Framework:** [framework name, or "Standard"]
**Mode:** [Full / Quick]

---

## Executive Summary

[2-3 paragraph synthesis recommendation — write this LAST after completing all rounds, but place it here in the output]

---

## Vote Summary

| Advisor | Role | R1 Vote | R1 Conviction | Final Vote | Final Conviction | Changed? |
|---------|------|---------|---------------|------------|-----------------|----------|
| [Name]  | [archetype label] | [YES/NO/CONDITIONAL] | [X]/10 | [YES/NO/CONDITIONAL] | [X]/10 | [Yes/No] |

[Repeat for each advisor. In Quick mode, Final Vote = R1 Vote, Changed = N/A]

---

## Round 1: Position Papers

### [Advisor Name] — [Archetype Label]

**Vote:** [YES / NO / CONDITIONAL] | **Conviction:** [X]/10
[If CONDITIONAL] **Conditions:** [what must be true]

[Position paper: 2-4 paragraphs. Must reference the specific business, its stage, revenue, team size, and market. No generic advice.]

**Projections:**
- **Estimated Cost:** [specific dollar amount or range with assumptions]
- **Revenue Impact:** [specific with timeline, e.g. "+$50K MRR within 6 months"]
- **Risk Assessment:** [top 2-3 risks with probability language]
- **Team Impact:** [specific to current team size and capacity]

---

[Repeat for each advisor with a horizontal rule between them]

---

## Round 2: Rebuttals & Final Positions

[SKIP THIS ENTIRE SECTION IN QUICK MODE]

### [Advisor Name]

**Final Vote:** [YES / NO / CONDITIONAL] | **Final Conviction:** [X]/10
**Mind Changed:** [Yes — reason / No]

[Rebuttal: 2-3 paragraphs. MUST name specific advisors they agree/disagree with and engage with their specific arguments. No generic responses.]

**Strongest Disagreement:** [Advisor Name] — [one sentence explaining why]
**Strongest Agreement:** [Advisor Name] — [one sentence explaining why]

**Advice to Founder:**
> [1-2 paragraphs of direct, actionable advice addressed to "you"]

---

[Repeat for each advisor]

---

## Synthesis

### Consensus
[2-3 paragraphs identifying where advisors agree and where they diverge. Name specific advisors.]

### Key Tensions
- [Tension 1: e.g. "Sarah Chen's growth-at-all-costs approach vs. Diana Volkov's risk-first stance"]
- [Tension 2]
- [Tension 3]

### Sharpest Insight
[The single most valuable, non-obvious takeaway from the entire debate — one paragraph]

### Blind Spots
- [Something no advisor addressed that the founder should consider]
- [Another gap in the collective analysis]

### Vote Shifts
[N] advisor(s) changed their vote between rounds. [Brief description of who and why, or "No advisors changed their vote" in Quick mode]

---

## Final Recommendation

[2-3 paragraphs of decisive, actionable guidance. Not hedged. Take a clear position. Include specific next steps with timeframes.]
```

---

## Formatting Rules

- Use `[YES]`, `[NO]`, `[CONDITIONAL]` in vote badges
- Conviction scores are always X/10
- Projections must include specific numbers grounded in the business context
- Each advisor section must be clearly separated with `---`
- The report should be self-contained and readable without additional context
- In Quick mode: omit Round 2 entirely, mark Final Vote columns as same as R1, mark Changed as "N/A"
