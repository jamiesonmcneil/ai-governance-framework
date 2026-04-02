# Basic Example Project

This is a minimal example showing how to use the AI Governance Framework in a real project.

## What This Demonstrates

- Governance configuration via `.ai-governance/config.json`
- Session workflow defined in `CLAUDE.md`
- Task tracking with `TASKS.md` and `PROGRESS.md`
- Project-level governance extensions (rules, prohibitions, conventions)

## How to Use

1. Copy this folder into your project (or use it as a reference)
2. Edit `.ai-governance/config.json` with your project's settings
3. Edit `CLAUDE.md` with your project's context
4. Start your AI tool (Claude Code, Cursor, etc.)

Expected workflow:
- Read `.ai-governance/config.json` and confirm your settings
- Load governance rules from the core framework
- Read `PROGRESS.md` and `TASKS.md` for current state
- Follow all rules during the session
- Update tracking files as work is completed

## Example Workflow

You ask: *"Create an API endpoint to fetch users"*

The AI should:
1. Add the task to `TASKS.md`
2. Read existing code to understand patterns
3. Implement the endpoint following project conventions
4. Test the endpoint end-to-end (not just "it compiles")
5. Update `PROGRESS.md` with what was done
6. Mark the task complete in `TASKS.md`

These steps reflect the governance framework's expected workflow.

## File Structure

```
basic-project/
├── .ai-governance/config.json              ← Project configuration (credentials, governance paths)
├── CLAUDE.md                  ← AI session instructions (read at session start)
├── docs/
│   ├── PROGRESS.md            ← What was done, when, and why
│   └── TASKS.md               ← Outstanding work items
└── .ai-governance/project/
    ├── PROJECT_RULES.md       ← Rules specific to this project
    ├── FORBIDDEN.md           ← Prohibitions specific to this project
    └── CONVENTIONS.md         ← Naming and style conventions
```
