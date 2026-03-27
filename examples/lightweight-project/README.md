# Lightweight Example Project

This example shows the **minimal governance setup** for small projects, scripts, or one-off work where full tracking is overkill.

## When to Use Lightweight Mode

- Single-session projects
- Personal scripts or utilities
- Experiments and prototypes
- Any project that won't span multiple AI sessions

If the project grows beyond a single session, migrate to the full tracking model (see `/examples/basic-project`).

## What's Different

| | Full Mode (basic-project) | Lightweight Mode (this) |
|---|---|---|
| PROGRESS.md | Detailed, updated after each task | Single file, updated at session end |
| TASKS.md | Separate file with IDs and priorities | Combined into PROGRESS.md |
| HISTORY.md | Session archive | Not needed |
| project-governance/ | Full rules, forbidden, conventions | Not needed (core rules are enough) |

## File Structure

```
lightweight-project/
├── .ai-gov.json     ← Project configuration
├── CLAUDE.md         ← AI session instructions
└── PROGRESS.md       ← Combined progress + tasks (single file)
```

Core governance rules still apply — lightweight mode reduces tracking overhead, not safety expectations.
