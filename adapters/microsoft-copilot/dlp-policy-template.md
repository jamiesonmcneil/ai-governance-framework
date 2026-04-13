# Microsoft Purview DLP Policy Template for Copilot

**Starter DLP policy configuration for Microsoft 365 Copilot and Copilot Chat.**

This is a template. Every organization must adapt it to its own regulatory obligations, data classification scheme, and risk tolerance. Work with your compliance, privacy, and security teams before deploying.

Last Reviewed: 2026-04-12 | Next Review Due: 2026-07-12

---

## Scope

Microsoft Purview DLP for Copilot applies at the following enforcement points:

| Scenario | DLP coverage | Notes |
|----------|--------------|-------|
| M365 Copilot (licensed) | Full | Grounding retrieval + response emission |
| M365 Copilot Chat (free, work account) | Partial | Content typed into chat inspectable; no grounding to scope |
| Copilot via OWA / browser (work account) | Full | Same DLP path as licensed M365 Copilot |
| Copilot via browser (personal account) | **Not covered** | Block at device/network layer |
| Consumer Copilot apps | **Not covered** | Block at device/network layer |
| Power Platform Copilot (opt-in OFF) | Partial | Purview DLP for Power Platform + Power Platform admin DLP |
| Power Platform Copilot (opt-in ON) | Partial + review | Same as above; reviewed interactions subject to Microsoft sub-processing |

See `canonical-reference-table.md` for the full per-scenario matrix.

---

## Policy 1 — Block High-Sensitivity Data in Copilot Chat

**Location:** Microsoft Purview compliance portal → Data Loss Prevention → Policies → New policy

**Template:** Custom

**Name:** `AI-Governance — Block Sensitive Data to Copilot`

**Location coverage:**
- Microsoft Copilot Experiences (toggle ON)
- Exchange email (optional but recommended — catches pasted data being emailed around)
- Teams chat (optional)

**Rule 1 — Block credentials and secrets:**

Conditions (Content contains any of the following sensitive info types):
- Credit Card Number (confidence: High, count: 1+)
- U.S. Social Security Number (SSN) (confidence: High, count: 1+)
- Passport Number (any country relevant to your org)
- AWS Access Key
- Azure Storage Account Key
- Azure SQL Connection String
- Google API Key
- Generic API Key (regex: `(?i)(api[_-]?key|secret|token)[\s:=]+['"]?[a-z0-9]{16,}`)

Action:
- **Block with override NOT allowed**
- Notify user: "Credentials and secrets cannot be sent to Copilot. Use a secrets manager instead."
- Generate incident report to: `security@yourorg.example`

**Rule 2 — Warn on regulated PII:**

Conditions:
- Documents labeled `Confidential` OR `Highly Confidential`
- Sensitive info types: Person Name + Date of Birth, Person Name + Medical terms, etc.

Action:
- **Warn with user justification required**
- Log all accepted justifications

---

## Policy 2 — Restrict Grounding on Labeled Content

**Purpose:** Prevent M365 Copilot (tier 3) from grounding on documents that carry specific sensitivity labels.

**Location:** Purview → Information Protection → Labels → Edit label settings

For the `Highly Confidential — No AI` label (create if it doesn't exist):

- Encryption: ON (this is what actually blocks Copilot — encrypted content is unreadable to Copilot)
- Content marking: "Highly Confidential — No AI Grounding" watermark
- Apply automatically by: classification rules that detect your highest-risk content types

**Effect:** Copilot will skip any document with this label when retrieving grounding context. It will not summarize, quote, or reference the content.

---

## Policy 3 — Audit All Copilot Interactions

**Location:** Purview → Audit → Audit log search

Ensure the following audit events are enabled and retained for ≥ 180 days:

- `CopilotInteraction` — every prompt and response
- `SearchQueryInitiatedCopilot` — what Copilot searched in tenant data
- `FileAccessed` with `AppId=Copilot` — which files Copilot grounded on
- DLP policy match events tied to Copilot

Forward to your SIEM (Sentinel, Splunk, etc.) for correlation with other security signals.

---

## Policy 4 — Block Copilot on Non-Compliant Devices

**Location:** Entra admin center → Conditional Access → New policy

**Name:** `Copilot — Require compliant device`

**Users:** All users licensed for M365 Copilot

**Target resource:** Microsoft 365 Copilot (app)

**Grant controls:**
- Require device to be marked as compliant (Intune)
- Require MFA
- Require approved client app (for mobile)

**Session controls:**
- Sign-in frequency: every 12 hours for Copilot
- Persistent browser session: never (force re-auth on new browser sessions)

---

## Policy 5 — Restricted SharePoint Search for Copilot Grounding

**Location:** Microsoft 365 admin center → Copilot → Settings → Restricted SharePoint Search

When enabled, Copilot grounds only on an explicit allowlist of SharePoint sites. Everything else is excluded from retrieval, regardless of individual user permissions.

**Recommended starter allowlist:**
- HR portal (for HR staff's Copilot queries about policies)
- Engineering wiki (for engineers' Copilot queries about internal docs)
- Marketing assets (for marketing staff)

**Explicit deny:**
- Finance SharePoint sites (regulated data)
- Legal SharePoint sites (privileged content)
- Any site containing customer data

This prevents "oversharing" — the scenario where Copilot surfaces a document to a user who technically has inherited permission but would never have searched for it directly.

---

## Policy 6a — Power Platform Copilot DLP

**Purpose:** Extend DLP coverage to Power Platform Copilot (Power Apps, Automate, BI, Copilot Studio, Dynamics 365).

**Location:** Power Platform admin center → Policies → Data policies

**Baseline Power Platform DLP policy:**

| Connector class | Business | Non-business | Blocked |
|-----------------|----------|--------------|---------|
| M365 connectors (SharePoint, Outlook, Teams) | Yes | — | — |
| Dataverse | Yes | — | — |
| Approved 3rd-party connectors (per org list) | Yes | — | — |
| Unapproved connectors (Twitter, Dropbox personal, etc.) | — | — | Blocked |
| Custom connectors | — | Yes (default) | — |

Power Platform Copilot is not a connector itself but its generated flows/apps can chain connectors. The DLP policy above limits what those generated artifacts can do.

**Power Platform Copilot opt-in governance:**

- **Tenant setting:** `Power Platform admin center → Tenant settings → Copilot AI features` — documents the tenant-wide opt-in state.
- **Environment-scoped override:** per-environment settings can lock opt-in OFF for environments that host regulated data.
- **Change control:** treat the opt-in toggle as a privileged operation requiring:
  - Change ticket with governance review attached
  - Sign-off from Data Protection Officer / Privacy lead
  - Communication to all Power Platform makers in affected environments at least 7 days before change
  - AI risk register entry documenting the decision and its rationale
  - Scheduled review at 90 days to verify the decision still holds

**Audit:**

Power Platform Copilot interactions flow to two separate logs:
- Microsoft Purview Audit (partial coverage — not all Power Platform Copilot events surface here)
- Power Platform admin telemetry (complete but less integrated with SIEM)

Forward both to your SIEM. Do not rely on Purview alone for Power Platform Copilot audit.

---

## Policy 6 — Communication Compliance for Copilot

**Location:** Purview → Communication Compliance → New policy

**Scope:** Copilot prompts and responses

**Detection categories to enable:**
- Confidential information leakage
- Code of conduct violations
- Regulatory compliance (if applicable: FINRA, HIPAA, GDPR keywords)
- Harassment / inappropriate content

**Reviewers:** Security + Compliance team

**Retention:** 7 years for regulated industries, 3 years minimum otherwise

---

## Rollout Plan

Deploy in this order. Do not shortcut — DLP policies configured poorly generate enormous false-positive noise.

1. **Week 1:** Enable auditing (Policy 3). Collect baseline data on what users are doing with Copilot.
2. **Week 2–3:** Deploy sensitivity labels (prerequisite for Policy 2). Run in "recommend" mode, not "enforce".
3. **Week 4:** Enable Policy 1 in **test mode** (audit only, no blocking). Review matches with compliance team. Tune rules to reduce false positives.
4. **Week 5:** Enable Restricted SharePoint Search (Policy 5).
5. **Week 6:** Enable Conditional Access (Policy 4).
6. **Week 7:** Flip Policy 1 from test mode to **enforce**. Communicate to users in advance.
7. **Week 8:** Enable Policy 2 (labeled-content grounding restriction).
8. **Ongoing:** Review audit logs weekly for the first quarter. Adjust policies as usage patterns emerge.

---

## Verification Tests

After deployment, verify each policy works. Run these tests with a test account, never with production data:

- [ ] Paste a fake credit card number (e.g., 4111-1111-1111-1111) into Copilot Chat → expected: blocked with Policy 1 notice
- [ ] Upload a document labeled "Highly Confidential — No AI" and ask Copilot to summarize it → expected: Copilot refuses or gives no grounded content
- [ ] Attempt to access Copilot from an unmanaged device → expected: blocked by Policy 4
- [ ] Ask Copilot about a document in an excluded SharePoint site → expected: Copilot cannot find it
- [ ] Verify the audit log shows all the above test events within 24 hours

Document the verification run. Retain evidence for your compliance auditor.

---

## References

- Microsoft Purview documentation: https://learn.microsoft.com/purview/
- Microsoft 365 Copilot security baseline: https://learn.microsoft.com/copilot/microsoft-365/microsoft-365-copilot-privacy
- Restricted SharePoint Search: https://learn.microsoft.com/sharepoint/restricted-sharepoint-search

**Microsoft changes Copilot admin controls monthly. Review this policy template quarterly.**
