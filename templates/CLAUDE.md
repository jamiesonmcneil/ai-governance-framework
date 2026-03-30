# [Project Name]

## Governance

- **Core governance:** `/path/to/ai-governance-framework/` — RULES.md (14 rules), INTERACTION_PROTOCOL.md, FORBIDDEN.md, PATTERNS.md, SELF_GOVERNANCE.md, AI_ENVIRONMENTS.md
- **Session config:** `.ai-gov.json` (read at session start, confirm with user)
- **Project governance:** `./project-governance/` (if exists — extends core, never overrides)

## Session Start

1. Read `.ai-gov.json` — if it exists, present config and ask user to confirm. If it doesn't exist, ask the configuration questions (see core README.md) and create it.
2. If `.ai-gov.user.json` exists, read it. Use the user's role to adjust guidance:
   - **developer:** Full governance — emphasize rules, patterns, verification, production safety
   - **analyst:** Emphasize data handling, verification, and output accuracy
   - **general:** Emphasize safe AI usage and verification basics
   - **manager:** Emphasize risk awareness, data sensitivity, and decision accountability
   - Role adjusts emphasis and verbosity — all rules remain universal
3. Read core governance: RULES.md (all 14 rules) and INTERACTION_PROTOCOL.md (message parsing and response protocol)
4. Read `docs/PROGRESS.md` and `docs/TASKS.md` (if they exist)
5. If `project_governance_path` is set in `.ai-gov.json`, read PROJECT_RULES.md and FORBIDDEN.md
6. Ensure the current task is clearly understood before writing any code
7. If any required file is missing (.ai-gov.json, PROGRESS.md, project governance), confirm with the user before proceeding

## Adoption Tier

This project uses **Tier [1/2/3]** governance:
- **Tier 1 (Personal):** SELF_GOVERNANCE.md + disable AI training + use placeholders
- **Tier 2 (Project):** + RULES.md + TRACKING.md + .ai-gov.json + project governance
- **Tier 3 (Production):** + PRODUCTION_SAFETY.md + CREDENTIAL_SECURITY.md + QA_STANDARDS.md + COMPLIANCE.md

## Tracking Files

| File | Purpose | Update Frequency |
|------|---------|-----------------|
| `docs/PROGRESS.md` | Active progress log | After each completed task |
| `docs/TASKS.md` | Outstanding work items | As items discovered/completed |

For lightweight projects (single session), a single PROGRESS.md combining progress and tasks is acceptable. Migrate to full tracking if the project grows beyond one session.

## Key Principles

- Use only approved tools and accounts for work data — no personal AI accounts or unapproved extensions
- Match AI execution environment to data sensitivity — never process sensitive data through public AI
- AI assists decisions — humans are accountable for outcomes

## Project Overview

[Describe your project: what it does, tech stack, key architecture decisions]

## Project-Specific Rules

[Add project-specific rules here, or reference ./project-governance/PROJECT_RULES.md]
