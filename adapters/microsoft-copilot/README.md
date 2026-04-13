# Microsoft Copilot Adapter

**Tier C — Admin-enforced. No session-level hook available.**

Last Reviewed: 2026-04-12 | Next Review Due: 2026-07-12

---

## Why Microsoft Copilot Is Different

Unlike Claude Code, Cursor, or GitHub Copilot, Microsoft Copilot is **not a developer tool with a session model**. It is embedded in Word, Excel, Outlook, Teams, and a web chat interface. It has:

- No project root, no `.ai-governance/` folder
- No context file analogous to `CLAUDE.md` or `.cursorrules`
- No lifecycle hooks
- No per-session initialization

This means **tier A (harness-enforced) and tier B (context file) enforcement are not available**. The framework's Session Start Protocol cannot be pushed to the model — there is no "session" and no file loader.

Enforcement for Microsoft Copilot is entirely **admin-side and user-discipline-side**:

- Admin-side: Microsoft Purview DLP, sensitivity labels, Entra conditional access, Copilot Control System, Restricted SharePoint Search
- User-side: tier awareness (which Copilot you are using), data-classification discipline, organizational training

---

## The Seven Scenarios of Microsoft Copilot

Microsoft's own canonical reference treats Copilot as seven distinct scenarios, not three tiers. Each has a different governance classification. **Know which scenario the user is in** — classification rules vary by scenario, not just by sign-in type.

The full authoritative matrix is in `canonical-reference-table.md`. Summary:

| Scenario | Identity | EDP | Foundation Training | Admin Controls | Audit | Business Data | Classification |
|----------|----------|-----|---------------------|----------------|-------|---------------|----------------|
| **M365 Copilot (licensed)** | Entra | Enforced | No | Full | Full | Yes | **Approved** |
| **M365 Copilot Chat (free, work acct)** | Entra | Enforced | No | Full | Full | Non-sensitive | **Approved (Limited)** |
| **Copilot via OWA / browser (work acct)** | Entra | Enforced | No | Full | Full | Yes | **Approved** |
| **Copilot via browser (personal acct)** | Personal MSA | Not enforced | Possible | None | None | No | **Prohibited** |
| **Consumer Copilot apps** | Personal MSA | Not enforced | Possible | None | None | No | **Prohibited** |
| **Power Platform Copilot (opt-in OFF)** | Entra | Enforced | No | Tenant | Partial | Yes | **Approved** |
| **Power Platform Copilot (opt-in ON)** | Entra | Enforced | Feature-only* | Tenant | Partial | Conditional | **Restricted** |

\* The Power Platform opt-in ON "training" refers to feature improvement / review, not global foundation-model pre-training. See `canonical-reference-table.md` for the full distinction.

### Terminology

- **EDP (Enterprise Data Protection)** — Microsoft's commercial data protection boundary. When Enforced, prompts and responses are covered by M365 data processing terms (no foundation-model training, no cross-tenant leakage, audit-capable).
- **Approved (Limited)** — EDP enforced, but the surface lacks grounding-scoped controls and sensitivity-label enforcement. Suitable for non-sensitive work content only.
- **Restricted** — conditionally allowed. Requires approval workflow and compensating controls before use. Typically requires a separate AI risk register entry.

### Simplified Tier Model (for onboarding only)

For initial user onboarding, a 4-tier mental model maps onto the 7 scenarios:

| Simplified tier | Covers scenarios | Short rule |
|-----------------|------------------|------------|
| **Tier 1 — Personal** | Consumer Copilot apps, browser personal | Prohibited for work data |
| **Tier 2 — Work chat** | M365 Copilot Chat (free, work) | Approved (Limited) — non-sensitive only |
| **Tier 3 — Paid / grounded** | M365 Copilot licensed, OWA/browser work, Power Platform opt-in OFF | Approved per org policy |
| **Tier 3+ Restricted** | Power Platform opt-in ON | Governance review required before use |

**Use the 7-scenario matrix for actual policy decisions.** The simplified tiers are for getting new users oriented, not for DLP scope or AUP drafting.

### Most Common Failure Patterns

1. **Personal-device shadow access.** A user with paid M365 Copilot at work opens the Copilot app from a personal device signed in with an MSA. They're in the Consumer Copilot apps scenario — Prohibited — even though they're licensed at work.
2. **Silent Power Platform opt-in.** A Power Platform admin enables the feature-improvement opt-in toggle without an explicit governance review, silently moving every Power Platform Copilot interaction from Approved to Restricted. Existing users do not get notified.
3. **Copilot Chat over-trust.** Users learn that Copilot Chat has "commercial data protection" and assume that covers regulated data. It does not — the scenario is Approved (Limited), not Approved. EDP covers training/leakage, not regulated-data handling under DPAs.

---

## How to Tell Which Scenario You Are In

See `tier-classification.md` for the full decision tree. Summary:

1. **Which account am I signed in with?**
   - `@gmail.com`, `@outlook.com`, `@hotmail.com`, `@live.com`, `@msn.com` → Consumer / browser personal scenario. **Prohibited.**
   - Work Entra account → continue.

2. **Am I inside a Power Platform app (Power Apps / Automate / BI / Copilot Studio / Dynamics)?**
   - Yes, opt-in OFF → Power Platform Copilot (opt-in OFF). **Approved.**
   - Yes, opt-in ON → Power Platform Copilot (opt-in ON). **Restricted.**

3. **Do I have an M365 Copilot license assigned?** (Copilot icons visible inside Word/Excel/Outlook/Teams)
   - Yes → M365 Copilot (licensed). **Approved.**
   - No → continue.

4. **Am I in OWA or browser Copilot sidebar signed in with work account?**
   - Yes → Copilot via OWA / browser (work account). **Approved.**
   - No (web chat only, copilot.microsoft.com) → M365 Copilot Chat (free, work account). **Approved (Limited).**

---

## Enforcement Mechanisms (Admin-Side)

All of these require Microsoft 365 or Entra admin privileges. They must be configured **before** users are given access to Copilot, not after.

### 1. Microsoft Purview DLP (Data Loss Prevention)

DLP policies inspect content being sent to Copilot Chat and block or warn based on classification. Requires Microsoft Purview or Microsoft 365 E5 (or Compliance add-on).

- Block sending credit card numbers, SSNs, passport numbers, health info to Copilot Chat
- Warn on "Confidential" or "Highly Confidential" sensitivity labels
- Log all policy hits to Microsoft 365 audit log

See `dlp-policy-template.md` for a starter DLP configuration.

### 2. Sensitivity Labels (Microsoft Information Protection)

Labels applied to documents, email, and Teams messages control whether Copilot can ground on them.

- Documents labeled "Confidential — No AI" will not be surfaced by Copilot retrieval
- Encrypted labels block Copilot from reading the content
- Must be deployed through Purview and applied by users or automatically by classification rules

### 3. Copilot Control System (CCS)

Announced 2024, available in M365 admin center. Controls what data sources Copilot can access:

- Restrict Copilot to specific SharePoint sites
- Disable grounding on OneDrive
- Turn off Copilot for specific user groups
- Audit Copilot queries and responses

### 4. Restricted SharePoint Search

Limits Copilot grounding to a curated list of SharePoint sites only, preventing "oversharing" discovery (Copilot surfacing documents the user technically has permission to see but would never have searched for).

Recommended for any org migrating from on-prem to SharePoint Online.

### 5. Entra Conditional Access

- Require compliant device for Copilot access
- Block Copilot for specific user groups, locations, or risk levels
- Enforce MFA before Copilot can be used with sensitive labels

### 6. Purview Communication Compliance

Monitors Copilot interactions for policy violations (harassment, code of conduct, confidential data exfil via Copilot summaries).

### 7. Data Residency / Commercial Data Boundary

For regulated industries (healthcare, finance, gov), configure the Microsoft commercial data boundary to keep Copilot processing within specific geographic regions (EU, US gov cloud, etc.).

---

## Minimum Baseline for Sensitive-Data Orgs

If your organization handles regulated data (HIPAA, SOC 2, PCI, GDPR-regulated PII), the **minimum baseline** before granting M365 Copilot or Power Platform Copilot access to any business data is:

- [ ] Users assigned M365 Copilot licenses are on Entra, not MSA
- [ ] Sensitivity labels deployed across the tenant (at minimum: Public / Internal / Confidential / Highly Confidential)
- [ ] Purview DLP policies configured for Copilot Chat and Copilot Experiences (see `dlp-policy-template.md`)
- [ ] Restricted SharePoint Search enabled for M365 Copilot grounding scope
- [ ] Conditional Access requires compliant device + MFA for Copilot
- [ ] Copilot audit logging enabled in Microsoft Purview
- [ ] **Power Platform Copilot opt-in state explicitly documented** (OFF by default; ON requires a completed governance review per `canonical-reference-table.md`)
- [ ] **Power Platform admin center** configured to restrict Copilot by environment where regulated data lives
- [ ] Consumer Copilot apps blocked on managed devices via Intune / AppLocker / Edge management policies
- [ ] Internal training published: scenario identification, data approved per scenario, incident reporting
- [ ] Incident response runbook includes "Copilot exposure" as a category, with distinct playbooks per scenario

**Consumer Copilot and browser-personal scenarios must be blocked on managed devices.** This is done at the device-management layer (Intune, Edge admin policies, AppLocker), not through Copilot settings — Microsoft Copilot itself doesn't know the device is managed.

**Power Platform Copilot opt-in is a governance decision, not a product setting.** Flipping it ON silently reclassifies every subsequent interaction from Approved to Restricted. Treat the toggle itself as privileged — require a change-management ticket, governance sign-off, and communication to users before flipping.

---

## User-Side Governance (Tier C's Fallback)

Since no session hook is possible, user-side discipline is the last line of defense. Every org adopting this framework should distribute:

1. **Which scenario am I in?** — a short card (see `tier-classification.md` and the canonical matrix in `canonical-reference-table.md`)
2. **What data can I paste?** — tied to the scenario's Governance Classification (Approved / Approved Limited / Restricted / Prohibited)
3. **The verification step from `USER_VERIFICATION.md`** — adapted: instead of checking for an audit block, users check whether they are in an approved scenario before using Copilot for work data
4. **Incident reporting** — if a Prohibited scenario was used for work data, or if regulated data was pasted into an Approved (Limited) or Restricted scenario, it's a security event
5. **Power Platform opt-in awareness** — developers working inside Power Platform must know whether opt-in is ON or OFF in their environment. If unknown, assume Restricted and ask their Power Platform admin.

---

## Framework Integration

The main framework's `SELF_GOVERNANCE.md` platform training-policy table covers Copilot at a high level. This adapter is the in-depth version. When the framework is adopted by an enterprise, the adopter should:

1. Read `SELF_GOVERNANCE.md` (baseline safety posture)
2. Read this adapter (Microsoft-specific admin guidance)
3. Configure the admin controls listed above
4. Publish the user-side guidance to all Copilot-licensed staff
5. Include Copilot in the org's quarterly governance review (policies drift quickly — Microsoft ships Copilot changes monthly)

---

## Limitations of This Adapter

This adapter can tell you **what to configure**. It cannot configure it for you. Admin changes to Purview, Entra, and M365 Copilot Control System must be made by a tenant admin through the respective admin portals. Microsoft does not expose these settings via a portable configuration file.

If your organization does not have Microsoft Purview or M365 E5 licensing, the tier-3 enforcement options (DLP, sensitivity labels, Restricted SharePoint Search) are not available and you should **not approve M365 Copilot for regulated data**. Use tier 2 (Copilot Chat with Entra) for general work queries and prohibit tier 1.
