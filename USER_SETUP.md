# Getting Started with AI Governance

**Time to complete: 5 minutes**

This framework applies to anyone using AI tools — not just developers. You do not need to install or configure anything. Read, understand, apply.

**Why this matters:**
- AI can produce incorrect or misleading results — even when they look right
- Sensitive data can be exposed if entered into the wrong AI tool
- Decisions made using AI still carry full accountability — yours, not the AI's

---

## The 3 Things That Matter

Before anything else, know these:

1. **Do not enter sensitive data into AI tools** — no passwords, customer info, financial data, or proprietary code into public AI (ChatGPT free, Claude free, etc.)
2. **Always verify what AI produces** — AI generates confident, well-formatted, wrong answers. Check before you use.
3. **You are responsible for the output** — if you act on AI-generated content without checking, the consequences are yours.

If you remember nothing else, remember these three.

---

## Quick Setup (All Users)

- [ ] Read the three rules above
- [ ] Disable AI training on every tool you use (see checklist below)
- [ ] Choose your usage type (next section)
- [ ] Acknowledge governance (your team's process — form, Slack, or config file)

**Training Opt-Out Checklist:**

| Tool | Where to Opt Out |
|------|-----------------|
| Claude | claude.ai/settings > Privacy > turn OFF "Help improve Claude" |
| ChatGPT | Settings > Data Controls > turn OFF "Improve the model for everyone" |
| GitHub Copilot | github.com/settings/copilot > uncheck "Allow GitHub to use my code snippets" |
| Gemini | myactivity.google.com/product/gemini > turn OFF "Gemini Apps Activity" |
| Cursor | Settings > General > enable Privacy Mode |

Do this now. It takes 30 seconds per tool.

---

## Choose How You Use AI

Pick the one that best describes your work:

### Developer

You write code, build features, or manage infrastructure with AI assistance.

**Required reading:**
- `SELF_GOVERNANCE.md` — what never goes into AI tools
- `RULES.md` — 14 behavioral rules for AI-assisted development
- `PRODUCTION_SAFETY.md` — if you touch production systems

**Setup:** Create your user config in `.ai-governance/user/` (see Developer Setup below).

### Analyst / Reporter

You use AI to analyze data, draft reports, or summarize information.

**Required reading:**
- `SELF_GOVERNANCE.md` — what never goes into AI tools

**Key rules for you:**
- Never upload real customer data, financials, or PII — use anonymized or aggregated data
- Verify all numbers, calculations, and claims AI produces
- Disclose AI involvement where required by your organization

### General AI User

You use AI for writing, brainstorming, or everyday tasks.

**Required reading:**
- This page (you're reading it now)
- For deeper context, review the summary section of `SELF_GOVERNANCE.md` (optional but recommended)

**Key rules for you:**
- Don't paste internal company information into free-tier AI tools
- Don't trust AI answers without checking — especially facts, names, and dates
- Use Team or Enterprise plans for any work involving company data
- If you are unsure whether something is sensitive, assume it is and do not include it

### Manager / Decision-Maker

You use AI for analysis, strategy, or reviewing AI-assisted work from your team.

**Required reading:**
- `SELF_GOVERNANCE.md` — what never goes into AI tools

**Key rules for you:**
- File uploads (PDFs, spreadsheets) are processed on remote servers — same risks as typed text
- AI plugins and integrations can access your calendar, email, and files — understand what you're granting
- AI must not be the sole basis for high-impact business, legal, or financial decisions

---

## How You Use AI Matters

Different tasks need different levels of care:

| What You're Doing | What to Watch For |
|-------------------|-------------------|
| **Writing** emails, documents, summaries | Review tone, accuracy, and that no sensitive context leaked into the prompt |
| **Analyzing** data, reports, financials | Verify every number. AI makes convincing math errors. Never trust calculations blindly |
| **Brainstorming** ideas, exploring options | Low risk — but don't paste confidential context to "get better ideas" |
| **Writing code** | Treat all AI code as untrusted. Review for security, test end-to-end, check that imports exist |
| **Producing final outputs** (customer-facing, published, submitted) | Maximum verification. If it goes to a customer, regulator, or the public — you own every word |

**Simple rule:** The closer the output gets to someone outside your team, the more carefully you verify it.

---

## Developer Setup (Optional for Others)

If you write code with AI tools, create a config file in `.ai-governance/user/`:

```json
{
  "role": "developer",
  "ai_tools": ["claude-code"],
  "governance_acknowledged": "2026-03-30"
}
```

Set `role` to your usage type. Set `ai_tools` to the tools you use. Set the date to today.

This file is gitignored — it stays on your machine only. AI tools that support session configuration (e.g., Claude Code, Cursor) can read this file at session start to understand your role and adjust guidance accordingly.

**Available roles:** `developer`, `analyst`, `general`, `manager`

---

## If Something Goes Wrong

If you accidentally sent sensitive data (passwords, customer info, financial data) to an AI tool:

1. **Stop** — close the conversation
2. **Document** what was sent, which tool, when
3. **Report** to your security or privacy team immediately
4. **Delete** the conversation if the platform allows it
5. **Rotate** any credentials that were exposed

Do not assume it's fine because you deleted the chat.

---

## Further Reading

| Document | Who It's For | What It Covers |
|----------|-------------|----------------|
| `SELF_GOVERNANCE.md` | Everyone | Complete safety guide — what never goes into AI, platform training policies, role-specific risks |
| `RULES.md` | Developers | 14 mandatory rules for AI-assisted development |
| `PRODUCTION_SAFETY.md` | Developers / DevOps | Protocol for production changes |
| `CREDENTIAL_SECURITY.md` | Developers / DevOps | How to handle secrets and API keys |
| `AI_ENVIRONMENTS.md` | IT / Security | Which AI environments are safe for which data |

Start with what's listed for your usage type. Everything else is optional unless your role or project requires it.

---

**Document Version:** 1.0
**Last Updated:** 2026-03-30
