# Microsoft Copilot — Framework Rule → Enforcement Mapping

**Purpose:** For every framework rule that has a Microsoft Copilot enforcement path, this document names the specific Microsoft control that enforces it, where to configure it, the exact value to set, and how to verify the control is actually working.

**Companion documents:**
- `canonical-reference-table.md` — the seven Copilot scenarios (EDP/audit/classification per scenario)
- `dlp-policy-template.md` — policy-by-policy walkthrough of what to configure
- `tier-classification.md` — user-facing decision tree
- `audit-queries.md` — KQL queries that verify each policy is working (Rule 1 verification for all DLP configs)
- `sensitivity-label-template.md` — the "Highly Confidential — No AI" label referenced throughout

**Terminology:** abbreviations expanded in `canonical-reference-table.md`. Key ones: **EDP** = Enterprise Data Protection, **SIT** = Sensitive Info Type, **CCS** = Copilot Control System, **CA** = Conditional Access, **DLP** = Data Loss Prevention, **MIP** = Microsoft Information Protection.

**Narrow-exception rule (per CONTRIBUTING.md):** inline PowerShell or Microsoft Graph snippets appear in this document **only where a specific Microsoft setting cannot be configured through the admin UI**. Most rows point to the admin portal path. This document is not a scripts dump — it is a mapping.

Last Reviewed: 2026-04-13 | Next Review Due: 2026-07-13 (Copilot admin surface changes monthly)

---

## How to Read This Document

Each row follows:

| Column | Meaning |
|--------|---------|
| **Framework rule / requirement** | The Core or Org rule being enforced, with citation |
| **Microsoft control** | The specific Microsoft product + feature that enforces it |
| **Where to configure** | Admin portal URL path, or "PowerShell/Graph only" when UI can't set it |
| **Exact setting / value** | The concrete configuration to apply |
| **Scenarios affected** | Which of the seven Copilot scenarios the control applies to |
| **Verification** | Reference to a KQL query in `audit-queries.md` that confirms the control is working |

"Scenarios affected" abbreviations:
- **M365** = M365 Copilot (licensed)
- **Chat-Entra** = M365 Copilot Chat (free, work account)
- **OWA/Browser** = Copilot via OWA / browser (work account)
- **Browser-Personal** = Copilot via browser (personal account)
- **Consumer** = Consumer Copilot apps
- **PP-Off** = Power Platform Copilot (opt-in OFF)
- **PP-On** = Power Platform Copilot (opt-in ON)

---

## 1. Credentials and Secrets (Core Rule 8, FORBIDDEN "Credentials in Code or Prompts", CREDENTIAL_SECURITY)

| Framework rule / requirement | Microsoft control | Where to configure | Exact setting / value | Scenarios affected | Verification |
|---|---|---|---|---|---|
| Never paste API keys, passwords, tokens into AI prompts | Purview DLP — sensitive info type (SIT) block rule | `compliance.microsoft.com` → Data loss prevention → Policies → New policy → Custom | Locations: *Microsoft Copilot Experiences* ON. Condition: content contains any of built-in SITs `Amazon S3 Access Key`, `Azure Access Token`, `Azure Connection String`, `Google Cloud API Key`, `General Password`, `General Symmetric Key`, `X.509 Certificate Private Key`, plus custom SIT matching `(?i)(api[_-]?key|secret|token|bearer)[\s:=]+['"]?[a-z0-9_-]{16,}`. Action: **Block with override not allowed**. Notify user. Incident report to security team. | M365, Chat-Entra, OWA/Browser, PP-Off, PP-On | `audit-queries.md` §Q1 "Credential-shape content accepted by Copilot" |
| JWT signing keys, DB connection strings (CREDENTIAL_SECURITY §What Goes Where) | Same DLP policy — extend SIT list | Same location | Add custom SIT for `(?i)postgres(ql)?:\/\/[^\s]+` and `(?i)(mongodb|mysql|redis):\/\/[^\s]+` connection URLs | Same | `audit-queries.md` §Q1 |
| Credentials NEVER retained in AI memory | Copilot conversation retention | `admin.microsoft.com` → Settings → Org settings → Microsoft 365 Copilot | Enable "Enhanced data handling". Retention: 30 days (shortest supported). Do **not** enable "Training on tenant data" (not currently an option but may appear) | M365 | `audit-queries.md` §Q2 "Copilot conversations older than retention limit" |

**Narrow exception — PowerShell required:** the Copilot SIT that inspects prompts for credentials is enabled via DLP policy UI, but assigning an existing policy to the *Copilot Experiences* location for a specific user group (not tenant-wide) requires PowerShell:

```powershell
# Purview DLP — scope a policy to a specific Entra group (UI is tenant-wide only)
Connect-IPPSSession
$group = "copilot-pilot-users"  # Entra group display name
Set-DlpCompliancePolicy -Identity "AI-Governance — Block Sensitive Data to Copilot" `
    -CopilotExperiencesLocationException $null `
    -CopilotExperiencesLocation $group
```

---

## 2. No Hard-Coded Values (Core Rule 6)

Applies indirectly — Copilot cannot stop a user from pasting a hard-coded value, but DLP can flag secrets-shaped hard-codings. The substantive enforcement is code review, not MS Copilot.

| Framework rule / requirement | Microsoft control | Where to configure | Exact setting / value | Scenarios affected | Verification |
|---|---|---|---|---|---|
| Hard-coded values should not include secrets (Rule 6 + Rule 8 overlap) | Covered by §1 above | — | — | — | — |

---

## 3. Production Safety (Core Rule 9, PRODUCTION_SAFETY)

| Framework rule / requirement | Microsoft control | Where to configure | Exact setting / value | Scenarios affected | Verification |
|---|---|---|---|---|---|
| Copilot access requires compliant device + MFA (defence in depth for production-adjacent data) | Entra Conditional Access policy | `entra.microsoft.com` → Protection → Conditional Access → Policies → New | Assignments: Users = all M365 Copilot-licensed users. Target resources = *Office 365* (includes Copilot). Grant controls = Require MFA + Require compliant device (Intune). Session controls = Sign-in frequency 12 hours; Persistent browser never | M365, Chat-Entra, OWA/Browser | `audit-queries.md` §Q3 "Copilot access from non-compliant device" |
| Separation of prod tenant from dev/test (PRODUCTION_SAFETY "Environment Classification") | Separate M365 tenants OR Purview data boundaries | Tenant-level architectural decision — not a single admin setting | If one tenant: deploy Purview Customer Lockbox + Commercial Data Boundary to scope Copilot processing regions | M365, OWA/Browser | Architectural review, not a query |
| No Copilot interaction on production-restricted sites | Restricted SharePoint Search for Copilot grounding | `admin.microsoft.com` → Copilot → Settings → Restricted SharePoint Search | Enable. Allowlist: explicit list of approved sites only. Explicitly deny: Finance, Legal, HR PII, and any site containing production credentials or customer data | M365 | `audit-queries.md` §Q4 "Copilot grounded on excluded SharePoint site" |

---

## 4. Security First / OWASP LLM Top 10 (Core Rule 8, SELF_GOVERNANCE, AI_ENVIRONMENTS)

| Framework rule / requirement | Microsoft control | Where to configure | Exact setting / value | Scenarios affected | Verification |
|---|---|---|---|---|---|
| Never process customer PII in external AI without approved environment | MIP sensitivity label + Purview DLP | `compliance.microsoft.com` → Information protection → Labels | Deploy label "Highly Confidential — No AI" per `sensitivity-label-template.md`. Encryption ON. Auto-apply rules detect PII SITs. Copilot cannot ground on encrypted content. | M365, OWA/Browser, PP-Off | `audit-queries.md` §Q5 "Copilot attempted to surface encrypted label content" |
| LLM06 Excessive Agency — least privilege for Copilot grounding | Copilot Control System + Restricted SharePoint Search | `admin.microsoft.com` → Copilot → Settings | Disable OneDrive grounding for users outside allowlist. Scope Teams message grounding per role. | M365 | `audit-queries.md` §Q6 "Copilot retrieval outside approved scope" |
| LLM09 Misinformation — verify AI claims | Not a MS control — governance process (audit-queries can detect but not prevent) | — | — | — | `audit-queries.md` §Q7 "Copilot responses lacking citations (grounding)" |
| Never use free-tier Copilot for work (SELF_GOVERNANCE platform table) | Intune + Edge management + AppLocker | `intune.microsoft.com` → Devices → Policies → Configuration | Block consumer Microsoft Copilot app. Edge: set policy `HubsSidebarEnabled` OFF for non-Entra accounts. AppLocker: deny `%ProgramFiles%\WindowsApps\Microsoft.Copilot_*` | Consumer, Browser-Personal (blocked at device layer) | `audit-queries.md` §Q8 "Managed device opened Consumer Copilot app" |
| Personal MSA Copilot session on work data = **Prohibited** scenario | CA "Block legacy authentication on personal accounts"; Edge/Intune restrictions above | Entra → CA → New policy | Block personal MSA identities from accessing tenant resources on managed devices | Consumer, Browser-Personal | `audit-queries.md` §Q9 "Personal MSA sign-in on managed device for Copilot" |

---

## 5. Power Platform Copilot Opt-In Governance (Adapter-specific, extends Core Rule 9)

| Framework rule / requirement | Microsoft control | Where to configure | Exact setting / value | Scenarios affected | Verification |
|---|---|---|---|---|---|
| Opt-in OFF by default; ON requires governance review | Power Platform admin center → Tenant settings → Copilot AI features | `admin.powerplatform.microsoft.com` → Settings → Tenant settings | `AI features` toggle **OFF** by default. Per-environment override locked OFF for environments with regulated data. Change-control ticket required before enable. | PP-Off (default), PP-On (Restricted) | `audit-queries.md` §Q10 "Power Platform Copilot opt-in toggled" |
| Opt-in state must be discoverable by users before pasting data | Power Platform admin notifications | Same portal → Notifications | Enable "Notify makers when tenant AI settings change". Subject line must mention "opt-in state" | PP-Off, PP-On | `audit-queries.md` §Q10 |
| Opt-in ON = Restricted classification (Microsoft may review interaction data) | Documented in canonical-reference-table; not a product toggle | — | Opt-in ON is a governance event — document in AI risk register, notify users, schedule 90-day review | PP-On | Process, not a query |

**Narrow exception — Graph required:** there is no single admin UI field that shows the Power Platform Copilot opt-in state as a boolean you can record for audit. You must query the Dataverse environment settings via Graph or the `Get-PowerPlatformSettings` cmdlet:

```powershell
# Get current tenant-level Copilot AI features opt-in state
Connect-PowerPlatformAdmin
Get-TenantSettings | Select-Object PowerPlatform.Governance.Copilot.EnabledForMakerExperiences
```

Schedule this to run daily and forward the result to SIEM so any flip is detected — see `audit-queries.md` §Q10 for the Sentinel/KQL side of this.

---

## 6. Audit Retention & Verification (Core Rule 1, Core Rule 14)

| Framework rule / requirement | Microsoft control | Where to configure | Exact setting / value | Scenarios affected | Verification |
|---|---|---|---|---|---|
| Every Copilot interaction must be auditable (Rule 1 verification) | Purview Audit | `compliance.microsoft.com` → Audit → Audit retention policies | Enable `CopilotInteraction` audit records. Retention: 180 days minimum, 7 years for regulated industries | M365, Chat-Entra, OWA/Browser, PP-Off, PP-On | `audit-queries.md` §Q11 "Copilot interactions not present in audit log" |
| Copilot events forwarded to SIEM | Purview → Defender XDR → Sentinel connector | Sentinel portal → Data connectors → Microsoft 365 | Connect `Office 365` + `Microsoft Purview Information Protection` connectors. Enable `CopilotInteraction` in both | All Entra scenarios | `audit-queries.md` all queries (require SIEM integration) |
| Session Start Protocol equivalent for Copilot (Rule 14) | Not a product feature — Copilot has no session model | — | User discipline per `tier-classification.md` + `USER_VERIFICATION.md` | All | N/A — governance process |

---

## 7. Scenario-Level Enforcement Summary

These rows enforce the classifications in `canonical-reference-table.md` for each scenario:

| Scenario | Classification | Primary controls | Verification |
|----------|----------------|------------------|--------------|
| M365 Copilot (licensed) | **Approved** | §1 DLP + §3 CA + §4 labels + §6 audit retention | Q1, Q3, Q5, Q11 |
| M365 Copilot Chat (free, work) | **Approved (Limited)** | §1 DLP + §3 CA + explicit user training on "non-sensitive only" | Q1, Q3 |
| Copilot via OWA / browser (work) | **Approved** | Same as M365 Copilot | Q1, Q3, Q5 |
| Copilot via browser (personal MSA) | **Prohibited** | §4 device-layer block (Edge/Intune/AppLocker) + §4 CA personal-MSA block | Q8, Q9 |
| Consumer Copilot apps | **Prohibited** | Same as browser-personal | Q8, Q9 |
| Power Platform Copilot (opt-in OFF) | **Approved** | §5 opt-in governance + Power Platform DLP per `dlp-policy-template.md` Policy 6a | Q10 |
| Power Platform Copilot (opt-in ON) | **Restricted** | §5 change-control + user notification + 90-day review cadence | Q10 |

---

## 8. Maintenance

- This document is part of the framework's Core → adapter sync protocol (see `../../CONTRIBUTING.md` "Dependent updates").
- Any change to Core RULES.md, FORBIDDEN.md, SELF_GOVERNANCE.md, or CREDENTIAL_SECURITY.md requires a review of this table.
- Microsoft changes admin surfaces (portal paths, cmdlet names, feature toggles) monthly — the `Where to configure` column is the column most likely to drift. Quarterly review verifies each path still resolves.
- When a new Core rule is added, either add a row here (if there is a Microsoft enforcement path) or add a one-line note stating no MS control applies (so future readers don't wonder).

---

**Document Version:** 1.0
**Last Updated:** 2026-04-13
