# Microsoft Copilot — Audit Queries (KQL)

**Purpose:** Rule 1 (Never claim completion without verification) applies to DLP and Copilot governance configurations the same way it applies to code. A DLP policy that doesn't actually block anything is worse than no policy — it creates false confidence. These KQL queries run against Microsoft Purview Audit / Microsoft Sentinel to **verify that each control in `enforcement-mapping.md` is actually working**.

Every query below maps to a row in `enforcement-mapping.md`. Run them regularly (weekly at minimum; daily or real-time for Q1 and Q10).

**Where to run these:**
- **Primary:** Microsoft Sentinel (`portal.azure.com` → Microsoft Sentinel → Logs) — best for long-term retention, alerting, and scheduling
- **Also valid:** Microsoft Purview Audit (`compliance.microsoft.com` → Audit → Search) — for ad-hoc investigation (30-day retention)
- **Advanced Hunting in Defender XDR** — if licensed

**Required data connectors** (Sentinel):
- Office 365 (captures `CopilotInteraction`, `SearchQueryInitiatedCopilot`, `FileAccessed` with `AppId=Copilot`)
- Microsoft Purview Information Protection (captures label and DLP policy match events)
- Microsoft Entra ID (captures Conditional Access and sign-in events)
- Microsoft Defender for Endpoint (captures device compliance, AppLocker block events — needed for Q8)

Queries use standard KQL. Timestamps are UTC. Where `<ago_window>` appears, substitute your cadence (e.g., `7d`, `1d`, `1h`).

Last Reviewed: 2026-04-13 | Next Review Due: 2026-07-13 (KQL is stable but audit table schemas occasionally change)

---

## Q1 — Credential-shape content accepted by Copilot

**Maps to:** `enforcement-mapping.md` §1 (Credentials and Secrets)
**What it detects:** Content that looks like a credential reached Copilot without being blocked by DLP — either DLP didn't match, or the SIT list is incomplete.

```kql
// Credential-shape content that Copilot processed without a DLP block
let window = 7d;
CopilotInteraction
| where TimeGenerated > ago(window)
| where Prompt matches regex @"(?i)(api[_-]?key|secret|token|bearer|password)[\s:=]+['""]?[a-z0-9_\-\.]{16,}"
    or Prompt matches regex @"(?i)postgres(ql)?:\/\/[^\s]+"
    or Prompt matches regex @"(?i)(mongodb|mysql|redis):\/\/[^\s]+"
| join kind=leftanti (
    DlpPolicyMatch
    | where TimeGenerated > ago(window)
    | where Workload == "Copilot"
) on UserPrincipalName, $left.TimeGenerated == $right.TimeGenerated
| project TimeGenerated, UserPrincipalName, PromptSnippet = substring(Prompt, 0, 120), ConversationId
| order by TimeGenerated desc
```

**Expected result:** Empty. Any row = DLP gap. Triage: update the SIT list in the DLP policy, re-run after 24 hours.

---

## Q2 — Copilot conversations older than retention limit

**Maps to:** `enforcement-mapping.md` §1 (credentials never retained past 30 days)
**What it detects:** Conversations lingering past the configured retention window — indicates retention policy not applying or was changed.

```kql
let retention = 30d;
CopilotInteraction
| where TimeGenerated < ago(retention)
| summarize OldConversations = dcount(ConversationId), OldestRecord = min(TimeGenerated) by UserPrincipalName
| where OldConversations > 0
| order by OldestRecord asc
```

**Expected result:** Empty. Any row = retention not enforced. Check `admin.microsoft.com` → Settings → Org settings → Microsoft 365 Copilot → Enhanced data handling.

---

## Q3 — Copilot access from non-compliant device

**Maps to:** `enforcement-mapping.md` §3 (Conditional Access)
**What it detects:** A Copilot-licensed user reached Copilot from a device that is not marked compliant by Intune — means CA policy is not enforcing, or is scoped too narrowly.

```kql
let window = 1d;
SigninLogs
| where TimeGenerated > ago(window)
| where AppDisplayName in ("Microsoft 365 Copilot", "Copilot", "Office 365 Copilot")
| where DeviceDetail.isCompliant == false or isempty(DeviceDetail.isCompliant)
| where ResultType == 0  // successful sign-in
| project TimeGenerated, UserPrincipalName, DeviceId = DeviceDetail.deviceId, OS = DeviceDetail.operatingSystem, Compliant = DeviceDetail.isCompliant, IPAddress
| order by TimeGenerated desc
```

**Expected result:** Empty. Any row = CA policy should have blocked this but didn't. Review CA assignments (user scope, device filter, session controls).

---

## Q4 — Copilot grounded on excluded SharePoint site

**Maps to:** `enforcement-mapping.md` §3 (Restricted SharePoint Search)
**What it detects:** Copilot retrieved content from a SharePoint site that should be excluded from grounding (e.g., Finance, Legal, HR PII).

```kql
let excluded_sites = dynamic(["finance", "legal", "hr-pii", "executive-comms"]);  // substitute your site names
let window = 7d;
SearchQueryInitiatedCopilot
| where TimeGenerated > ago(window)
| extend GroundingSiteLower = tolower(tostring(SourceUri))
| where excluded_sites has_any split(GroundingSiteLower, "/")
| project TimeGenerated, UserPrincipalName, Query = substring(QueryText, 0, 120), GroundingSite = SourceUri
| order by TimeGenerated desc
```

**Expected result:** Empty. Any row = Restricted SharePoint Search not configured, or allowlist includes a site it shouldn't. Review `admin.microsoft.com` → Copilot → Settings.

---

## Q5 — Copilot attempted to surface encrypted label content

**Maps to:** `enforcement-mapping.md` §4 (MIP sensitivity labels)
**What it detects:** Copilot tried to ground on content carrying a "Highly Confidential — No AI" encrypted label. If the label is configured correctly, Copilot should skip it — but audit confirms the behavior.

```kql
let window = 7d;
InformationProtectionLogs
| where TimeGenerated > ago(window)
| where LabelName contains "Highly Confidential"  // substitute exact label name
| where AccessingApp == "Microsoft 365 Copilot"
| where ActionResult == "Denied" or ActionResult == "Blocked"
| project TimeGenerated, UserPrincipalName, FileName, LabelName, ActionResult
| order by TimeGenerated desc
```

**Expected result:** `ActionResult` always `Denied`/`Blocked`. Any `Allowed` = label encryption not enforcing against Copilot. Check label encryption settings and Copilot's service principal permissions.

---

## Q6 — Copilot retrieval outside approved scope

**Maps to:** `enforcement-mapping.md` §4 (Copilot Control System + CCS)
**What it detects:** Copilot surfaced content from OneDrive, Teams, or SharePoint locations outside the approved grounding scope for the user's role.

```kql
let window = 7d;
let approved_scope = datatable(UserRole:string, AllowedPath:string)
[
    "engineer", "https://contoso.sharepoint.com/sites/engineering",
    "hr", "https://contoso.sharepoint.com/sites/hr-policies",
    "finance", "https://contoso.sharepoint.com/sites/finance-reporting"
];
SearchQueryInitiatedCopilot
| where TimeGenerated > ago(window)
| join kind=inner (IdentityInfo | project AccountUPN, AssignedRoles = tostring(AssignedRoles)) on $left.UserPrincipalName == $right.AccountUPN
| extend ResolvedRole = iff(AssignedRoles contains "engineer", "engineer", iff(AssignedRoles contains "hr", "hr", iff(AssignedRoles contains "finance", "finance", "other")))
| join kind=leftouter approved_scope on $left.ResolvedRole == $right.UserRole
| where not (SourceUri startswith AllowedPath)
| project TimeGenerated, UserPrincipalName, ResolvedRole, GroundingSite = SourceUri
| order by TimeGenerated desc
```

**Expected result:** Empty or rare. Frequent hits = role-based scoping missing; configure Restricted SharePoint Search + MIP scope per role.

---

## Q7 — Copilot responses lacking citations

**Maps to:** `enforcement-mapping.md` §4 (LLM09 Misinformation — verification)
**What it detects:** Copilot responses that were emitted without grounding citations. Low-confidence signal — a response without citations is more likely to hallucinate.

```kql
let window = 7d;
CopilotInteraction
| where TimeGenerated > ago(window)
| where isnotempty(Response)
| extend HasCitation = Response contains "[^" or Response contains "Source:" or CitationCount > 0
| where HasCitation == false
| summarize UngroundedResponses = count(), Users = dcount(UserPrincipalName) by bin(TimeGenerated, 1d)
| order by TimeGenerated desc
```

**Expected result:** Baseline varies. Trend up = users asking more general-knowledge questions (fine) or Copilot losing access to grounding scope (investigate). Not a blocker, but a monitoring signal.

---

## Q8 — Managed device opened Consumer Copilot app

**Maps to:** `enforcement-mapping.md` §4 (Consumer Copilot block at device layer)
**What it detects:** A device enrolled in Intune launched the consumer Microsoft Copilot app — means AppLocker / Edge management policy is not blocking, or the device dropped out of management.

```kql
let window = 1d;
DeviceProcessEvents
| where TimeGenerated > ago(window)
| where ProcessCommandLine contains "Microsoft.Copilot" or ProcessCommandLine contains "copilot.microsoft.com"
| where ProcessCommandLine !contains "entra" and ProcessCommandLine !contains "work"
| join kind=inner (DeviceInfo | where IsManaged == true) on DeviceId
| project TimeGenerated, DeviceName, AccountName, ProcessCommandLine, InitiatingProcessAccountName
| order by TimeGenerated desc
```

**Expected result:** Empty. Any row = block not working. Re-apply Intune configuration profile; check AppLocker event 8003/8004 for bypass attempts.

---

## Q9 — Personal MSA sign-in on managed device for Copilot

**Maps to:** `enforcement-mapping.md` §4 (CA block personal MSA)
**What it detects:** A user on a managed work device signed into Copilot with a personal MSA account (`@gmail.com`, `@outlook.com`, `@hotmail.com`, `@live.com`, `@msn.com`).

```kql
let window = 1d;
let personal_domains = dynamic(["gmail.com", "outlook.com", "hotmail.com", "live.com", "msn.com"]);
SigninLogs
| where TimeGenerated > ago(window)
| where AppDisplayName contains "Copilot"
| extend UserDomain = tolower(split(UserPrincipalName, "@")[1])
| where personal_domains has_any tostring(UserDomain)
| join kind=inner (DeviceInfo | where IsManaged == true) on $left.DeviceDetail.deviceId == $right.DeviceId
| project TimeGenerated, UserPrincipalName, DeviceName, IPAddress
| order by TimeGenerated desc
```

**Expected result:** Empty. Any row = personal MSA reached Copilot from managed device, which is the **Prohibited** scenario. Remediate Edge policy `AccessibleAccountTypes=WorkOrSchoolAccountsOnly`, review Intune device posture.

---

## Q10 — Power Platform Copilot opt-in toggled

**Maps to:** `enforcement-mapping.md` §5 (Power Platform opt-in governance)
**What it detects:** The tenant-level Copilot AI features toggle changed state — this is a privileged governance event that must generate a change ticket.

```kql
let window = 30d;
AuditLogs
| where TimeGenerated > ago(window)
| where OperationName contains "Update tenant setting" or OperationName contains "Set-TenantSettings"
| where TargetResources has "Copilot" or TargetResources has "AIFeatures" or TargetResources has "PowerPlatform.Governance"
| project TimeGenerated, InitiatedBy = tostring(InitiatedBy.user.userPrincipalName), Operation = OperationName, OldValue = tostring(TargetResources[0].modifiedProperties[0].oldValue), NewValue = tostring(TargetResources[0].modifiedProperties[0].newValue)
| order by TimeGenerated desc
```

**Expected result:** Every row should correspond to an approved change ticket. Rows without a ticket = unauthorized change — immediate incident. Opt-in flipped ON without governance review = all subsequent Power Platform Copilot interactions reclassify to Restricted.

**Also consider** scheduling a daily snapshot of the current state (as described in `enforcement-mapping.md` §5 narrow-exception PowerShell) and alerting on delta:

```kql
// Alert on any change in PP Copilot opt-in daily snapshot
let window = 2d;
PowerPlatformSettings_CL
| where TimeGenerated > ago(window)
| where SettingName_s == "Copilot.EnabledForMakerExperiences"
| serialize
| extend PrevValue = prev(SettingValue_s, 1)
| where isnotempty(PrevValue) and SettingValue_s != PrevValue
| project TimeGenerated, OldValue = PrevValue, NewValue = SettingValue_s
```

---

## Q11 — Copilot interactions not present in audit log

**Maps to:** `enforcement-mapping.md` §6 (audit retention)
**What it detects:** Copilot usage (detected via license consumption or Graph API) that doesn't have a corresponding `CopilotInteraction` record in Purview Audit. Means audit is not flowing — Rule 1 verification cannot be satisfied.

```kql
let window = 1d;
let copilot_users = OfficeActivity
    | where TimeGenerated > ago(window)
    | where Operation has "Copilot"
    | distinct UserId;
let audited_users = CopilotInteraction
    | where TimeGenerated > ago(window)
    | distinct UserPrincipalName;
copilot_users
| where UserId !in (audited_users)
| project MissingAuditUser = UserId
```

**Expected result:** Empty. Any row = `CopilotInteraction` audit records are not being generated for that user — check Purview Audit retention policy, Sentinel connector status.

---

## Query Scheduling Recommendations

| Query | Cadence | Severity of hit | Alert destination |
|-------|---------|-----------------|-------------------|
| Q1 (credentials) | Every 15 minutes (real-time) | Critical | Security team pager |
| Q2 (retention) | Weekly | Medium | Compliance team email |
| Q3 (non-compliant device) | Daily | High | Identity team |
| Q4 (excluded SharePoint) | Daily | High | Copilot admin |
| Q5 (encrypted label breach) | Real-time | Critical | Security + DPO |
| Q6 (scope violation) | Daily | Medium | Copilot admin |
| Q7 (ungrounded responses) | Weekly | Low (trend) | Monitoring dashboard only |
| Q8 (consumer Copilot on managed device) | Real-time | High | Endpoint team |
| Q9 (personal MSA) | Real-time | High | Identity team |
| Q10 (PP opt-in change) | Real-time | Critical | Governance board + Power Platform admin |
| Q11 (audit gap) | Daily | High | Compliance + Sentinel team |

---

## Maintenance Notes

- Microsoft changes audit table names occasionally. The most stable names are `CopilotInteraction`, `SigninLogs`, `AuditLogs`, `DeviceProcessEvents`, `InformationProtectionLogs`. Queries using custom log tables (e.g., `PowerPlatformSettings_CL` in Q10) assume you are ingesting via Log Analytics — adapt to your data path.
- Substitute your tenant's actual site names, label names, and role definitions where placeholders appear (e.g., `"finance"`, `"hr-pii"`, `"Highly Confidential"`).
- Add queries for custom DLP policies specific to your org — the ones above cover the framework's baseline controls.
- Every quarter, re-run each query against its expected result to confirm the control is still enforcing. A query that starts returning rows where it used to be empty = drift.

---

**Document Version:** 1.0
**Last Updated:** 2026-04-13
