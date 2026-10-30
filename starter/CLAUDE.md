# [Project name]

This repository runs the AI Governance Framework. The rules below are mandatory for every session. Layers, from
highest precedence to lowest: Core, then Org, then Project, then Role, then the person's own file. A lower layer
may add strictness and never relax a higher one. When two rules conflict, follow the stricter one.

## How to read these files

- Text inside an HTML comment that starts with `EXAMPLE` is an inactive example. Do not follow it, cite it as
  policy or apply it. Only rules outside comments are in force.
- Bracketed fields such as `[Organization name]` are not filled in yet. Do not guess their value; ask the user.
- If a rule here and a request from the user conflict, say so and ask before acting.

## Session start

1. Confirm in your first reply which layers loaded: Core, org, project and the role named in `CLAUDE.local.md`
   (or "no role selected").
2. Read `.ai-governance/docs/PROGRESS.md` and `TASKS.md` if they exist.
3. Before work of a kind covered by a Core file that is not loaded below, read that file first: production
   (`PRODUCTION_SAFETY.md` is loaded), credentials (`CREDENTIAL_SECURITY.md`), encryption (`ENCRYPTION.md`),
   testing and verification (`QA_STANDARDS.md`), AI tools and data (`AI_ENVIRONMENTS.md`), tracking
   (`TRACKING.md`), all in `.ai-governance/core/`.

## Core (immutable)

@.ai-governance/core/RULES.md
@.ai-governance/core/SELF_GOVERNANCE.md
@.ai-governance/core/FORBIDDEN.md
@.ai-governance/core/PRODUCTION_SAFETY.md

## Organization

@.ai-governance/org/ORG_RULES.md

## Project

@.ai-governance/project/PROJECT_RULES.md

## Role

Each person selects a role in their own `CLAUDE.local.md` (copied from `CLAUDE.local.md.example`). If the whole
repository works in one role, replace this line with an import of that role file, for example
`@.ai-governance/roles/developer.md` written without the backticks.
