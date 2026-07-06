# zstack-skills

A personal library of Claude skills and agent definitions for the dev, marketing, and creative workflows I use day-to-day.

## What's here

- `skills/` — individual skills (PRD writing, TDD, code review, security hardening, eval design, content production, design)
- `agents/` — agent persona definitions (security auditor, code reviewer, video producer, etc.)
- `.claude/commands/` — user-level Claude Code slash commands, including the SDLC chain
- `.claude-plugin/` — plugin manifest

## Using these

Each `SKILL.md` has a frontmatter `description` block that tells Claude when to invoke it. Edit skills, agents, and commands here first, then run `./sync-skills.sh --dry-run` followed by `./sync-skills.sh` to propagate them into `~/.claude/`.

Most skills assume a Claude Code or Claude.ai context. A few mention specific stack tools (Linear, Vercel, Supabase) but the patterns transfer.
