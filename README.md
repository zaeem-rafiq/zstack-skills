# zstack-skills

A personal library of Claude skills and agent definitions for the dev, marketing, and creative workflows I use day-to-day.

## What's here

- `skills/` — individual skills (PRD writing, TDD, code review, security hardening, eval design, content production, design)
- `agents/` — agent persona definitions (security auditor, code reviewer, video producer, etc.)
- `.claude-plugin/` — plugin manifest

## Using these

Each `SKILL.md` has a frontmatter `description` block that tells Claude when to invoke it. Drop the `skills/` directory into your `.claude/skills/` (or your tool's equivalent), or use them as reference for writing your own.

Most skills assume a Claude Code or Claude.ai context. A few mention specific stack tools (Linear, Vercel, Supabase) but the patterns transfer.
