# Grok (xAI) Adapter

**Tier B — System prompt or pasted entry-point file.**

---

## What Grok Supports

Grok does not have native project-file loading. Governance is loaded via one of:

1. **System prompt (xAI API)** — include `GROK.md` contents in the `system` message on every request
2. **Pasted entry-point (Grok chat)** — paste `GROK.md` content at the start of each session as the first user message

Neither is hook-enforced. Compliance depends on Grok's current model behavior.

---

## Installation

### xAI API

Load `templates/GROK.md` (or your customized version) and prepend to every API call:

```typescript
const systemPrompt = fs.readFileSync('GROK.md', 'utf-8');

const response = await fetch('https://api.x.ai/v1/chat/completions', {
  method: 'POST',
  headers: { 'Authorization': `Bearer ${apiKey}`, 'Content-Type': 'application/json' },
  body: JSON.stringify({
    model: 'grok-4',
    messages: [
      { role: 'system', content: systemPrompt },
      { role: 'user', content: userPrompt }
    ]
  })
});
```

### Grok chat (web / X integration)

Paste `GROK.md` content as the first message of each conversation. This is a tier D (user-invoked) pattern; compliance is weakest here.

---

## User Verification Is Mandatory

For API use, verify each response respects the governance (automated checks in your application layer).

For chat use, users must verify the audit block appeared in Grok's first response after the paste. See `../../USER_VERIFICATION.md`.

---

## Grok-Specific Notes

- **xAI API trains?** Check current policy — xAI has updated their data use terms multiple times. Confirm "no training" is contractually guaranteed for your API tier before sending sensitive data.
- **Grok in X/Twitter:** Treat as consumer tier. Not for work data.
- **Tool-calling:** Grok supports tool use; the same PII rule applies — never scrub user messages before sending to a tool-calling model (see `RULES.md` Rule 8).

---

## Known Gaps

- No persistent session memory
- No hook mechanism
- Context window may not hold full governance + conversation — prioritize `RULES.md` over supporting files if truncation is needed
