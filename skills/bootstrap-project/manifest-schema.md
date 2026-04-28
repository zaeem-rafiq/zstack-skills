# Project Manifest — Schema

The `## Project Manifest` section is a standardized block that appears at the top
of every repo's `CLAUDE.md`. It is the single source of truth for per-project
metadata that skills and scripts need at runtime (Linear IDs, deploy target,
archetype, phase, stack).

**Design contract:**

- **One file** — manifest lives inside `CLAUDE.md`, not a separate YAML or JSON file.
  Reason: every skill already reads `CLAUDE.md`. No new file to discover.
- **Heading-delimited** — parseable with plain `grep`/`awk` regex. No YAML parser needed.
- **Human-editable** — markdown list + tables. No angle brackets or alien syntax.
- **Machine-readable** — predictable key names (`- **Key**: value`) so a regex
  `^-\s+\*\*([^*]+)\*\*:\s*(.+)$` captures `(key, value)` pairs unambiguously.
- **Stable keys, flexible values** — keys are a closed set (see Fields below);
  values are free text.

---

## Fields

Every manifest MUST declare these fields, in this order:

| Key | Type | Example | Read by |
|-----|------|---------|---------|
| **Archetype** | enum | `nextjs-web` \| `ios-swiftui` \| `node-service` \| `content-site` | bootstrap-project, /init |
| **Name** | string | `Mirath` | shipping-and-launch, direct-response-copy |
| **Domain** | string (hostname) | `getmirath.com` | seo-content, shipping-and-launch |
| **Repo** | string (github path) | `github.com/zaeem-rafiq/mirath` | shipping-and-launch, /review |
| **Linear Project ID** | UUID | `90296466-335c-44c8-a4c7-76c33fe27954` | prd-to-issues |
| **Linear Team ID** | UUID | `1a6dcb82-d5c4-46cf-92ab-14ddaf3dc55f` | prd-to-issues |
| **Linear Keyword** | string (lowercase) | `mirath` | orchestrator (keyword routing) |
| **Local Path** | absolute path | `/Users/zaeemkhan/Documents/mirath` | orchestrator, bootstrap-project |
| **Deploy Target** | enum | `vercel` \| `app-store` \| `launchd` \| `github-pages` \| `cloudflare-pages` \| `none` | shipping-and-launch |
| **AI Features** | boolean | `true` \| `false` | tdd (chains eval-framework if true) |
| **Phase** | string | `pre-launch` \| `launched` \| `maintenance` \| `sunset` | grill-me, shipping-and-launch |

Optional additional keys a project may add (not reserved):

| Key | Example | Notes |
|-----|---------|-------|
| **Hard Deadline** | `2026-05-25` | Mirath has one; most don't |
| **Supabase Project URL** | `https://supabase.com/...` | Next.js archetype default |
| **Firebase Project ID** | `rafiq-prod` | iOS archetype default |

---

## Required subsections

After the key-value list, the manifest MUST include these two subsections:

### Stack

A table mapping layer → technology. Format:

```markdown
### Stack
| Layer | Technology |
|-------|-----------|
| Framework | Next.js (App Router) |
| Language | TypeScript |
| ... | ... |
```

Free-form — each archetype ships a pre-populated default.

### Knowledge Entry Points

A bullet list of the 3–5 most important reference files for this project.
Skills use this to know where to look FIRST before searching broadly.

```markdown
### Knowledge Entry Points
- `docs/PRODUCT_VISION.md`
- `knowledge/UBIQUITOUS-LANGUAGE.md`
- `docs/SERVICES.md`
```

---

## Full example (Mirath)

```markdown
## Project Manifest

- **Archetype**: nextjs-web
- **Name**: Mirath
- **Domain**: getmirath.com
- **Repo**: github.com/zaeem-rafiq/mirath
- **Linear Project ID**: 90296466-335c-44c8-a4c7-76c33fe27954
- **Linear Team ID**: 1a6dcb82-d5c4-46cf-92ab-14ddaf3dc55f
- **Linear Keyword**: mirath
- **Local Path**: /Users/zaeemkhan/Documents/mirath
- **Deploy Target**: vercel
- **AI Features**: true
- **Phase**: pre-launch
- **Hard Deadline**: 2026-05-25

### Stack
| Layer | Technology |
|-------|-----------|
| Framework | Next.js (App Router) |
| Language | TypeScript |
| Styling | Tailwind CSS |
| Auth | Clerk |
| Database | PostgreSQL via Supabase |
| AI | Claude API |
| Hosting | Vercel |
| Email | Resend |
| Analytics | PostHog |

### Knowledge Entry Points
- `docs/PRODUCT_VISION.md`
- `docs/ISLAMIC_FINANCE.md`
- `knowledge/UBIQUITOUS-LANGUAGE.md`
- `tasks/todo.md`
- `tasks/lessons.md`
```

---

## Parsing guidance

Skills that need a single field can extract it without a library:

```bash
# Extract Linear Project ID from CLAUDE.md
awk -F': ' '/^- \*\*Linear Project ID\*\*:/ {print $2; exit}' CLAUDE.md
```

```bash
# Extract all key-value fields as a flat list
awk '/^## Project Manifest/,/^### Stack/' CLAUDE.md \
  | grep '^- \*\*' \
  | sed -E 's/^- \*\*([^*]+)\*\*:\s*(.+)$/\1=\2/'
```

Node (for the bootstrap and register scripts):

```javascript
const readManifest = (claudeMdPath) => {
  const text = require('fs').readFileSync(claudeMdPath, 'utf8');
  const section = text.match(/## Project Manifest([\s\S]*?)### Stack/)?.[1] || '';
  const fields = {};
  for (const line of section.split('\n')) {
    const m = line.match(/^-\s+\*\*([^*]+)\*\*:\s*(.+)$/);
    if (m) fields[m[1].trim()] = m[2].trim();
  }
  return fields;
};
```

---

## Validation rules

A manifest is valid when:

1. The `## Project Manifest` heading exists exactly once in `CLAUDE.md`.
2. All 11 required fields are present (no blanks, no `[placeholder]`).
3. `Archetype` value matches a directory in `~/.claude/archetypes/`.
4. `Linear Project ID` and `Linear Team ID` are UUIDs (8-4-4-4-12 hex).
5. `Local Path` resolves to an existing directory.
6. `Deploy Target` is one of the enum values.
7. `AI Features` is exactly `true` or `false`.
8. `### Stack` and `### Knowledge Entry Points` subsections follow.

`bootstrap-project` validates on write. `shipping-and-launch` and `prd-to-issues`
validate on read (fail loud if missing — never silently default).

---

## Change management

Adding a new required field is a breaking change — every existing project needs
retrofit. Prefer adding optional fields first; promote to required only after
≥3 projects have adopted them voluntarily. Document the change in `CHANGELOG.md`
at the root of `~/.claude/repo-skill-template/bootstrap-project/`.
