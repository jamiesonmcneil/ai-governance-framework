# ChatGPT Adapter

**Tier B — Context-file only via Custom Instructions, Projects, or Custom GPTs.**

---

## What ChatGPT Supports

ChatGPT has three mechanisms for persistent instructions:

1. **Custom Instructions** — applied to every conversation across your account
2. **Projects** — a scoped instruction set + uploaded files, applied to conversations in that project
3. **Custom GPTs** — a published GPT with baked-in instructions and knowledge files

None of these are hook-equivalent. All are tier B enforcement: the model sees governance as background context but compliance drifts.

---

## Installation

### Custom Instructions (all conversations)

Paste a condensed ruleset (not the full framework — ChatGPT's custom instruction field is character-limited). Recommended content:

```
For all technical work:
1. Never hard-code configuration values — use environment variables or database
2. Never include credentials, API keys, or secrets in code
3. Use parameterized queries — never string concatenation for SQL
4. Use UUIDs in URLs and API responses — never numeric database IDs
5. Follow existing project patterns — check before creating new ones
6. Use existing shared components — search before duplicating
7. Verify end-to-end before claiming completion

Before production changes, require "CONFIRM PRODUCTION" typed by user.
Answer questions at the end, not inline.
```

### Projects (recommended for team use)

Create a ChatGPT Project and upload:
- Your copy of `RULES.md`
- `SELF_GOVERNANCE.md`
- `CREDENTIAL_SECURITY.md`
- `PRODUCTION_SAFETY.md`

Set the project's Custom Instructions to: `Follow the uploaded governance files for all responses. At the start of every conversation, summarize which rules are relevant to the user's task.`

### Custom GPT (publishable governance assistant)

For orgs that want a shareable governed-ChatGPT:
1. Create a Custom GPT
2. Paste full `RULES.md` into Instructions
3. Upload the Core governance files as knowledge files
4. Publish to your workspace (do not publish publicly if governance content is org-specific)

---

## User Verification Is Mandatory

Tier B enforcement. Users must verify responses reference governance when relevant. See `../../USER_VERIFICATION.md`.

---

## Tier Selection

| ChatGPT tier | Trains on input? | Approved for work? |
|--------------|------------------|---------------------|
| Free | Yes by default | **No** — consumer tier |
| Plus (personal) | Yes by default (opt-out available) | **No** for org work |
| Team | No | Yes |
| Enterprise | No | Yes |
| API | No | Yes |

Never use free/Plus tiers for regulated data even with opt-out — the policy can be revoked, conversations are subject to safety review, and thumbs feedback re-enables training on the entire conversation.

---

## Known Gaps

- No Session Start Protocol enforcement
- No progress/task tracking (maintain `PROGRESS.md` and `TASKS.md` in a separate tool)
- Custom Instructions are truncated aggressively
- Projects feature is evolving — verify current capabilities in OpenAI docs
