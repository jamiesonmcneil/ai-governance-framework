# Manager Setup — Completed Example

This shows what a completed manager onboarding looks like — including Microsoft 365 Copilot understanding, which is typically central to a manager's AI usage.

---

## Quick Setup (Done)

- [x] Read the 3 core rules (no sensitive data, verify outputs, you own the results)
- [x] Disabled training on personal Claude account (Settings > Privacy > "Help improve Claude" OFF)
- [x] Disabled training on personal ChatGPT (Settings > Data Controls > "Improve the model for everyone" OFF)
- [x] Confirmed Microsoft Copilot tier 1 (consumer) is **not used** for any work data — even on personal phone
- [x] Confirmed work device uses Entra-signed Microsoft Copilot only (M365 Copilot in Outlook/Word/Excel/Teams)
- [x] Usage type: **Manager**
- [x] Acknowledged governance (created `.ai-governance/user/manager.json`)

## Required Reading (Done)

- [x] `SELF_GOVERNANCE.md` — understood what never goes into AI tools
- [x] `USER_VERIFICATION.md` — practiced the one-second check on first response of every session; know the recovery reply for each tool
- [x] `adapters/microsoft-copilot/canonical-reference-table.md` — understood the 7 Copilot scenarios, can identify which I'm in by sign-in account + surface
- [x] `adapters/microsoft-copilot/tier-classification.md` — internalized the decision tree

## Microsoft Copilot Scenario Awareness

| Scenario | Where I encounter it | Approved for what |
|----------|---------------------|-------------------|
| **M365 Copilot (licensed)** — Approved | Copilot icons inside Outlook/Word/Excel/Teams on work device | Drafting docs, summarizing my own email/SharePoint/Teams, analyzing spreadsheets — per IT-published data classification |
| **M365 Copilot Chat (free, work)** — Approved (Limited) | copilot.microsoft.com signed in with @company.com | General work questions only — no regulated PII, customer records, or financials |
| **Copilot via OWA / browser (work)** — Approved | Edge sidebar / OWA Copilot panel signed in with work account | Same as M365 Copilot if licensed; chat-only otherwise |
| **Copilot via browser (personal MSA)** — Prohibited | Edge sidebar signed in with @gmail.com / @outlook.com | **Never for work data.** Treat as ChatGPT Free. |
| **Consumer Copilot apps** — Prohibited | Copilot mobile/desktop app signed in with personal MSA | **Never for work data.** Same as above. |
| **Power Platform Copilot (opt-in OFF)** — Approved | When my team uses Power Apps / Automate / BI / Copilot Studio with AI features | Default state — Approved per org policy |
| **Power Platform Copilot (opt-in ON)** — Restricted | Same surfaces, but tenant has opted in to feature improvement | **Requires governance review.** I check with our Power Platform admin before approving any team use. |

## User Config (Created)

File: `.ai-governance/user/manager.json`

```json
{
  "//": "MS Copilot scenarios are admin-enforced via Purview DLP — not listed in ai_tools.",
  "role": "manager",
  "ai_tools": ["claude", "github-copilot"],
  "governance_acknowledged": "2026-04-13"
}
```

## Tools Configured

- **M365 Copilot:** Verified my IT department has the Minimum Baseline in place — Purview DLP active, sensitivity labels deployed, Restricted SharePoint Search configured for grounding scope, Conditional Access requires compliant device + MFA. Confirmed via IT before relying on Copilot for sensitive content.
- **Claude (web, work account):** For drafting strategy docs and analysis where M365 Copilot isn't the right fit. Training disabled.
- **Personal Microsoft Copilot apps:** Removed from work phone. If installed, signed out of MSA.

## Pre-Use Check (Habit)

Before pasting any business data into any Copilot, I ask:
1. **Which sign-in account is active?** Personal MSA → stop. Work Entra → continue.
2. **Which surface?** Inside M365 app with Copilot icon → M365 Copilot (Approved). Web chat only → Copilot Chat (Approved Limited). Power Platform → check opt-in state.
3. **Is the data approved for that scenario per our org's data classification?** Unsure → don't paste, ask security.

This is the user-side equivalent of the Session Start Protocol. Microsoft Copilot does not have a session hook (no entry-point file, no `SessionStart` mechanism), so this discipline is the enforcement.

## Team Rollout Awareness

Before approving Copilot expansion to my team, I confirmed with IT:
- Sensitivity labels deployed and trained
- Purview DLP policies in test mode for at least 2 weeks before enforce
- Audit logs flowing to SIEM with retention ≥ 180 days
- Power Platform Copilot opt-in state documented and locked OFF for environments with regulated data
- Consumer Copilot blocked on managed devices via Intune/Edge admin

## If Something Goes Wrong

If I or someone on my team pasted regulated data into the wrong Copilot scenario:
1. Stop the conversation immediately
2. Document scenario (which Copilot, which sign-in, what data)
3. Report to security team within 24 hours — this is a privacy incident, not a typo
4. Verify Purview audit captured it for the incident record
5. Coach the person — not the tool

## Time Spent

~25 minutes (reading + setup + IT verification + scenario classification practice)
