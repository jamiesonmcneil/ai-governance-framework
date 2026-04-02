# Platform Setup Guide (v2.0)

**How to configure each AI tool to use this governance framework.**

This guide is primarily for developers or technical users configuring AI tools. Non-technical users should start with `USER_SETUP.md` instead.

Last Reviewed: 2026-04-02 | Next Review Due: 2026-07-02

The governance rules are tool-agnostic, but each AI platform has its own mechanism for loading instructions at session start. This guide covers the major platforms. **Platform configurations change frequently — review every 90 days and update as needed.**

---

## Quick Setup (Any Project)

```bash
# 1. Create the governance folder
mkdir -p .ai-governance/project .ai-governance/docs

# 2. Copy config and entry-point template
cp /path/to/ai-governance-framework/templates/config.json .ai-governance/config.json
cp /path/to/ai-governance-framework/templates/CLAUDE.md ./CLAUDE.md
# (or GROK.md, CURSOR.md — pick the one matching your AI tool)

# 3. Edit .ai-governance/config.json — set your layer paths
# 4. Edit the entry-point .md file — add your project context
# 5. Add .ai-governance/user/ to .gitignore
```

---

## Per-User Setup

Before configuring any AI tool, each user should complete the onboarding in `USER_SETUP.md` (5 minutes, any role).

For developers, create a user preferences file in `.ai-governance/user/` (this folder is gitignored):

```json
{
  "role": "developer",
  "ai_tools": ["claude-code"],
  "governance_acknowledged": "2026-04-02"
}
```

---

## Claude (Anthropic)

### Claude Code (CLI / Desktop / Web)

**Entry-point file:** `CLAUDE.md` in the project root

Copy `templates/CLAUDE.md` and customize. Claude Code reads `CLAUDE.md` automatically at session start. The Session Start Protocol requires Claude to:

1. Read `.ai-governance/config.json`
2. List every active layer with exact paths
3. Confirm precedence (Core immutable, then layers in order)
4. Ask for explicit **YES** before proceeding

**Memory:** Claude Code supports persistent memory in `~/.claude/projects/[project]/memory/`. Use for user preferences and feedback. Do NOT store credentials.

### Claude (Web / API)

**System prompt:** Include the contents of `RULES.md` in the system prompt or as the first message. For long conversations, remind Claude of key rules periodically.

**Project Knowledge:** In Claude.ai Projects, upload `RULES.md`, `TRACKING.md`, and `CREDENTIAL_SECURITY.md` as project files.

---

## Grok (xAI)

### Grok (Chat / API)

**Entry-point file:** `GROK.md` in the project root

Copy `templates/GROK.md` and customize. When using Grok in a project context, paste the Session Start Protocol at the beginning of each session. The protocol requires Grok to:

1. Read `.ai-governance/config.json`
2. Parse all layers (`layers` + `custom_layers`)
3. Read governance files from each active layer (Core: RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md)
4. Read `.ai-governance/docs/PROGRESS.md` and `TASKS.md`
5. Output a confirmation block listing every active layer with exact paths
6. Ask for explicit **YES** before proceeding

**Note:** Grok does not have native project-file loading. Paste the `GROK.md` content at the start of each session, or use it as a system prompt via the xAI API. The entry-point file includes all 14 core rules, the verification hierarchy, production safety protocol, and interaction protocol references.

---

## Cursor

### Cursor IDE (Agent / Composer / Chat)

**Entry-point file:** `CURSOR.md` in the project root (or `.cursorrules`)

Copy `templates/CURSOR.md` and customize. Cursor reads `.cursorrules` or project-level instruction files automatically. The Session Start Protocol requires Cursor to:

1. Read `.ai-governance/config.json`
2. Parse all layers and read governance files from each (Core at minimum)
3. Read `.ai-governance/docs/PROGRESS.md` and `TASKS.md`
4. Output a confirmation block listing every active layer with exact paths
5. Ask for explicit **YES** before proceeding with any code changes

The entry-point file includes IDE-specific editing rules (read before editing, use existing components, apply changes to all files, no hard-coded values, security in every suggestion) in addition to the full core rules, verification hierarchy, and production safety protocol.

For Cursor Composer and Agent mode, the same governance applies — the Session Start Protocol runs before any multi-file edits or autonomous actions.

---

## GitHub Copilot

**Config file:** `.github/copilot-instructions.md` in the project root

Copilot does not support multi-file governance loading. Include a condensed version of the key rules:

```markdown
Follow these rules for all code suggestions and chat responses:

1. Never hard-code configuration values — use environment variables or database
2. Never include credentials, API keys, or secrets in code
3. Use parameterized queries — never string concatenation for SQL
4. Use UUIDs in URLs and API responses — never numeric database IDs
5. Follow existing project patterns — check before creating new ones
6. Use existing shared components — search before duplicating

Full rules: .ai-governance/config.json → Core layer → RULES.md
```

**Limitations:** Copilot does not have session memory or progress tracking. Use `.ai-governance/docs/PROGRESS.md` and `TASKS.md` manually or via a different AI tool.

---

## ChatGPT (OpenAI)

### Custom Instructions

**Settings → Personalization → Custom Instructions**

Paste a condensed version of the key rules (same as Copilot above).

### ChatGPT Projects

Upload `RULES.md` and `TRACKING.md` as project files. ChatGPT will reference them in responses.

### Custom GPTs

Include the full `RULES.md` in the GPT's instructions. Add `CREDENTIAL_SECURITY.md` and `PRODUCTION_SAFETY.md` as knowledge files.

---

## Windsurf

**Config file:** `.windsurfrules` in the project root

Same content pattern as Cursor — Windsurf uses an identical format. Copy `templates/CURSOR.md` content into `.windsurfrules`.

---

## Gemini (Google)

Use the project-level instruction file (varies by IDE plugin version). Include condensed rules as comments in a `GEMINI_INSTRUCTIONS.md` file. For the Gemini API, include `RULES.md` content in the system instruction parameter.

---

## Universal Setup (Any AI Tool)

If your AI tool doesn't have a native config mechanism:

1. Copy `templates/ENTRY_POINT_TEMPLATE.md` and customize for your tool
2. At the start of every session, paste the Session Start Protocol instructions
3. The AI will read `.ai-governance/config.json`, list layers, and confirm
4. Keep `.ai-governance/docs/PROGRESS.md` and `TASKS.md` updated

---

## Project File Structure (v2.0)

```
your-project/
├── .ai-governance/                     ← Governance entry point
│   ├── config.json                     ← Single source of truth (layer paths, settings)
│   ├── project/                        ← Project-specific rules (team layer)
│   │   ├── PROJECT_RULES.md
│   │   ├── FORBIDDEN.md
│   │   └── CONVENTIONS.md
│   ├── docs/                           ← Tracking files
│   │   ├── PROGRESS.md
│   │   └── TASKS.md
│   └── user/                           ← Personal preferences (gitignored)
├── CLAUDE.md                           ← Claude entry point
├── .github/copilot-instructions.md     ← Copilot config (condensed rules)
└── ... (your code)
```

Core and Org governance files are referenced by path in `config.json` — they live in central shared locations, not inside the project.
