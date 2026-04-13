# Microsoft Copilot — Scenario Classification

**Every Copilot user must know which scenario they are in before pasting any work-related content.**

The simplified "tier 1 / 2 / 3" mental model is useful for initial onboarding, but the complete picture is a **seven-scenario matrix** (plus Power Platform Copilot's opt-in lifecycle). For the full matrix, see `canonical-reference-table.md`.

This document provides the user-facing decision tree that maps user situations onto those scenarios.

---

## Quick Tier Mental Model (Onboarding)

For users encountering Copilot governance for the first time:

| Simplified tier | Real scenarios covered | Short rule |
|-----------------|------------------------|------------|
| **Tier 1 — Personal** | Consumer Copilot apps, Copilot via browser (personal account) | **Prohibited for work data.** Treat like ChatGPT Free. |
| **Tier 2 — Work chat** | M365 Copilot Chat (free, work account) | **Approved (Limited).** Non-sensitive work data only. No regulated PII, no customer data. |
| **Tier 3 — Paid + grounded** | M365 Copilot (licensed), Copilot via OWA/browser (work account), Power Platform Copilot (opt-in OFF) | **Approved** per org policy. Use for business data per data classification scheme. |
| **Tier 3+ conditional** | Power Platform Copilot (opt-in ON) | **Restricted.** Requires separate governance review before use. |

For precise policy decisions, always use the 7-scenario matrix in `canonical-reference-table.md`.

---

## Decision Tree

```
START: I'm about to use "Copilot" for work.

Q1. Which account am I signed in with?
│
├── Personal (@gmail.com, @outlook.com, @hotmail.com, @live.com, @msn.com)
│   └── SCENARIO: Consumer Copilot apps  OR  Copilot via browser (personal account)
│       CLASSIFICATION: Prohibited
│       → STOP. Do not paste any work data. Treat exactly like ChatGPT Free.
│       → On managed devices, this should be blocked by IT — report if accessible.
│
└── Work account (@company.com via Entra)
    │
    Q2. Am I inside a Power Platform app (Power Apps, Power Automate,
        Power BI, Copilot Studio, Dynamics 365)?
    │
    ├── YES
    │   └── Q2a. Has the tenant opted in to Power Platform Copilot
    │            feature improvement / review?
    │       ├── NO (default)
    │       │   └── SCENARIO: Power Platform Copilot (opt-in OFF)
    │       │       CLASSIFICATION: Approved
    │       │       → OK for business data per org data classification.
    │       │       → Audit coverage is partial — confirm the interaction is
    │       │         logged if required for compliance.
    │       └── YES
    │           └── SCENARIO: Power Platform Copilot (opt-in ON)
    │               CLASSIFICATION: Restricted
    │               → Microsoft may review and use data for feature improvement.
    │               → Requires org-level governance review before use.
    │               → If uncertain whether opt-in is enabled, ask IT/Power Platform admin.
    │
    └── NO (not Power Platform)
        │
        Q3. Do I have an assigned M365 Copilot license?
        │   (Check: Outlook, Word, Excel, Teams show Copilot icons inside the app)
        │
        ├── NO
        │   └── Q3a. Am I using Copilot inside OWA (Outlook Web) or in
        │            the browser Copilot sidebar signed in with work account?
        │       ├── YES
        │       │   └── SCENARIO: Copilot via OWA / browser (work account)
        │       │       CLASSIFICATION: Approved
        │       │       → EDP enforced, full audit, full tenant controls.
        │       │       → Grounding depends on license; without M365 Copilot
        │       │         license there's no tenant grounding.
        │       └── NO (Copilot web chat with work sign-in)
        │           └── SCENARIO: M365 Copilot Chat (free, work account)
        │               CLASSIFICATION: Approved (Limited)
        │               → Non-sensitive business data only.
        │               → No regulated PII, customer data, financial records.
        │               → EDP is enforced but no grounding-scoped controls
        │                 or sensitivity-label enforcement on this surface.
        │
        └── YES
            └── SCENARIO: M365 Copilot (licensed)
                CLASSIFICATION: Approved
                → EDP enforced, full tenant controls, full audit,
                  tenant-grounded on your email/SharePoint/Teams.
                → Safe for business data per org data classification.
                → Verify the admin baseline is in place (DLP, sensitivity
                  labels, Restricted SharePoint Search) before regulated data.
```

---

## Quick Identity Card

Print or paste into your org's Copilot onboarding:

```
┌──────────────────────────────────────────────────────────────────────┐
│ Which Copilot scenario am I in right now?                           │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Signed in with @gmail / @outlook.com / @hotmail.com / @live.com    │
│     → PROHIBITED. Personal only. Not for work data.                  │
│                                                                      │
│  Signed in with work account, Copilot web chat only                  │
│     → APPROVED (LIMITED). Non-sensitive data only.                   │
│                                                                      │
│  Signed in with work account, in OWA / browser Copilot sidebar       │
│     → APPROVED. Business data per org policy.                        │
│                                                                      │
│  Signed in with work account, Copilot icon in Word/Excel/Outlook     │
│     → APPROVED. M365 Copilot licensed. Full controls.                │
│                                                                      │
│  Inside Power Apps / Automate / BI / Copilot Studio / Dynamics      │
│     Default (opt-in OFF) → APPROVED                                  │
│     Opt-in ON → RESTRICTED — governance review required              │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## Common Traps

### "Copilot is built into Edge — is that personal or work?"

Depends on sign-in. The Edge Copilot sidebar uses whichever account is active. Check the account indicator in the Copilot panel:
- Personal MSA → **Prohibited scenario** (consumer / browser personal)
- Work Entra → **OWA/browser (work account)** scenario, which is Approved

### "I have Copilot Pro at home — is that work-approved?"

**No.** Copilot Pro (consumer paid, $20/month) is a consumer product. It does not have tenant grounding, Purview DLP, sensitivity label enforcement, or audit coverage. Classification: **Prohibited for work data.** Copilot Pro is essentially Tier 1 with better consumer features; it is not Tier 3.

### "M365 Copilot Chat says 'commercial data protection' — can I paste customer records?"

**No.** EDP is enforced, but Copilot Chat's scenario is classified **Approved (Limited)** because:
- No tenant grounding → no sensitivity-label retrieval scoping
- No Restricted SharePoint Search applicability (no grounding to restrict)
- Commercial data protection covers training and cross-tenant leakage, not regulated-data handling per your DPA with customers

Paste customer data only in M365 Copilot (licensed) under a fully configured admin baseline.

### "Is Teams meeting Copilot the same as M365 Copilot?"

If your tenant has M365 Copilot licenses and Copilot is enabled in Teams meeting settings, yes — same scenario as M365 Copilot (licensed). If only Teams transcription is enabled (no Copilot), that's a different product (Teams native transcription) with its own governance.

### "Power Platform Copilot feels like regular M365 Copilot to me — why the separate scenario?"

Different product, different data flow. Power Platform Copilot runs inside Power Platform apps and its audit coverage is partial (some interactions go to Power Platform admin telemetry rather than Purview Audit). The opt-in ON lifecycle also creates a data-sharing relationship with Microsoft for feature improvement that doesn't exist in M365 Copilot.

### "The tenant admin turned on Power Platform Copilot opt-in for 'AI feature improvement' — am I still safe to use it for customer data?"

**Depends.** Opt-in ON is classified **Restricted**. The admin needs to have reviewed the decision against your DPA with customers before opt-in was enabled. If you're a developer using it and don't know — check with your Power Platform admin before pasting customer data. Regulated industries (HIPAA, financial) should typically keep opt-in OFF.

### "I'm on a personal device using my work account — am I covered?"

Only if Conditional Access is configured to require a compliant device. If not, you are technically in an "Entra-signed" scenario but your device posture is unmanaged. Many orgs block this via Conditional Access. If you're unsure, err toward treating the session as tier 1 (personal) until IT confirms.

---

## Scenario Downgrade Patterns

Some user actions effectively change the scenario mid-session:

- **Uploading a file to Copilot Chat (free, work account):** the file is processed in the web-chat environment without tenant grounding controls. Treat as scenario "Approved (Limited)" — do not upload sensitivity-labeled or regulated content even though EDP covers the chat.
- **Sharing a Copilot-generated artifact externally:** sensitivity labels are preserved only if encryption travels with the content (rights-managed). Plain Copilot outputs pasted into an email are no longer label-protected.
- **Toggling Power Platform Copilot opt-in without governance review:** every interaction from the moment opt-in ON is enabled falls into the Restricted scenario. This is irreversible for past interactions — data already sent cannot be un-shared.
- **Using Copilot on an unmanaged device:** even with Entra sign-in, if Conditional Access is not configured, the session bypasses device-compliance enforcement. Treat as downgraded until IT confirms.

---

## What Users Should Do Before Each Session

1. Look at the signed-in account and the current Copilot surface → identify the scenario
2. Look up the scenario's Governance Classification in the canonical matrix
3. Decide: is the data I'm about to paste approved for that classification per org policy?
4. If unsure → do not paste. Ask IT/security.
5. If incident occurs (pasted regulated data into a Prohibited or Limited scenario) → report to security team immediately, do not wait.

This is the **user-side equivalent** of the Session Start Protocol — the behavioral discipline that substitutes for a harness hook (which Microsoft Copilot does not support).
