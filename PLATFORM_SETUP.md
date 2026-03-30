# Platform Setup Guide

**How to configure each AI tool to use this governance framework.**

This section is primarily for developers or technical users configuring AI tools. Non-technical users should start with `USER_SETUP.md` instead.

Last Reviewed: 2026-03-30 | Next Review Due: 2026-06-30

The governance rules are tool-agnostic, but each AI platform has its own mechanism for loading instructions at session start. This guide covers the major platforms. **Platform configurations change frequently — review every 90 days and update as needed.** If a tool cannot enforce rules automatically, the user must enforce them manually. If full integration is not possible, reference RULES.md manually and use tracking files.

---

## Per-User Setup

Before configuring any AI tool, each user should complete the onboarding in `USER_SETUP.md`. This takes 5 minutes and covers all roles.

Developers should also create a `.ai-gov.user.json` file in the project root (this file is gitignored — it stays on your machine only):

```json
{
  "role": "developer",
  "ai_tools": ["claude-code"],
  "governance_acknowledged": "2026-03-30"
}
```

AI tools that support session configuration (e.g., Claude Code, Cursor) can read this file at session start and adjust their guidance based on your role. See `USER_SETUP.md` for details.

---

## Claude (Anthropic)

### Claude Code (CLI)

**Primary config file:** `CLAUDE.md` in the project root

```markdown
# Project Name — Claude Code Instructions

## Governance
- **Rules:** `.ai-gov/RULES.md` (read at every session start)
- **Tracking:** `.ai-gov/PROGRESS.md`, `.ai-gov/TASKS.md`
- **Credentials:** `.ai-gov/CREDENTIAL_SECURITY.md`
- **Production:** `.ai-gov/PRODUCTION_SAFETY.md`

## Session Start
1. Read `.ai-gov/RULES.md`
2. Read `.ai-gov/PROGRESS.md` for current state
3. Check `.ai-gov/TASKS.md` for outstanding items
4. Update PROGRESS.md with today's tasks before starting
```

**Memory:** Claude Code supports persistent memory in `~/.claude/projects/[project]/memory/`. Use for user preferences and feedback. Do NOT store credentials.

### Claude (Web / API)

**System prompt:** Include the contents of `RULES.md` in the system prompt or as the first message in a conversation. For long conversations, remind Claude of key rules periodically.

**Project Knowledge:** In Claude.ai Projects, upload `RULES.md`, `TRACKING.md`, and `CREDENTIAL_SECURITY.md` as project files.

---

## GitHub Copilot

### Copilot Chat (VS Code / IDE)

**Config file:** `.github/copilot-instructions.md` in the project root

```markdown
# Copilot Instructions

Follow these rules for all code suggestions and chat responses:

1. Never hard-code configuration values — use environment variables or database
2. Never include credentials, API keys, or secrets in code
3. Use parameterized queries — never string concatenation for SQL
4. Use UUIDs in URLs and API responses — never numeric database IDs
5. Follow existing project patterns — check before creating new ones
6. Use existing shared components — search before duplicating

## Project Conventions
[Include project-specific patterns, naming conventions, tech stack]
```

**Limitations:** Copilot does not have session memory or progress tracking. The `.github/copilot-instructions.md` file provides static context only. Use the `.ai-gov/` tracking files manually or via a different AI tool.

### Copilot Workspace

Upload governance files as repository context. Reference specific rules in your prompts.

---

## ChatGPT (OpenAI)

### Custom Instructions

**Settings → Personalization → Custom Instructions**

Paste a condensed version of the key rules:
```
When helping with code:
- Never hard-code values — use env vars or database
- Never include credentials in code or responses
- Use parameterized SQL queries only
- Verify work end-to-end before claiming completion
- Ask questions when uncertain — never assume
- Track all requested tasks — never forget items
- Answer questions at the end, not inline
- Use existing patterns — search before creating
```

### ChatGPT Projects

Upload `RULES.md` and `TRACKING.md` as project files. ChatGPT will reference them in responses.

### GPTs (Custom)

For a team GPT, include the full `RULES.md` in the GPT's instructions. Add `CREDENTIAL_SECURITY.md` and `PRODUCTION_SAFETY.md` as knowledge files.

---

## Cursor

### Rules File

**Config file:** `.cursorrules` in the project root

```
Follow the AI governance rules in .ai-gov/RULES.md for all code generation.

Key rules:
- No hard-coded values (use env vars, database, or config)
- No credentials in code
- Parameterized SQL queries only
- UUIDs in URLs, not numeric IDs
- Use existing components — search before creating
- Follow established project patterns

Read .ai-gov/RULES.md for the complete rule set.
```

### Cursor Composer

When using multi-file editing, include: "Follow all rules in .ai-gov/RULES.md. Check existing patterns before creating new code."

---

## Windsurf

### Rules File

**Config file:** `.windsurfrules` in the project root

Same content as `.cursorrules` — Windsurf uses an identical format.

---

## Gemini (Google)

### Gemini in Android Studio / VS Code

Use the project-level instruction file (varies by IDE plugin version). Include condensed rules as comments in a `GEMINI_INSTRUCTIONS.md` file referenced from your project config.

### Gemini API

Include `RULES.md` content in the system instruction parameter.

---

## Universal Setup (Any AI Tool)

If your AI tool doesn't have a native config mechanism:

1. Create `.ai-gov/RULES.md` in your project
2. At the start of every session, paste: "Read and follow all rules in .ai-gov/RULES.md before starting any work"
3. Periodically remind the AI of key rules during long sessions
4. Keep `PROGRESS.md` and `TASKS.md` updated manually if the tool doesn't auto-update

---

## File Structure

```
your-project/
├── .ai-gov.json                    # Project config (committed to git)
├── .ai-gov.user.json               # User config (gitignored — per-user)
├── .ai-gov/                        # Governance files
│   ├── RULES.md                    # All rules (mandatory read)
│   ├── CREDENTIAL_SECURITY.md      # Credential handling
│   ├── PRODUCTION_SAFETY.md        # Production protections
│   ├── TRACKING.md                 # How to use tracking files
│   ├── QA_STANDARDS.md             # Testing requirements
│   ├── PROGRESS.md                 # Active session log
│   ├── TASKS.md                    # Outstanding items
│   ├── HISTORY.md                  # Archived sessions
│   └── CONTEXT.md                  # Business context
├── CLAUDE.md                       # Claude Code config (references .ai-gov/)
├── .github/copilot-instructions.md # Copilot config (condensed rules)
├── .cursorrules                    # Cursor config (condensed rules)
└── .windsurfrules                  # Windsurf config (condensed rules)
```
