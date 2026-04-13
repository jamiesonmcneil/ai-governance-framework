# Platform Setup Guide (v2.0)

**How to configure each AI tool to use this governance framework.**

This guide is primarily for developers or technical users configuring AI tools. Non-technical users should start with `USER_SETUP.md` instead.

Last Reviewed: 2026-04-02 | Next Review Due: 2026-07-02

The governance rules are tool-agnostic, but each AI platform has its own mechanism for loading instructions at session start. This guide covers the major platforms. **Platform configurations change frequently — review every 90 days and update as needed.**

> **See also:** `adapters/` at the repo root contains per-tool enforcement details, including the Claude Code `SessionStart` hook (tier A enforcement), Microsoft Copilot admin-side DLP guidance (tier C), and user-verification recovery replies for every supported tool. `USER_VERIFICATION.md` defines the one-second check every user must do on each session's first response.

---

## Enforcement Tiers

Before choosing a tool for governed work, understand its enforcement strength:

| Tier | Mechanism | Reliability | Tools |
|------|-----------|-------------|-------|
| **A** | Harness-level hook injects a live instruction at session start | Strong | Claude Code (`SessionStart` hook) |
| **B** | Tool auto-reads a context file; model compliance drifts on short prompts | Medium | Cursor, Windsurf, GitHub Copilot, ChatGPT Projects, Gemini system instruction, Grok |
| **C** | No in-session mechanism; enforcement is organizational (DLP, admin controls, sensitivity labels) | Strong for data protection, weak for behavior | Microsoft Copilot (all tiers) |
| **D** | User pastes governance at start of each session | Weak | Any tool with no native config |

**User verification (`USER_VERIFICATION.md`) is mandatory for all tiers.** Tier A hooks reduce — but do not eliminate — the need for the user to check that the audit block appeared on first response.

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

1. **Read** `.ai-governance/config.json` from the project root.
   - If it does not exist, inform the user and offer to create it from the framework template.
2. **Parse** all layers defined in the `layers` object (plus any in `custom_layers`).
3. **Read** the governance files from each active layer:
   - **Core:** RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md
   - **Org:** All files at the org layer path (if enabled)
   - **Project:** PROJECT_RULES.md, FORBIDDEN.md, CONVENTIONS.md, PATTERNS.md (if they exist)
   - **User:** Role-based preferences (if the user layer exists)
4. **Read** `.ai-governance/docs/PROGRESS.md` and `.ai-governance/docs/TASKS.md` (if they exist).
5. **Output** the following confirmation block with the actual resolved paths:

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
7. **Wait** for the user to reply **YES** (explicitly). Do not proceed with any work until confirmed.

---

## Claude (Anthropic)

### Claude Code (CLI / Desktop / Web) — Tier A enforcement recommended

**Entry-point file:** `CLAUDE.md` in the project root

**Recommended — install the `SessionStart` hook adapter for tier A enforcement:**

```bash
# Copy the hook adapter into your project
cp -r /path/to/ai-governance-framework/adapters/claude-code/.claude ./
chmod +x .claude/hooks/session-start.sh
```

The hook fires on every session start, resume, and `/clear`, injecting a live instruction into Claude's context that forces execution of the Session Start Protocol. This is substantially more reliable than `CLAUDE.md` alone. See `adapters/claude-code/README.md` for details.

**Also copy the entry-point file:**

```bash
cp /path/to/ai-governance-framework/templates/CLAUDE.md ./CLAUDE.md
```

Edit to fill in project-specific context. Claude Code reads `CLAUDE.md` automatically.

**Memory:** Claude Code supports persistent memory in `~/.claude/projects/[project]/memory/`. Use for user preferences and feedback. Do NOT store credentials.

### Claude (Web / API)

**System prompt:** Include the contents of `RULES.md` in the system prompt or as the first message. For long conversations, remind Claude of key rules periodically.

**Project Knowledge:** In Claude.ai Projects, upload `RULES.md`, `TRACKING.md`, and `CREDENTIAL_SECURITY.md` as project files.

---

## Grok (xAI)

### Grok (Chat / API)

**Entry-point file:** `GROK.md` in the project root

Copy `templates/GROK.md` and customize. Grok does not have native project-file loading — paste the `GROK.md` content at the start of each session, or use it as a system prompt via the xAI API.

The entry-point file executes the full Session Start Protocol: read `.ai-governance/config.json`, parse all layers, read Core files (RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md), output the confirmation block with exact paths, and wait for explicit **YES**. It also includes all 14 core rules, the verification hierarchy, production safety protocol, credential security, and interaction protocol references.

---

## Cursor

### Cursor IDE (Agent / Composer / Chat)

**Entry-point file:** `CURSOR.md` in the project root (or `.cursorrules`)

Copy `templates/CURSOR.md` and customize. Cursor reads `.cursorrules` or project-level instruction files automatically.

The entry-point file executes the full Session Start Protocol: read `.ai-governance/config.json`, parse all layers, read Core files (RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md), output the confirmation block with exact paths, and wait for explicit **YES**. It also includes IDE-specific editing rules (read before editing, use existing components, apply changes to all files, no hard-coded values, security in every suggestion) in addition to all 14 core rules, verification hierarchy, production safety, and credential security.

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

## Microsoft Copilot (Consumer / Entra / M365) — Tier C enforcement

**No context file, no hook. Enforcement is admin-side only.**

Microsoft Copilot is a different product category. It has no project root, no `.ai-governance/` folder, no lifecycle hooks. Enforcement happens through:

- Microsoft Purview DLP policies (block credentials, regulated data)
- Sensitivity labels (restrict Copilot grounding)
- Copilot Control System (data source scoping)
- Restricted SharePoint Search (grounding allowlist)
- Entra Conditional Access (device + MFA requirements)

And there are **seven distinct scenarios** (not three tiers) per Microsoft's canonical reference:

| Scenario | Classification |
|----------|----------------|
| M365 Copilot (licensed) | Approved |
| M365 Copilot Chat (free, work account) | Approved (Limited) |
| Copilot via OWA / browser (work account) | Approved |
| Copilot via browser (personal MSA) | Prohibited |
| Consumer Copilot apps | Prohibited |
| Power Platform Copilot (opt-in OFF) | Approved |
| Power Platform Copilot (opt-in ON) | Restricted |

See `adapters/microsoft-copilot/` for:
- `canonical-reference-table.md` — the authoritative 7-scenario matrix with EDP, training, audit, and classification fields
- `README.md` — the admin-enforcement model
- `tier-classification.md` — user-facing decision tree and simplified 4-tier onboarding model
- `dlp-policy-template.md` — starter Purview DLP policies (including Power Platform Copilot) with 8-week rollout plan

**Do not adopt M365 Copilot for regulated data without first implementing the admin baseline** listed in the adapter README.

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
