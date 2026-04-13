# Acme Organization Approved AI & Tech Stack (Org Layer)

**Approved AI Tools:**

| Tool | Tier | Approved For | Notes |
|------|------|--------------|-------|
| Claude (enterprise) | Anthropic Enterprise | Coding, drafting, analysis on internal data | Use Claude Code with `adapters/claude-code/` SessionStart hook for governance enforcement |
| Grok (xAI enterprise) | xAI Enterprise | Coding, analysis | Tier B enforcement only (no hook) |
| Cursor | Business / Enterprise | IDE coding | Privacy mode required |
| GitHub Copilot | Business / Enterprise | IDE code completion + Copilot Chat | No training; review every inline suggestion |
| **M365 Copilot (licensed)** | Microsoft 365 paid | Tenant-grounded summaries, drafting in Word/Excel/Outlook/Teams, analysis of email/SharePoint content | **Approved** — admin baseline (Purview DLP + sensitivity labels + Restricted SharePoint Search + Conditional Access) is in place |
| **M365 Copilot Chat (free, Entra)** | M365 plan included | General work questions, non-sensitive drafting | **Approved (Limited)** — no regulated PII, customer records, or financial data |
| **Copilot via OWA / browser (work account)** | Entra-signed | Outlook web Copilot, Edge sidebar Copilot | **Approved** — same EDP coverage as M365 Copilot |
| **Power Platform Copilot (opt-in OFF)** | Power Platform default | Building Power Apps / Automate / BI with AI | **Approved** — opt-in stays OFF unless governance review completes |

**Forbidden:**
- Public/consumer versions of any LLM for internal or customer work
- Microsoft Copilot signed in with personal MSA accounts (gmail.com, outlook.com, hotmail.com, live.com, msn.com) — **Prohibited** scenario per `adapters/microsoft-copilot/canonical-reference-table.md`
- Power Platform Copilot opt-in ON without a completed governance review (Restricted)

**Approved Versions:** Latest stable enterprise/business tier only.

**References:**
- `adapters/microsoft-copilot/canonical-reference-table.md` — authoritative 7-scenario matrix used to classify any Copilot use
- `adapters/microsoft-copilot/dlp-policy-template.md` — Purview DLP policies in force at Acme
- `USER_VERIFICATION.md` — every user must verify the governance audit block on first response of every AI session
