# Microsoft Copilot — Canonical Scenario Reference

**Authoritative matrix for every Microsoft Copilot surface.** Use this table when classifying a Copilot usage scenario for policy, DLP, and user guidance.

Source: Table provided by Microsoft Copilot itself (2026-04-12) as its recommended canonical reference, cross-checked against Microsoft Purview and M365 admin documentation.

Last Reviewed: 2026-04-12 | Next Review Due: 2026-07-12 (Copilot admin surface changes monthly — review quarterly)

---

## Terminology

| Term | Meaning |
|------|---------|
| **EDP** | Enterprise Data Protection — Microsoft's commercial data protection boundary. When Enforced, prompts and responses are covered by the M365 data processing terms (no training, no cross-tenant leakage, audit-capable). |
| **Foundation Model Training** | Whether the model's underlying parameters are updated from user input. "No" = your input does not improve the global foundation model. "Possible" = Microsoft/OpenAI may use input for model improvement on that surface. |
| **Optional Training / Review** | Whether there is an explicit user-facing opt-in for feature-level training or human review. Separate from foundation-model training. |
| **Tenant Enforcement** | Whether tenant admin controls (Purview, Copilot Control System, Conditional Access) apply. Full = all controls available. Tenant = scoped admin controls (e.g., Power Platform admin center). None = no admin path. |
| **Audit Coverage** | Whether Copilot prompts/responses appear in Purview Audit and SIEM integrations. Full = every interaction logged. Partial = some surfaces only. None = no audit trail. |
| **Governance Classification** | Policy outcome for this org's governance framework. See below. |

### Governance classifications

- **Approved** — safe for the full range of business data approved by the org's data classification scheme.
- **Approved (Limited)** — safe for non-sensitive business data only. Regulated, customer, financial, or labeled-sensitive data is **not** permitted on this surface even though EDP is enforced.
- **Restricted** — conditionally allowed with explicit safeguards. Requires an approval workflow, compensating controls, and usually a separate policy record.
- **Prohibited** — not permitted for any business data. Treat as a public AI tool.

---

## The Canonical Matrix

| Scenario | Identity Boundary | EDP Status | Foundation Model Training | Optional Training / Review | Tenant Enforcement | Audit Coverage | Allowed for Business Data | Governance Classification |
|---|---|---|---|---|---|---|---|---|
| **M365 Copilot (licensed)** | Entra ID | Enforced | No | No | Full | Full | Yes | **Approved** |
| **M365 Copilot Chat (free, work account)** | Entra ID | Enforced | No | No | Full | Full | Yes (non-sensitive) | **Approved (Limited)** |
| **Copilot via OWA / browser (work account)** | Entra ID | Enforced | No | No | Full | Full | Yes | **Approved** |
| **Copilot via browser (personal account)** | Personal MS acct | Not enforced | Possible | Yes | None | None | No | **Prohibited** |
| **Consumer Copilot apps** | Personal MS acct | Not enforced | Possible | Yes | None | None | No | **Prohibited** |
| **Power Platform Copilot (opt-in OFF)** | Entra ID | Enforced | No | No | Tenant | Partial | Yes | **Approved** |
| **Power Platform Copilot (opt-in ON)** | Entra ID | Enforced | No* | Yes (explicit) | Tenant | Partial | Conditional | **Restricted** |

\* Training here refers to feature improvement / validation for Power Platform Copilot, not global foundation model pre-training. The model parameters are not updated; Microsoft may use the data to improve the Power Platform Copilot feature specifically.

---

## Scenario Details

### M365 Copilot (licensed)

Paid M365 Copilot (~$30/user/month) grounded on tenant email, SharePoint, OneDrive, Teams, Loop. The only Copilot surface that reads your tenant data with user-scoped permissions. Full Purview DLP, sensitivity label enforcement, Copilot Control System, Restricted SharePoint Search all apply.

**Use for:** most business data per your data classification scheme. Requires the admin baseline (see `README.md` §Minimum Baseline).

### M365 Copilot Chat (free, work account)

Previously branded "Copilot with commercial data protection". Free with most M365 plans. Web chat only — **no tenant grounding**. EDP enforced: prompts are not used for training, data stays within the commercial boundary.

**Use for:** general work questions, non-sensitive drafting, brainstorming. Do **not** paste regulated data (HIPAA, financial PII, customer records) even though EDP is enforced — the "Approved (Limited)" classification reflects that this surface lacks grounding-scoped controls and sensitivity-label enforcement.

### Copilot via OWA / browser (work account)

Outlook Web App's Copilot panel and the Copilot sidebar in Edge / browser when signed in with a work Entra account. EDP enforced, full admin control, full audit. Similar governance profile to M365 Copilot (licensed) but surface is the browser rather than the installed M365 apps.

**Use for:** business data as approved by org policy. The licensing-tied grounding behavior depends on whether the user also has an M365 Copilot license.

### Copilot via browser (personal account)

Edge/browser Copilot sidebar when signed in with a personal MSA (gmail.com, outlook.com, hotmail.com, live.com, msn.com). EDP is **not** enforced. Foundation-model training is possible. No audit, no admin controls.

**Use for:** personal use only. **Prohibited for business data.** Block at the device/network layer on managed devices.

### Consumer Copilot apps

Standalone Microsoft Copilot app (Windows, mobile, web) signed in with a personal MSA. Same governance profile as browser Copilot with personal account — treat as a public AI tool. Copilot Pro (consumer paid, $20/month) does **not** change this classification; Copilot Pro is a consumer product.

**Use for:** personal use only. **Prohibited for business data.**

### Power Platform Copilot (opt-in OFF)

Copilot features inside Power Apps, Power Automate, Power BI, Copilot Studio, and Dynamics 365 — default configuration. EDP enforced, no training, tenant admin controls via Power Platform admin center, partial audit (not all Power Platform Copilot interactions flow to Purview Audit; some are Power Platform-specific telemetry).

**Use for:** business data within Power Platform applications. Default configuration is Approved.

### Power Platform Copilot (opt-in ON)

Same as above, but the tenant has opted in to feature improvement / validation (NOT foundation model training — see footnote). Microsoft uses interaction data to improve Power Platform Copilot features. Foundation model parameters are not updated. Requires explicit tenant admin opt-in.

**Why Restricted:** the opt-in means a portion of user interaction data is reviewed by Microsoft staff and used for product improvement, which creates a data-sharing relationship separate from standard EDP. Depending on your regulatory posture (HIPAA covered entities, GDPR data controllers, financial services under FINRA/SEC) this may conflict with your data processing agreement with customers.

**Before enabling opt-in:**
- Review your Data Processing Agreement with customers — does it permit sub-processing by Microsoft for product improvement?
- Document the opt-in decision in your AI risk register
- Communicate to users that their interactions may be reviewed
- Scope the opt-in to specific Power Platform environments rather than tenant-wide

**If already opt-in ON:** reclassify as Approved only after a formal governance review per scenario.

---

## How to Use This Matrix

### For admins

Use this table to:
1. Define per-scenario DLP policies (see `dlp-policy-template.md` — scenario-indexed)
2. Document which scenarios are Approved in your org's acceptable use policy
3. Configure Conditional Access rules per scenario (Entra-identified vs personal)
4. Audit for unapproved scenario usage in Purview logs

### For users

Use this table to answer "can I paste this into Copilot right now?":

1. Which scenario am I in? (check sign-in account and surface)
2. What's the Governance Classification for that scenario?
3. Is my data allowed for that classification?

If any of those questions are unclear, stop and ask IT/security.

### For framework adopters

Replace any simplified "3-tier" model with this 7-scenario matrix when publishing organizational Copilot policy. The simplified tiers (consumer / Entra-free / paid M365) are useful for initial onboarding but miss Power Platform and the OWA / licensed / chat distinctions.

---

## Change Tracking

Microsoft ships changes to Copilot surfaces and controls monthly. When a Copilot update ships:
1. Re-check each scenario in this table against Microsoft's current documentation
2. Note changes in `CHANGELOG.md` with date and source
3. Update dependent documents: `README.md`, `tier-classification.md`, `dlp-policy-template.md`, and the org's AUP

Known moving targets (watch for changes):
- Copilot Chat branding and naming (renamed at least twice in 2025)
- Audit coverage for Power Platform Copilot (partial today, may expand)
- Power Platform opt-in scope and granularity
- EDP boundary specifics for licensed Copilot in browser contexts
