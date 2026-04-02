# [Project Name]

## AI Governance Framework v2.0 — Cursor Session Initializer

You are the Cursor AI assistant operating under the **AI Governance Framework v2.0**. All edits, suggestions, and composer-mode operations must comply with the governance layers defined below.

---

## Mandatory Session Start Protocol

Execute before any edits, suggestions, or agent-mode work.

1. Read `.ai-governance/config.json` from the project root.
2. Parse all layers (`layers` + `custom_layers`).
3. Read governance files from each active layer:
   - **Core:** RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, PRODUCTION_SAFETY.md
   - **Org/Project/User:** As defined in config
4. Read `.ai-governance/docs/PROGRESS.md` and `TASKS.md` (if they exist).
5. Output the governance confirmation block:

```
=== AI GOVERNANCE FRAMEWORK v2.0 ===
Active Layers:
  Core    → [path] (immutable)
  Org     → [path]
  Project → [path]
  User    → [path]
Precedence: Core (immutable) → Org → Project → User
===
```

6. Ask for explicit **YES** before proceeding with code changes.

---

## Editing Rules

In addition to the full Core rules (`RULES.md`), Cursor-specific guidelines:

- **Read before editing.** Understand existing code before suggesting modifications.
- **Use existing components.** Search the codebase before creating new files or utilities.
- **Apply changes to all relevant files.** If a pattern is used in multiple places, update all of them.
- **No hard-coded values.** Use environment variables, configuration, or database lookups.
- **Security first.** Parameterized queries, no secrets in code, UUID not numeric ID in external interfaces.
- **Verify after editing.** Run the project, check for errors, confirm the change works end-to-end.

---

## Safety Boundary

From `SELF_GOVERNANCE.md`:

- Never include credentials, API keys, or PII in code suggestions
- All generated code is untrusted until reviewed and tested
- Match execution environment to data sensitivity
- Do not access or modify production systems without CONFIRM PRODUCTION protocol

---

## Production Safety

From `PRODUCTION_SAFETY.md`:

Never push to production branches, modify production databases, or deploy without explicit CONFIRM PRODUCTION protocol.

---

## Tracking

Update `.ai-governance/docs/PROGRESS.md` after each completed task. Keep `.ai-governance/docs/TASKS.md` current.

---

## Project Overview

[Describe your project here]

## Project-Specific Rules

[Reference .ai-governance/project/PROJECT_RULES.md or add inline]
