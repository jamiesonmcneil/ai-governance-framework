# Claude Code Adapter

**Tier A — Harness-enforced via `SessionStart` hook.**

Last Reviewed: 2026-04-12 | Next Review Due: 2026-07-12

---

## What This Adapter Does

Claude Code supports lifecycle hooks configured in `.claude/settings.json`. This adapter registers a `SessionStart` hook that runs a small script at the start of every session (startup, resume, and after `/clear`). The script emits a **live instruction** into Claude's context telling it to execute the governance Session Start Protocol before responding to the user.

This is substantially more reliable than relying on `CLAUDE.md` alone. `CLAUDE.md` is loaded as background context; models routinely abbreviate or skip the protocol defined inside it, especially when the user's first message is short. The hook output is treated as a live system message, which Claude follows much more reliably.

**This adapter does not replace `CLAUDE.md`.** It complements it. `CLAUDE.md` still contains the full protocol content; the hook just forces Claude to execute it.

---

## Files

| File | Purpose | Where it lives when installed |
|------|---------|-------------------------------|
| `.claude/settings.json` | Hook configuration | `<project-root>/.claude/settings.json` |
| `.claude/hooks/session-start.sh` | Shell script emitting the protocol reminder | `<project-root>/.claude/hooks/session-start.sh` |

---

## Installation

From the root of the project that should adopt governance:

```bash
# 1. Copy the adapter into your project
cp -r /path/to/ai-governance-framework/adapters/claude-code/.claude ./

# 2. Make the hook script executable
chmod +x .claude/hooks/session-start.sh

# 3. Verify
cat .claude/settings.json
ls -la .claude/hooks/
```

If your project already has a `.claude/settings.json`, merge the `hooks.SessionStart` block in manually rather than overwriting.

---

## Verification

After installation, start a new Claude Code session in the project. Claude's first response should include the `=== SESSION START AUDIT COMPLETE ===` block defined in `CLAUDE.md`. If it does not, the hook did not fire or Claude ignored it — see Troubleshooting.

Per `USER_VERIFICATION.md`, **always verify the audit block appeared** before giving Claude any task. If it didn't, reply: `Read CLAUDE.md and execute the session start protocol before continuing.`

---

## Troubleshooting

**The hook script didn't run.**
- Check `chmod +x .claude/hooks/session-start.sh`.
- Claude Code logs hook execution in its debug output — start with `claude --debug` to confirm.
- Confirm `.claude/settings.json` is valid JSON (`jq . .claude/settings.json`).

**The hook ran but Claude still skipped the protocol.**
- Open the hook script and confirm the output is non-empty.
- Strengthen the wording in the hook output. The current script uses imperative language; if your specific model version is still drifting, make the instruction even shorter and more commanding.
- Reply to Claude: `Execute the session start protocol now.` This always works.

**The hook fails silently.**
- Hook scripts that exit non-zero are logged as errors. Ensure the script always exits 0.
- If `.ai-governance/config.json` doesn't exist yet, the script still emits a message telling Claude to offer to create it — this is intentional.

---

## What `settings.json` Does

The hook fires on three events:
- `startup` — new Claude Code session opened
- `resume` — resuming a prior session
- `clear` — after `/clear` has been used mid-session

On each, the script writes a short instruction block to stdout. Claude Code captures that stdout and injects it into Claude's context as a system reminder.

The hook runs in the project's working directory, so it can read `.ai-governance/config.json` and other local governance files.

---

## Security Notes

- The hook script runs on your local machine with your user permissions. It is part of the project repository — **review it before installing**, same as any code you copy in.
- The script does not transmit anything off-machine. It reads local files and writes to stdout only.
- Do NOT include credentials, tokens, or secrets in the hook output. It is visible to Claude (and therefore to Anthropic, subject to your plan's privacy terms).
