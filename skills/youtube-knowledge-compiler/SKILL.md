---
name: youtube-knowledge-compiler
description: >
  Compile YouTube video transcripts (and other raw content) into actionable workflow improvements
  that persist across sessions. Inspired by Karpathy's LLM Knowledge Base pattern. Use this skill
  whenever the user pastes a video transcript, shares a YouTube URL, says "I found a video on",
  "here's a transcript", "what can I learn from this", "anything useful here", "extract insights",
  or drops any raw learning content (article, podcast transcript, thread) that should be routed
  into skills, memory, CLAUDE.md, or the knowledge archive. Also trigger when the user says
  "knowledge base", "compile learnings", "what have we learned", "run a health check on learnings",
  or "what insights haven't been routed yet". This is the primary skill for turning consumed
  content into compounding workflow improvements.
---

# YouTube Knowledge Compiler

Turn raw content (transcripts, articles, threads) into persistent, routed workflow improvements.

## Philosophy

From Karpathy's LLM Knowledge Base pattern (April 2026): the goal is not to summarize content —
it's to **compile** it into structured knowledge that compounds over time. Raw content goes in,
actionable improvements come out, routed to where they'll actually be used.

## Workflow

### Step 1: Intake

Accept one of:
- **Pasted transcript** (from YouTube transcript feature, NotebookLM, or any source)
- **YouTube URL** (web_fetch the page, extract what's available from metadata/description)
- **Raw text** (article, thread, podcast transcript, etc.)

Capture metadata:
- **Source**: creator name, channel, publication
- **Title**: video/article title
- **Date**: when published
- **Topic tags**: infer 2-5 tags from content (e.g., `claude-code`, `prompting`, `agent-orchestration`, `design`, `evals`, `frontend`, `devtools`)

### Step 2: Extract Actionable Insights

Read the full transcript/content. Extract ONLY things that could improve the user's workflows.
Skip hype, motivation, and general commentary. For each insight, produce:

```
### Insight: [short title]
- **What**: One-sentence description of the technique/pattern/tool
- **Why it matters**: How this connects to the user's current stack (active products, agents, codebases, skill library, etc.)
- **Source**: [creator] — [title] — [date]
- **Tags**: [comma-separated tags]
- **Route**: [where this should go — see Step 3]
```

Categories to watch for:
- **Claude Code patterns**: CLAUDE.md structure, hooks, slash commands, agent workflows
- **Prompt engineering**: system prompts, structured output, chain-of-thought techniques
- **Agent orchestration**: multi-agent patterns, tool use, MCP servers, loop architectures
- **Eval & quality**: testing AI outputs, LLM-as-judge, error analysis
- **Design & frontend**: UI patterns, component architecture, styling approaches
- **Dev tooling**: IDE setup, git workflows, CI/CD, deployment patterns
- **Product/growth**: distribution, analytics, onboarding, retention
- **Domain-specific**: rules, standards, or methodologies relevant to the user's specific industry

### Step 3: Route Each Insight

Every extracted insight MUST be assigned a destination. No insight should be "just interesting" without a home.

| Route | When to use | Action |
|-------|-------------|--------|
| **Memory edit** | Persistent preference, tool choice, or workflow pattern the user should benefit from across all sessions | Use `memory_user_edits` tool to add |
| **Skill update** | Technique that improves an existing skill's instructions or output quality | Identify the skill, draft the edit, confirm with the user |
| **New skill** | Pattern substantial enough to warrant its own reusable workflow | Draft SKILL.md, confirm with the user |
| **CLAUDE.md patch** | Claude Code-specific instruction, hook, or agent behavior change | Draft the addition for the user to add to their repo |
| **Orchestrator config** | Change to the Linear → Claude Code pipeline behavior | Draft the config change |
| **Knowledge archive** | Valuable context that doesn't fit above but may be useful for future reference | Add to memory as background knowledge |
| **Not actionable** | Genuinely nothing to extract | State why — don't force it |

### Step 4: Execute Routes

For each routed insight:

1. **Memory edits** — execute immediately via tool
2. **Skill updates** — show the diff, confirm, then provide the updated file
3. **New skills** — draft the SKILL.md, confirm scope with the user
4. **CLAUDE.md patches** — output the exact text block to add
5. **Orchestrator configs** — output the specific change needed
6. **Knowledge archive** — add to memory with clear tagging

### Step 5: Summary Receipt

After processing, output a receipt:

```
## Compilation Receipt
- **Source**: [creator] — [title]
- **Date processed**: [today]
- **Insights extracted**: [count]
- **Routes**:
  - Memory edits: [count] (executed)
  - Skill updates: [count] (pending confirmation / executed)
  - New skills: [count] (drafted)
  - CLAUDE.md patches: [count] (provided)
  - Not actionable: [count]
```

## Health Check Mode

When the user says "run a health check" or "what haven't we routed":

1. Review recent memory edits tagged with source content
2. Check if any insights were marked "archive" that could now be promoted to a skill or CLAUDE.md patch based on new context
3. Surface any patterns across multiple compiled sources (e.g., "3 different videos mentioned X pattern — worth making a skill?")
4. Suggest content gaps: topics the user's stack would benefit from that haven't been covered yet

## Quality Filters

- **No fluff**: Skip motivational content, hype, or restated obvious advice
- **Testable claims only**: If a video says "X is better", ask: can we verify this in the user's codebase?
- **Attribution**: Every routed insight keeps its source for traceability
- **Dedup**: Before routing, check if a similar insight already exists in memory or skills
- **Domain accuracy**: For claims in specialized domains, hold to the same rigor as the rest of the work — verify terminology, distinguish concepts that look similar but aren't, never conflate.

## Integration with Existing Skills

This skill naturally chains with:
- **eval-framework** — when insights relate to AI quality/testing
- **grill-me** — when an insight suggests a significant workflow change worth stress-testing
- **skill-creator** — when a new skill is warranted
- **humanizer** — when extracted text needs to sound natural before embedding in docs
