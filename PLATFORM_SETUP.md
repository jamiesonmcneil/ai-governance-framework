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

> **Note:** The `core/` and `org/` subfolders inside `.ai-governance/` are **optional**. In most setups, `config.json` points to external paths for Core and Org (central shared locations). Only create local subfolders if you want a symlink — e.g., `ln -s /central/ai-governance-framework .ai-governance/core`. The `config.json` paths always take precedence.

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

## Session Start Protocol (All Tools)

Every AI entry-point file (CLAUDE.md, GROK.md, CURSOR.md, etc.) enforces the same mandatory protocol at the start of every session:

1. **Read** `.ai-governance/config.json` from the project root
2. **Parse** all layers defined in `layers` and `custom_layers`
3. **Read** governance files from each active layer:
   - **Core:** RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md
   - **Org:** All files at the org layer path (if enabled)
   - **Project:** PROJECT_RULES.md, FORBIDDEN.md, CONVENTIONS.md (if they exist)
   - **User:** Role-based preferences (if present)
4. **Read** `.ai-governance/docs/PROGRESS.md` and `TASKS.md` (if they exist)
5. **Output** the confirmation block:

```
=== AI GOVERNANCE FRAMEWORK v2.0 ===
Active Layers:
  Core    → [resolved path] (immutable)
  Org     → [resolved path]
  Project → [resolved path]
  User    → [resolved path]
Precedence: Core (immutable) → Org → Project → User
Config confirmed: [date]
===
```

6. **Ask** the user: "Do these layers and paths look correct? Reply **YES** to continue."
7. **Wait** for explicit **YES**. Do not proceed with any work until confirmed.

---

## Claude (Anthropic)

### Claude Code (CLI / Desktop / Web)

**Entry-point file:** `CLAUDE.md` in the project root

Copy `templates/CLAUDE.md` and customize. Claude Code reads `CLAUDE.md` automatically at session start and executes the full Session Start Protocol above.

**Memory:** Claude Code supports persistent memory in `~/.claude/projects/[project]/memory/`. Use for user preferences and feedback. Do NOT store credentials.

### Claude (Web / API)

**System prompt:** Include the contents of `RULES.md` in the system prompt or as the first message. For long conversations, remind Claude of key rules periodically.

**Project Knowledge:** In Claude.ai Projects, upload `RULES.md`, `TRACKING.md`, and `CREDENTIAL_SECURITY.md` as project files.

---

## Grok (xAI)

### Grok (Chat / API)

**Entry-point file:** `GROK.md` in the project root

Copy `templates/GROK.md` and customize. Grok does not have native project-file loading — paste the `GROK.md` content at the start of each session, or use it as a system prompt via the xAI API.

The entry-point file executes the full Session Start Protocol (same steps as above) and includes all 14 core rules, the verification hierarchy, production safety protocol, credential security, and interaction protocol references.

---

## Cursor

### Cursor IDE (Agent / Composer / Chat)

**Entry-point file:** `CURSOR.md` in the project root (or `.cursorrules`)

Copy `templates/CURSOR.md` and customize. Cursor reads `.cursorrules` or project-level instruction files automatically and executes the full Session Start Protocol (same steps as above).

The entry-point file includes IDE-specific editing rules (read before editing, use existing components, apply changes to all files, no hard-coded values, security in every suggestion) in addition to the full core rules, verification hierarchy, production safety, and credential security.

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
├── .ai-governance/                     ← REQUIRED entry point
│   ├── config.json                     ← REQUIRED: single source of truth
│   ├── core/                           ← optional: symlink to central Core
│   ├── org/                            ← optional: symlink to central Org
│   ├── project/                        ← project-specific rules (team layer)
│   │   ├── PROJECT_RULES.md
│   │   ├── FORBIDDEN.md
│   │   └── CONVENTIONS.md
│   ├── docs/                           ← tracking files
│   │   ├── PROGRESS.md
│   │   └── TASKS.md
│   └── user/                           ← personal preferences (gitignored)
├── CLAUDE.md (or GROK.md, CURSOR.md)   ← REQUIRED: AI entry point
├── .github/copilot-instructions.md     ← Copilot config (condensed rules)
└── ... (your code)
```

> **Important:** The `core/` and `org/` subfolders are **optional**. In most setups, `config.json` points to external paths for Core and Org (central shared locations), and these subfolders do not exist. The `config.json` paths always take precedence.

Core and Org governance files live in central shared locations, not inside the project.
