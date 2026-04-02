# My Project

## Governance

- **Core governance:** `/path/to/ai-governance-framework/` — RULES.md, INTERACTION_PROTOCOL.md, FORBIDDEN.md, PATTERNS.md, SELF_GOVERNANCE.md, AI_ENVIRONMENTS.md
- **Session config:** `.ai-governance/config.json` (read at session start, confirm with user)
- **Project governance:** `./.ai-governance/project/`

## Mandatory Session Start Protocol

1. Read `.ai-governance/config.json` — parse all layers
2. Read governance files from each active layer (Core at minimum: RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md)
3. Read `.ai-governance/docs/PROGRESS.md` and `TASKS.md`
4. Read `.ai-governance/project/PROJECT_RULES.md` and `FORBIDDEN.md`
5. Output the confirmation block:

```
=== AI GOVERNANCE FRAMEWORK v2.0 ===
Active Layers:
  Core    → [path] (immutable)
  Project → [path]
Precedence: Core (immutable) → Project
===
```

6. Ask for explicit **YES** before proceeding
7. Understand current task before writing any code

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

See `./.ai-governance/project/PROJECT_RULES.md`
