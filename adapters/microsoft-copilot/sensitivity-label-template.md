# Sensitivity Label Template — "Highly Confidential — No AI"

**Purpose:** A concrete, copy-able Microsoft Information Protection (MIP) sensitivity label definition that, when applied to a file / email / meeting, prevents Microsoft 365 Copilot from grounding on the content. Referenced throughout `dlp-policy-template.md` and `enforcement-mapping.md`.

**Why this works:** Copilot grounding respects MIP label encryption. If a document is encrypted at rest under a sensitivity label, Copilot's service principal does not have the decryption rights, so the document is invisible to Copilot retrieval — it will not appear in responses, summaries, or search results.

**Applies to scenarios:** M365 Copilot (licensed), Copilot via OWA / browser (work account), Power Platform Copilot (opt-in OFF). Does **not** affect Copilot Chat (free w/ Entra) — that surface has no tenant grounding. Does **not** affect consumer Copilot (no tenant access at all).

Last Reviewed: 2026-04-13 | Next Review Due: 2026-07-13

---

## Label Specification

Deploy this as one label within your existing sensitivity label hierarchy (typically under a parent "Highly Confidential" label).

### Identity

| Field | Value |
|-------|-------|
| **Label name** (internal) | `HighlyConfidential_NoAI` |
| **Display name** (user-facing) | `Highly Confidential — No AI` |
| **Description (for users)** | "Content with this label cannot be processed by AI assistants (Copilot, etc.). Use for trade secrets, attorney-client privileged content, pre-announcement M&A material, and any content where AI grounding would be inappropriate." |
| **Description (for admins)** | "Label that blocks Microsoft 365 Copilot grounding via encryption. Copilot's service principal lacks decryption rights for content carrying this label." |
| **Color** | `#8B0000` (dark red) — visually distinct from other confidential labels |
| **Priority** | Higher than "Confidential" in your label order (so it can be applied to content already at lower classification) |

### Scope

Enable the label for all three scopes:

| Scope | Enabled | Notes |
|-------|---------|-------|
| **Files & emails** | Yes | Primary use case |
| **Groups & sites** | Yes | Lock down entire SharePoint sites or Teams channels from Copilot grounding |
| **Schematized data assets** (Purview) | Optional | If using Purview data catalog for databases / dataverse |
| **Meetings** | Yes | Teams meetings with this label — Copilot cannot summarize |

---

### Encryption (the critical setting)

This is what blocks Copilot. Do not skip any sub-setting.

| Setting | Value |
|---------|-------|
| **Encryption** | **ON** |
| **Configure encryption settings** | "Configure permissions now" |
| **Assign permissions** | Specific users and groups (see table below) |
| **User access expires** | Never (unless business requirement) |
| **Allow offline access** | 7 days (minimum practical) |
| **Double Key Encryption** | OFF (unless DKE already deployed in your tenant) |

**Permissions to assign:**

| Principal | Permission set | Reason |
|-----------|----------------|--------|
| Specific business groups (e.g., `legal-privileged@contoso.com`, `ma-deal-team@contoso.com`) | `Co-Author` (view, edit, copy, print, reply, reply-all) | Legitimate users who need to work on the content |
| Author / owner | `Co-Owner` | Author retains full control including label change |
| **Microsoft 365 Copilot** service principal | **NOT GRANTED** | This is what blocks Copilot — no permission = no decryption = no grounding |
| General employees | **NOT GRANTED** | Defence against over-sharing |

Do **not** use "All Users" or add `Microsoft 365 Copilot` to the permission list. Either of those defeats the point of this label.

---

### Content Marking

Not strictly required for blocking Copilot (encryption does that), but essential for user awareness that this content is AI-restricted.

| Marking | Enabled | Value |
|---------|---------|-------|
| **Watermark** | Yes | Text: `HIGHLY CONFIDENTIAL — NO AI PROCESSING` · Font: 14pt · Color: `#8B0000` · Layout: Diagonal · Position: Center |
| **Header** | Yes | Text: `[HIGHLY CONFIDENTIAL — AI PROCESSING PROHIBITED]` · Font: 10pt · Color: `#8B0000` · Alignment: Left |
| **Footer** | Yes | Text: `Do not paste this content into any AI assistant (Copilot, ChatGPT, Claude, etc.). Violation is a governance incident — report to security@[yourorg].com` · Font: 8pt · Color: black · Alignment: Center |

---

### Auto-Labeling

Optional but recommended. Deploy in **test** mode first (recommends label, doesn't apply); switch to **enforce** after false-positive tuning.

**Auto-label conditions — apply "Highly Confidential — No AI" automatically when content contains:**

| Trigger | Rationale |
|---------|-----------|
| Any of the SITs `Attorney-Client Privileged Communication`, `Attorney Work Product` | Privileged legal content |
| Any of the SITs `Non-Public Financial Information`, `SEC Filing Draft`, `Material Non-Public Information` | Insider-trading risk; M&A pre-announcement |
| Custom SIT: document title matches `(?i)\b(board[\s-]?deck|exec[\s-]?summary|investor[\s-]?letter)\b` | Executive-only content |
| Custom SIT: content contains `(?i)(trade[\s-]?secret|proprietary[\s-]?algorithm|patented[\s-]?process)` followed by 50+ words | Proprietary IP |
| Any document placed in a designated SharePoint site (e.g., `/sites/legal-privileged`, `/sites/ma-deals`) | Location-based auto-apply |

---

### Conditions for Applying the Label

**Who can apply it manually:** All users (required — authors must be able to classify their own work).

**Who can remove it / lower it:** Only the label author (Co-Owner permission) and sensitivity-label administrators. General users cannot declassify content carrying this label.

**Justification required for removal:** Yes — force-type a business reason, logged to Purview Audit.

---

## Deployment

### Admin UI path

`compliance.microsoft.com` → Information protection → Labels → Create a label

Fill in each section per the tables above. Do not skip the encryption setup — a label without encryption does not block Copilot, it only displays a warning.

### PowerShell alternative (narrow-exception)

The UI is the recommended path. If your org bulk-deploys labels via PowerShell (e.g., multi-tenant MSP scenario), use:

```powershell
# Create the label
Connect-IPPSSession
$label = New-Label `
    -Name "HighlyConfidential_NoAI" `
    -DisplayName "Highly Confidential — No AI" `
    -Tooltip "Content with this label cannot be processed by AI assistants (Copilot, etc.)." `
    -Comment "Blocks M365 Copilot grounding via encryption. See adapters/microsoft-copilot/sensitivity-label-template.md" `
    -EncryptionEnabled $true `
    -EncryptionProtectionType Template `
    -EncryptionPromptUser $false `
    -EncryptionAllowOfflineAccess 7 `
    -ContentType "File, Email, Site, UnifiedGroup, SchematizedData"

# Assign rights — substitute your actual group
$rights = New-LabelRights `
    -Identity "legal-privileged@contoso.com" `
    -Rights "VIEW,EDIT,OBJMODEL,PRINT,EXTRACT,REPLY,REPLYALL,FORWARD,DOCEDIT,COPY,COMMENT"

Set-Label -Identity $label.Guid -EncryptionRightsDefinitions $rights

# Publish the label to users
New-LabelPolicy `
    -Name "Highly Confidential No AI — Pilot" `
    -Labels "HighlyConfidential_NoAI" `
    -ExchangeLocation All `
    -SharePointLocation All `
    -OneDriveLocation All `
    -ModernGroupLocation All
```

### Verification after deployment

1. **Apply the label to a test document.** The document icon in SharePoint/OneDrive should show the red marking.
2. **Ask Copilot about the document's content** (e.g., "Summarize the attached Q4 financials draft"). Copilot should respond that it cannot access that content, or produce a response that clearly does not include the labeled content.
3. **Check `audit-queries.md` §Q5** — "Copilot attempted to surface encrypted label content" should return rows with `ActionResult = Denied/Blocked`.
4. **Attempt to strip the label from a non-author account.** Should fail (or require justification, logged to audit).

If any of the above misbehaves, the label encryption is not configured correctly. Most common issue: the `Microsoft 365 Copilot` service principal was accidentally granted decrypt rights via a "Co-Author" wildcard.

---

## Adopting This Template

This is a **template**, not a mandate. Your org should:

1. Review each setting against your data classification policy (many orgs already have a "Top Secret" or "Privileged" label — adapt rather than duplicate)
2. Define the business groups that get Co-Author access (legal, deal team, exec) and the escalation path for access grants
3. Coordinate with MSP / licensing partner if using Purview outside an E5 license
4. Roll out in recommend mode for 2-4 weeks before switching to enforce mode — auto-labeling false positives are common
5. Train users on how to apply and remove the label, including the justification requirement

---

## Related

- `enforcement-mapping.md` §4 — where this label is referenced in the rule-to-control mapping
- `dlp-policy-template.md` Policy 2 — the DLP policy that restricts grounding on labeled content (complementary enforcement)
- `audit-queries.md` §Q5 — verification query that this label is being respected by Copilot
- Microsoft Learn: https://learn.microsoft.com/purview/create-sensitivity-labels (authoritative reference for label features)

---

**Document Version:** 1.0
**Last Updated:** 2026-04-13
