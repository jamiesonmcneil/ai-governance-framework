# [Project Name]

## AI Governance Framework v2.0 — Claude Session Initializer

This project operates under the **AI Governance Framework v2.0**. All governance rules are mandatory and non-negotiable.

---

## Mandatory Session Start Protocol

**Execute this protocol at the start of every session, before any other work.**

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

6. **Ask** the user: "Do these layers and paths look correct? Reply YES to continue."
7. **Wait** for the user to reply **YES** (explicitly). Do not proceed with any work until confirmed.

---

## Core Rules (Always Active)

These rules are immutable. No layer may weaken, override, or create exceptions to them.

- **Rule 1:** Never claim completion without end-to-end verification
- **Rule 2:** Track ALL user requests — never forget items
- **Rule 3:** Document as you work — not after
- **Rule 4:** Ask when uncertain — never assume or guess
- **Rule 5:** Answer questions at the end — not inline
- **Rule 6:** No hard-coded values — database or config only
- **Rule 7:** Use existing components — never duplicate
- **Rule 8:** Security first — parameterized queries, no secrets in prompts, OWASP LLM Top 10
- **Rule 9:** Production safety — CONFIRM PRODUCTION protocol required
- **Rule 10:** Never revert working code
- **Rule 11:** Apply changes to all relevant files
- **Rule 12:** Follow established coding standards
- **Rule 13:** Writing style — first person singular ("I" not "we")
- **Rule 14:** Session protocol — start, during, end procedures

Full details: `RULES.md` in the Core layer.

---

## Safety Boundary

Before every session, internalize the safety boundary from `SELF_GOVERNANCE.md`:

- Never paste credentials, API keys, PII, or proprietary algorithms into AI prompts
- Treat ALL AI-generated code as untrusted input
- Match AI execution environment to data sensitivity
- Use only approved tools and accounts for work data

---

## Verification Hierarchy

From `QA_STANDARDS.md` — "it compiles" is NOT verification:

| Level | Description | Sufficient? |
|-------|-------------|-------------|
| 1 | Code compiles | No |
| 2 | No lint errors | No |
| 3 | Unit tests pass | Partial |
| 4 | Integration tests pass | Partial |
| 5 | End-to-end workflow verified | Yes |
| 6 | User acceptance confirmed | Yes |

Minimum for claiming completion: Level 5 (end-to-end workflow).

---

## Production Safety

From `PRODUCTION_SAFETY.md`:

Before ANY production operation, you must:
1. State: "This will modify PRODUCTION [system]"
2. List exactly what will change
3. Ask: "Type CONFIRM PRODUCTION to proceed"
4. Wait for the exact phrase — "yes", "ok", "do it" are NOT sufficient

---

## Interaction Protocol

From `INTERACTION_PROTOCOL.md`:

For every user message:
1. **Parse** — extract all tasks, questions, and discussion items
2. **Execute tasks** — complete all work items
3. **Answer questions** — together at the end, not inline
4. **Address discussion items** — provide analysis, ask for decisions
5. **Verify** — confirm nothing was skipped before responding

---

## Credential Security

From `CREDENTIAL_SECURITY.md`:

- Never store plaintext passwords anywhere
- Never commit `.env` files or credentials to version control
- Never paste credentials into AI prompts
- Credential storage method is configured in `.ai-governance/config.json`
- Encryption key and encrypted data NEVER in the same location

---

## Tracking

| File | Location | Purpose | Update Frequency |
|------|----------|---------|-----------------|
| PROGRESS.md | `.ai-governance/docs/` | Active work log | After each completed task |
| TASKS.md | `.ai-governance/docs/` | Outstanding items | As discovered/completed |

---

## Adoption Tier

This project uses **Tier [1/2/3]** governance:
- **Tier 1 (Personal):** SELF_GOVERNANCE.md + disable AI training + placeholders
- **Tier 2 (Project):** + RULES.md + TRACKING.md + config.json + project layer
- **Tier 3 (Production):** + PRODUCTION_SAFETY.md + CREDENTIAL_SECURITY.md + QA_STANDARDS.md

---

## Project Overview

[Describe your project: what it does, tech stack, key architecture decisions]

## Project-Specific Rules

[Add project-specific rules here, or reference .ai-governance/project/PROJECT_RULES.md]
