# Cursor Adapter

**Tier B — Context-file only. No hook-level enforcement available.**

---

## What Cursor Supports

Cursor reads a `.cursorrules` file (or `CURSOR.md`) at the project root automatically. This is **tier B** enforcement: the model sees the governance content as background context but may abbreviate or skip the Session Start Protocol on short prompts.

Cursor does not expose a lifecycle hook equivalent to Claude Code's `SessionStart`. As of 2026-04-12, the Cursor Rules system is the strongest mechanism available, and it has the same compliance-drift problem as any context file.

---

## Installation

```bash
# From the project root
cp /path/to/ai-governance-framework/templates/cursorrules ./.cursorrules
# or, to use the .md variant:
cp /path/to/ai-governance-framework/templates/CURSOR.md ./CURSOR.md
```

Edit the file to fill in project-specific context.

---

## User Verification Is Mandatory

Because Cursor enforcement is tier B, users must verify the Session Start audit block appeared in the first response. See `../../USER_VERIFICATION.md`.

If Cursor skips the protocol on first response, reply: `Read .cursorrules and execute the session start protocol before continuing.`

---

## Cursor-Specific Notes

- **Composer / Agent mode:** Rules apply in all modes but Agent mode is more likely to skip the protocol because it's trying to autonomously complete a task. Verify audit block still appears before approving any multi-file edit.
- **Privacy mode:** Enable Cursor's privacy mode (Settings → General → Privacy Mode) to prevent storage/training. Required for any project handling sensitive data.
- **Multiple rule files:** Cursor supports nested `.cursorrules` (since 2024) — one at the workspace root, additional ones in subdirectories. Use the root one for governance; subdirectory rules for local conventions only.

---

## When to Escalate to Tier A Tooling

If your project handles regulated data and you need stronger enforcement than Cursor can provide, consider using Claude Code for governance-sensitive work and reserving Cursor for low-risk editing tasks. The framework's adapter for Claude Code (`../claude-code/`) provides tier-A enforcement via `SessionStart` hooks.
