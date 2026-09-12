---
name: codebase-docs
description: >
  Use this skill whenever the user wants to document anything about their codebase — including new features, architectural decisions, bug reports, bug fixes, API changes, or module overviews. Trigger this skill for prompts like: "document this feature", "write docs for this PR", "create an architecture doc", "log this bug", "generate a changelog entry", "write a bug report", "document this module", "explain this system design", or "write a decision record". Also trigger when the user pastes code and asks for documentation, or says they want to "keep track of" changes, decisions, or issues. Do NOT skip this skill just because the request seems simple — even a one-liner like "document this fix" should use this skill to ensure consistent output structure.
---

# Codebase Documentation Skill

Generates structured, developer-friendly documentation for new features, architecture decisions, and bugs. Outputs are markdown files designed to live in the codebase (e.g., `docs/` folder or alongside code).

## Templates

All templates live in `assets/templates/`. Load the relevant file before generating a doc:

| Mode | Template file | When to use |
|---|---|---|
| 🟢 Feature Doc | `assets/templates/feature.md` | New feature, PR, enhancement, capability |
| 🏗️ Architecture Doc | `assets/templates/architecture.md` | System design, modules, data flow, decisions |
| 🐛 Bug Doc | `assets/templates/bug.md` | Bug report, bug fix, regression, incident |
| 📚 Docs Index | `assets/templates/docs-index.md` | `docs/README.md` — always update after any doc |

---

## Step 1 — Identify the Documentation Type

Determine which mode applies from the table above. If ambiguous, ask:
_"Is this for a new feature, an architecture decision, or a bug?"_

---

## Step 2 — Gather Context

Before writing, scan the relevant code if available. Look for:
- File names, function/class signatures, exported interfaces
- Comments or existing JSDoc/docstrings
- Related test files (they reveal intent)
- Git commit messages or PR descriptions if provided

If the user only gave a description (no code), proceed with what's available and use `<!-- TODO: fill in -->` placeholders.

---

## Step 3 — Load Template & Generate the Document

1. Read the matching template file from `assets/templates/`.
2. Fill in every section with real content. Drop optional sections only if they have nothing to say.
3. Strip all `<!-- ... -->` comment instructions from the final output.
4. Use today's date for any unfilled `Date` fields.

---

## Step 4 — Output Format

- Output as a fenced markdown code block so the user can copy it directly, **unless** a filesystem is available and the user asks to save it.
- If saving to disk, use these path conventions:
  - Features → `docs/features/<kebab-case-name>.md`
  - Architecture → `docs/architecture/<kebab-case-name>.md`
  - Bugs → `docs/bugs/<issue-id>-<kebab-case-title>.md` or `docs/bugs/<kebab-case-title>.md`

---

## Step 4b — Maintain the Docs README Index

After writing or updating any doc, always regenerate (or create) `docs/README.md` using `assets/templates/docs-index.md`.

### How to build the index

1. **Scan all existing docs** under `docs/` (features, architecture, bugs subdirectories).
2. For each file, extract its title (first `# Heading`) and frontmatter fields (`Status`, `Date`, `Severity`).
3. Render the index from `assets/templates/docs-index.md`.
4. If `docs/README.md` already exists, update only the relevant section table — do not overwrite unrelated sections.
5. If the `docs/` folder is new, generate the full README from scratch.

### Index update rules

- Sort each table by **Date descending** (newest first).
- Use relative links (e.g. `features/my-feature.md`), not absolute paths.
- If a doc has no `Status` or `Date`, use `—` as the cell value.
- Never remove rows unless the corresponding file is deleted.
- Always save to `docs/README.md` (never a subfolder README).

---

## Step 5 — Offer Extras (optional)

After the primary doc, offer one or more of these if relevant:

- **Changelog entry** — one-liner for `CHANGELOG.md`
- **README snippet** — short paragraph to paste into the module/repo README
- **ADR (Architecture Decision Record)** — if an arch doc covers a significant one-time decision
- **Mermaid diagram** — sequence, flowchart, or ER diagram based on the code

---

## Tips for Quality Docs

- Prefer **concrete over vague**: say "adds `POST /api/v2/export` endpoint" not "adds export functionality"
- For bugs: always fill in **Root Cause** — it's the most valuable section for future readers
- For architecture: the **Key Decisions** table is the most-read section; make it worth reading
- Use code blocks liberally — even partial/pseudocode is more useful than prose alone
- If you're not sure about something, use `<!-- verify: ... -->` inline rather than guessing
