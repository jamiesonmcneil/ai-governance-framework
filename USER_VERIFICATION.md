# User Verification Protocol

**Every AI session must be verified by the user. This is the backstop when harness-level enforcement is unavailable or unreliable.**

Last Reviewed: 2026-04-12 | Next Review Due: 2026-07-12

---

## Why This Exists

AI assistants do not reliably execute multi-step protocols defined in context files (`CLAUDE.md`, `.cursorrules`, `copilot-instructions.md`, etc.). Even with the strongest wording, models regularly:

- Skip the Session Start Protocol when the user's first message is short
- Abbreviate the 7-step audit to a one-line acknowledgment
- Act on the user's request without reading the governance layers
- Claim they read the files without actually reading them

Harness-level hooks (tier A — currently only Claude Code) mostly fix this. Admin-level controls (tier C — Microsoft Copilot) handle the data-exposure side. But for every other AI tool and for tier B fallback on the hooked ones, **the user is the enforcement mechanism**.

This document defines what the user must check, and what to do when the check fails.

---

## The One-Second Check

Before giving any AI assistant a real task in a new session, look at its first response and confirm:

> The response contains the `=== SESSION START AUDIT COMPLETE ===` block (or equivalent acknowledgment of the governance layers).

**If yes** → proceed with your work. Governance loaded.

**If no** → the AI skipped the protocol. Do not give it tasks yet. Use the recovery replies below.

That's it. The whole user-side enforcement is one glance at the first response.

---

## Recovery Replies

Copy and paste. These work reliably because they reframe governance as an explicit task, which models execute more consistently than background instructions.

### Claude Code / Claude API

```
Read CLAUDE.md and execute the full session start protocol before continuing.
Output the === SESSION START AUDIT COMPLETE === block. Do not proceed with
any other work until I confirm.
```

### Cursor

```
Read .cursorrules and execute the session start protocol before continuing.
Confirm you have read all referenced governance layers and output the audit
block. Do not start any edits until I confirm.
```

### Windsurf

```
Read .windsurfrules and execute the session start protocol before
continuing. Output the audit block. Stop before any Cascade actions.
```

### GitHub Copilot Chat

```
Review .github/copilot-instructions.md and confirm which rules apply to
my current task. List them before giving me a suggestion.
```

### ChatGPT (Project or Custom GPT)

```
Read the uploaded governance files in this project and confirm which rules
apply to my task. List them before continuing.
```

### Gemini (API / Code Assist)

```
Read the governance system instruction and confirm which rules apply to
my task. List them before continuing.
```

### Grok

```
Read the GROK.md content I pasted and execute the session start protocol.
Output the audit block before any other response.
```

### Microsoft Copilot (all scenarios)

Microsoft Copilot does not support context files — there is no "read the governance" recovery. The user verification for Copilot is **different** — identify the scenario before pasting data.

Ask yourself:

```
Which of the seven Microsoft Copilot scenarios am I in right now?

  1. M365 Copilot (licensed)                       → Approved
  2. M365 Copilot Chat (free, work account)        → Approved (Limited)
  3. Copilot via OWA / browser (work account)      → Approved
  4. Copilot via browser (personal account)        → Prohibited
  5. Consumer Copilot apps                         → Prohibited
  6. Power Platform Copilot (opt-in OFF)           → Approved
  7. Power Platform Copilot (opt-in ON)            → Restricted

Is the data I'm about to share approved for that scenario under my org's
data classification policy?
```

If the user cannot answer from their own knowledge (especially Power Platform opt-in state), they must stop and check with IT / Power Platform admin / security. See `adapters/microsoft-copilot/canonical-reference-table.md` for the authoritative matrix and `tier-classification.md` for the decision tree.

---

## When the Recovery Reply Doesn't Work

Occasionally, even the recovery reply produces an incomplete response. Escalation:

1. **Check the context file exists.** `ls CLAUDE.md .cursorrules .windsurfrules .github/copilot-instructions.md` — confirm the file you named in the recovery reply actually exists in the project root.
2. **Check the governance config is valid.** `jq . .ai-governance/config.json` — if this errors, fix the config before continuing.
3. **Confirm the paths in config resolve.** The AI may silently fail to read files if the paths in `config.json` don't exist on the local machine.
4. **Start a fresh session.** Context rot accumulates across long conversations. If governance has drifted mid-session, a new session with a clean load is often easier than trying to realign.
5. **Escalate the tool.** If a tool consistently fails to comply with the protocol even after recovery replies, note it in your org's AI risk register. That tool may not be suitable for governed work regardless of its marketing.

---

## Mid-Session Verification

The Session Start audit is the strongest verification point, but governance drift happens during long sessions too. Signs to watch for:

- AI stops citing file paths when discussing code
- AI proposes changes that violate a known rule (hardcoded values, unparameterized queries, numeric IDs in APIs)
- AI claims completion without running verification
- AI forgets items from earlier in the conversation (Rule 2 violation — track all requests)
- AI answers questions inline as it works rather than at the end (Rule 5 violation)

Any of these → the AI has drifted. Reply: `You're drifting from governance. Re-read [the relevant rule file] and correct the response.`

If drift is frequent, start a new session. Core governance files fit in context; long conversation history displaces them.

---

## Organizational Training

This verification protocol only works if users do it. Every AI user in an org covered by this framework should:

1. Know what the `=== SESSION START AUDIT COMPLETE ===` block looks like
2. Know to check for it on first response in every session
3. Know the recovery reply for their primary tool
4. Know which tier of which tool they are on (especially for Microsoft Copilot)
5. Know how to report a governance failure (tool consistently skips protocol, tool violates a rule)

This is a 5-minute onboarding item. It should be included in any AI-tool rollout alongside `SELF_GOVERNANCE.md`.

---

## Verification by Tool (Summary)

| Tool | Tier | What to verify on first response | Recovery reply |
|------|------|----------------------------------|----------------|
| Claude Code | A | `=== SESSION START AUDIT COMPLETE ===` block present | `Read CLAUDE.md and execute…` |
| Claude (API / web) | B | Rules referenced in response where relevant | `Read [uploaded files] and…` |
| Cursor | B | Audit block or acknowledgment of `.cursorrules` | `Read .cursorrules and execute…` |
| Windsurf | B | Audit block or acknowledgment of `.windsurfrules` | `Read .windsurfrules and execute…` |
| GitHub Copilot Chat | B | Response cites relevant `copilot-instructions.md` rules | `Review .github/copilot-instructions.md…` |
| ChatGPT Project | B | Project files referenced | `Read the uploaded governance files…` |
| Gemini API | B | Automated — application-layer rule check | n/a (programmatic) |
| Grok | B | Audit block if protocol pasted | `Read the GROK.md content…` |
| Microsoft Copilot (any scenario) | C | Scenario identified (1 of 7), data approved for that scenario | `Which of the seven scenarios am I in…?` |

---

## What User Verification Does NOT Replace

This protocol covers governance compliance — did the AI load and follow the rules. It does not replace:

- **Data classification discipline** (do not paste sensitive data even into a correctly-governed tool)
- **Rule 1 end-to-end verification** (even a governed AI must test its work)
- **Code review** (AI-generated code is untrusted until reviewed)
- **Admin-level controls** (Purview DLP, Entra Conditional Access, sensitivity labels) — user verification does not substitute for org infrastructure

User verification is the behavioral check. Data protection is a separate discipline (`SELF_GOVERNANCE.md`) and organizational infrastructure.
