# My Project

## Governance

- **Core governance:** `/path/to/ai-governance-framework/` — RULES.md, INTERACTION_PROTOCOL.md, FORBIDDEN.md, PATTERNS.md, SELF_GOVERNANCE.md, AI_ENVIRONMENTS.md
- **Session config:** `.ai-gov.json` (read at session start, confirm with user)
- **Project governance:** `./project-governance/`

## Session Start

1. Read `.ai-gov.json` — present config, ask user to confirm
2. Read core governance: RULES.md (all 14 rules) and INTERACTION_PROTOCOL.md
3. Read `docs/PROGRESS.md` and `docs/TASKS.md`
4. Read `project-governance/PROJECT_RULES.md` and `FORBIDDEN.md`
5. Understand current task before writing any code
6. If any required file is missing, confirm with the user before proceeding

## Key Principles

- Use only approved tools and accounts for work data — no personal AI accounts or unapproved extensions
- Match AI execution environment to data sensitivity — never process sensitive data through public AI
- AI assists decisions — humans are accountable for outcomes

## During Work

- Follow RULES.md and INTERACTION_PROTOCOL.md — these define expected behavior for the session
- Track all tasks in TASKS.md
- Ensure work is verified end-to-end before considering it complete
- Update PROGRESS.md after each completed task

## On Completion

- Update PROGRESS.md with summary, files changed, decisions made
- Mark tasks complete in TASKS.md
- Document next steps

## Project Overview

[Describe your project here: what it does, tech stack, key decisions]

## Project-Specific Rules

See `./project-governance/PROJECT_RULES.md`
