---
name: ubiquitous-language
description: >
  Extract and define canonical domain terms into a UBIQUITOUS_LANGUAGE.md glossary.
  Use this skill whenever someone says "domain terms", "glossary", "DDD", "ubiquitous
  language", "we keep using different words for the same thing", "what do we call this",
  or when you notice inconsistent terminology in a codebase or conversation. Also trigger
  when starting a new project in a specialized domain (like Islamic finance, healthcare,
  legal) where precise terminology matters — getting the language right early prevents
  confusion in PRDs, code, and user-facing copy. Inspired by Eric Evans' Domain-Driven
  Design.
---

# Ubiquitous Language

You build glossaries that align everyone — product, engineering, design, users — on
the same words for the same concepts. This is Eric Evans' "ubiquitous language" from
Domain-Driven Design: a shared vocabulary used consistently in conversation, code,
documentation, and UI.

## Why This Matters

Terminology drift causes real bugs:
- A PRD says "purification" but the code calls it "tatheer" and the UI says "cleansing"
- "User" means the app user in product docs but the Plaid account holder in the API
- "Zakat" in the Hanafi context means something slightly different than in Ja'fari

When the words are wrong, the software is wrong. Getting terminology right early
prevents misunderstandings that compound into bugs, bad UX, and wasted time.

## Process

### Step 1: Gather the raw terms

Sources to mine (use whichever are available):

**In Claude Code:**
- Scan model/entity names in the codebase
- Read API endpoint names and parameters
- Check database table and column names
- Look at UI labels and copy
- Read existing docs, READMEs, PRDs

**In conversation:**
- Listen for terms the user uses
- Note when they use different words for the same concept
- Note when the same word seems to mean different things in different contexts

**From domain knowledge:**
- For specialized domains (Islamic finance, healthcare, legal), bring relevant
  domain expertise to identify terms that need precise definitions

### Step 2: Identify conflicts and ambiguities

Flag terms that are:
- **Overloaded**: Same word, multiple meanings ("account" = bank account? user account?)
- **Synonymous**: Multiple words for the same concept ("purification" vs "tatheer")
- **Imprecise**: Vague terms that mean different things to different people ("transaction")
- **Missing**: Concepts that exist in the domain but have no agreed-upon name yet

### Step 3: Define each term

For each term, provide:

```markdown
### [Canonical Term]

**Also known as:** [synonyms, alternate names — what people MIGHT call it]
**Definition:** [Clear, precise, one-paragraph definition]
**Context:** [Where this term is used — code, UI, docs, API]
**Not to be confused with:** [Similar terms that mean something different]
**Example:** [A concrete usage example]
```

### Step 4: Map to code

Show how the canonical terms should appear in code:

| Domain Term | Code Name | Where Used |
|-------------|-----------|------------|
| Zakat | `zakat` | Model, API, UI |
| Purification | `tatheer` | Model, calculation engine |
| School of thought | `madhab` | User settings, calculation |
| Nisab threshold | `nisab_threshold` | Zakat calculation |
| Halal screening | `halal_screen` | Stock analysis |

## Glossary Template

```markdown
# Ubiquitous Language: [Project/Domain Name]

**Last updated:** [date]
**Maintained by:** [who]

---

## How to Use This Document
- Use these exact terms in code, PRDs, UI copy, and conversation
- When a term has a canonical name, don't invent synonyms
- If you need a new term, add it here first and get agreement
- Code variable/function names should match these terms (in the appropriate case)

---

## Core Domain Terms

### [Term 1]
**Also known as:** ...
**Definition:** ...
**Context:** ...
**Not to be confused with:** ...
**Example:** ...

### [Term 2]
...

---

## Term Mapping

| Domain Term | Code Name | API Name | UI Label | DB Column |
|-------------|-----------|----------|----------|-----------|
| ... | ... | ... | ... | ... |

---

## Deprecated Terms
[Terms we used to use but have replaced. Listed here so people searching for the
old term can find the new one.]

| Old Term | Replaced By | Why |
|----------|-------------|-----|
| ... | ... | ... |
```

## Environment Detection & Output

### Claude.ai
- Save to `/mnt/user-data/outputs/UBIQUITOUS_LANGUAGE.md`
- Present the file

### Claude Code
- Save to `./docs/UBIQUITOUS_LANGUAGE.md` (or project root if no docs/ dir)
- If a glossary already exists, update it rather than replacing

## Handoff

"Glossary is ready. This should be referenced when writing PRDs, naming code entities,
and writing UI copy. Want me to run **write-a-prd** using these terms?"

## Anti-patterns

- Defining terms nobody actually disagrees about (don't over-glossary)
- Using different terms in the glossary than in the code (the whole point is alignment)
- Writing dictionary definitions instead of project-specific definitions
- Letting the glossary go stale — it should evolve with the project
- Being prescriptive about terms without checking with domain experts
