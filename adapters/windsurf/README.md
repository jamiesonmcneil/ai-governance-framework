# Windsurf Adapter

**Tier B — Context-file only. No hook-level enforcement available.**

---

## What Windsurf Supports

Windsurf reads a `.windsurfrules` file at the project root automatically. Same enforcement model as Cursor — the model sees governance content as background context, compliance drifts on short prompts.

Windsurf does not support a `SessionStart`-style hook.

---

## Installation

```bash
# From the project root
cp /path/to/ai-governance-framework/templates/windsurfrules ./.windsurfrules
```

Edit the file to fill in project-specific context.

---

## User Verification Is Mandatory

Tier B enforcement. Users must verify the Session Start audit block appeared in the first response. See `../../USER_VERIFICATION.md`.

If Windsurf skips the protocol, reply: `Read .windsurfrules and execute the session start protocol before continuing.`

---

## Windsurf-Specific Notes

- **Cascade agent:** Windsurf's autonomous mode is more likely to skip governance preamble. Verify the audit block appeared before approving any Cascade run.
- **Telemetry:** Free tier collects telemetry. Use team/enterprise tiers for sensitive work.
- **Rule format:** `.windsurfrules` format is identical to `.cursorrules`. The `templates/windsurfrules` and `templates/cursorrules` files are interchangeable.
