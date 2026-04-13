# Gemini Adapter

**Tier B — System instruction parameter (API) or context file (IDE plugins).**

---

## What Gemini Supports

Gemini's governance surfaces vary by product:

| Product | Mechanism | Tier |
|---------|-----------|------|
| **Gemini API** (Vertex AI, AI Studio) | `systemInstruction` parameter | B |
| **Gemini in Workspace** (paid) | Admin controls + data boundary | C |
| **Gemini Code Assist** (IDE) | Workspace instructions file | B |
| **Gemini web/app** (consumer) | None (Activity panel controls only) | — |

None support a hook-equivalent `SessionStart` mechanism.

---

## Installation

### Gemini API (Vertex AI)

Include governance content in the `systemInstruction` field on every request:

```python
from google.genai import types

system_instruction = open('RULES.md').read() + '\n\n' + open('SELF_GOVERNANCE.md').read()

response = client.models.generate_content(
    model="gemini-2.5-pro",
    contents=user_prompt,
    config=types.GenerateContentConfig(
        system_instruction=system_instruction,
        # ... other config
    )
)
```

For production Vertex AI:
- Use paid Vertex AI (not free AI Studio) — free AI Studio may train on input
- Enable Cloud Audit Logs for all Gemini API calls
- Configure VPC Service Controls to keep data within your perimeter

### Gemini Code Assist (IDE plugin)

Workspace-level instructions are supported. Create `.idx/integrations.json` or the equivalent for your IDE plugin version and include rules content.

### Gemini in Workspace

Admin controls live in Google Workspace admin console. Configure:
- Data residency (region-bound processing)
- Admin-disabled training
- Gemini restricted to specific user groups

---

## User Verification Is Mandatory

Tier B enforcement for chat/code use. See `../../USER_VERIFICATION.md`.

---

## Tier Selection

| Gemini tier | Trains? | Approved for work? |
|-------------|---------|---------------------|
| Consumer (gemini.google.com) | Yes by default | No |
| Workspace (business tier) | No | Yes, per org policy |
| Vertex AI (paid API) | No | Yes |
| AI Studio (free API) | May train | No for sensitive data |

Always use paid Vertex AI for API integrations handling real data.

---

## Known Gaps

- No hook/lifecycle event for Session Start Protocol enforcement
- IDE plugin governance support varies by version — verify before relying on it
- Gemini in Workspace's data boundary is configurable but not opt-in by default; admin must enable it
