# AI Execution Environments

**Where AI runs determines what data it can safely process. Governance must account for the execution environment, not just the usage pattern.**

---

## Environment Types

### 1. Public Hosted AI

Examples: ChatGPT (consumer), Claude (consumer), Gemini, Perplexity

- Data is transmitted to and processed on third-party infrastructure
- May be retained, logged, or used for training (depending on plan and settings)
- Lowest trust level for sensitive data

**Suitable for:**
- General coding assistance
- Documentation and writing
- Non-sensitive research and analysis
- Learning and exploration

**NOT suitable for:**
- Customer data, PII, health records, financial data
- Credentials, API keys, internal system details
- Regulated or legally privileged information

### 2. Enterprise Hosted AI

Examples: Azure OpenAI, AWS Bedrock, Google Vertex AI, enterprise Claude/GPT agreements

- Governed by enterprise service agreements with data handling guarantees
- Data is processed within the provider's enterprise-controlled environment under contractual and policy guarantees
- Compliance certifications typically available (SOC 2, HIPAA BAA, etc.)

**Suitable for:**
- Internal business workflows
- Internal or Confidential data (per classification model and policy)
- Production AI features (with appropriate controls)

**Requires:**
- Verified enterprise agreement covering data handling
- Confirmed compliance certifications for your use case
- Organization-level access controls

**Important:** Enterprise AI tools (e.g., Microsoft Copilot, Azure OpenAI, Claude API, AWS Bedrock) commonly process internal data — analyzing documents in SharePoint, summarizing emails, generating code from internal repositories. Using these tools on data already stored within the same enterprise environment is generally acceptable when data access permissions are correctly configured, the service operates under approved agreements, and data retention meets organizational requirements.

Enterprise AI reduces certain risks but does not eliminate them:
- Data is still processed externally (for API-based systems)
- AI may aggregate, infer, or expose data in unintended ways
- Outputs may be incorrect or misleading
- Users may over-trust results

Enterprise AI changes the **data boundary**, not the **accountability model**. All governance rules still apply.

### 2b. External Enterprise AI APIs

Examples: Claude API, OpenAI API (not consumer ChatGPT), Azure OpenAI, AWS Bedrock

- Operate under enterprise agreements with defined data handling guarantees
- Do not train on customer data (per provider policies for enterprise tiers)
- Provide contractual data retention and deletion commitments

However:
- Data is still transmitted to external infrastructure
- Processing occurs outside direct organizational control
- Temporary retention or logging may occur on the provider's side
- Jurisdiction and compliance requirements still apply

**Acceptable use (conditional):** Sensitive data MAY be processed using these APIs when the service is approved by the organization, data handling meets policy and compliance requirements, the data classification allows external processing, and the use case is authorized.

**"No training" does NOT mean no risk.** These systems reduce training risk but do NOT eliminate exposure risk, compliance obligations, or responsibility for outputs.

### 3. Self-Hosted / Internal AI

Examples: locally hosted models, on-premise inference servers, containerized AI services

- Runs on infrastructure you control
- Data never leaves your network
- Required for highest-sensitivity processing

**Suitable for:**
- Customer data and PII processing
- Financial data analysis
- Regulated information (HIPAA, PIPEDA, GDPR)
- Pre-processing sensitive data before external AI (see Layered Processing below)

**Important:** Self-hosted environments reduce exposure risk but still require full governance and verification. The AI can still produce incorrect outputs, the data still needs access controls, and governance rules still apply in full.

### 4. Air-Gapped / Offline AI

- No external network access whatsoever
- Used for the highest-sensitivity environments (defense, classified data)
- Same governance rules apply

---

### Approval Requirement

"Approved" means:
- Authorized by the organization (security, legal, or designated authority)
- Covered by documented policy or agreement
- Aligned with applicable compliance requirements

Individual users or developers may NOT self-approve environments for sensitive data processing.

---

## Key Principle

**The execution environment must match the sensitivity of the data and the risk of the task.** When in doubt, use the more restrictive environment.

### Data Sensitivity (Minimal Classification Model)

| Classification | Description | Minimum AI Environment |
|---|---|---|
| **Public** | Publicly available information | Any (including public AI) |
| **Internal** | Business data, non-sensitive | Enterprise or self-hosted |
| **Confidential** | Customer data, financial data, internal IP | Approved enterprise API or self-hosted |
| **Restricted** | Regulated, legally privileged, or highly sensitive | Self-hosted or air-gapped only |

The required AI execution environment must match or exceed the data classification level.

When classification is unclear, treat data as Confidential by default.

---

## AI vs Traditional SaaS Data Risk

Organizations already use SaaS platforms (CRM, document management, accounting, HR systems) to store and process sensitive data externally. AI does not introduce external data risk for the first time — but it introduces different risks.

**Traditional SaaS:** Structured data, predefined workflows, controlled access patterns. The system does what it was designed to do.

**AI systems:** Unstructured inputs (prompts), dynamic reasoning, cross-context aggregation, probabilistic outputs. The system may synthesize, infer, or surface data in ways that were not explicitly requested.

**AI-specific risks that SaaS does not have:**
- **Data synthesis** — combining information from multiple sources in unexpected ways
- **Over-broad exposure** — surfacing more context than the user intended to share
- **Unintended inference** — deriving sensitive conclusions from non-sensitive inputs
- **Output trust** — users treating AI-generated analysis as verified fact

**Governance implication:** AI must follow the same data governance standards as any SaaS system, but requires additional controls for synthesis, inference, and verification. AI does not lower your security posture, but it can expose weaknesses in existing controls.

If an organization accepts a SaaS platform to store and process data, it may accept an AI system in the same environment to process that data — but the additional AI-specific risks above must be governed.

---

## Layered AI Processing

Real-world AI workflows often combine multiple environments. Sensitive data is processed locally first, then sanitized output is sent to more capable external models.

### The Pattern

```
Raw sensitive data
    → Self-hosted AI (local processing, PII detection, sanitization)
    → Sanitized/reduced output
    → External AI (higher-capability reasoning, generation, analysis)
    → Result returned to application
    → Logs scrubbed after processing
```

### Why This Matters

- More capable models (GPT-4, Claude, Grok) are often external/hosted services
- Sensitive data (customer PII, financial records, health data) must not reach external services in raw form
- Local/self-hosted models handle the sensitive processing (PII detection, data reduction, anonymization)
- External models receive only sanitized data and provide higher-level capabilities

### Governance Rules for Layered Processing

1. **Sensitive data must be reduced, anonymized, or transformed** before being sent to external AI systems
2. **The current user message may be sent unscrubbed to trusted AI** when the AI needs real values for tool-calling (see RULES.md Rule 8 — scrubbing before tool-calling corrupts data)
3. **Conversation history must always be scrubbed** before sending to external AI — accumulated history contains PII from previous interactions
4. **Logs must be scrubbed after processing** — interaction logs should not retain raw PII
5. **If the local processing layer is down, external AI calls must be blocked** — never bypass the scrubbing layer because it's unavailable

### Example: PII Protection Cascade

A production-tested pattern for handling PII across AI environments:

```
User message → [Current message: unscrubbed, sent to trusted external AI for tool-calling]
                [Conversation history: scrubbed through local cascade before external AI]

Local cascade:
  Tier 1: Cloud PII detection service (enterprise-hosted, high accuracy)
  Tier 2: Self-hosted PII detection (local container, no external calls)
  Tier 3: Regex pattern matching (fully local, last resort)

If all tiers are down → block AI calls entirely (scrub gate)
```

This pattern was developed from a production incident where scrubbing the current message before tool-calling AI caused the AI to store PII tokens (`[[PER_A]]`) as actual data values, permanently corrupting the database. The lesson: scrub history, not the current message.

Layered processing must not be used to bypass governance restrictions. Data sanitization must be effective and verifiable — not assumed.

---

## Environment Selection in .ai-governance/config.json

Projects should declare their AI execution environment in the session configuration:

```json
{
  "schema_version": "1.0",
  "ai_execution_environment": {
    "type": "public",
    "notes": "Using Claude API for development assistance. No customer data."
  }
}
```

Valid types: `public`, `enterprise`, `self_hosted`, `air_gapped`, `layered`

For `layered` environments, add detail:

```json
{
  "ai_execution_environment": {
    "type": "layered",
    "notes": "PII scrubbing via local cascade, external AI for reasoning. Customer data processed locally only."
  }
}
```

The AI assistant reads this at session start and adjusts behavior accordingly — for example, refusing to include customer data in prompts when the environment is `public`.

---

## Operational Controls

### Connector and Plugin Access

AI risk is determined not only by the model, but by the data sources and tools it can access. Connectors (SharePoint, Google Drive, Slack, databases), plugins, and tool-calling permissions must follow least privilege:

- Enable only what is required for the task
- Review what data the AI can read through connected systems
- Review what actions it can take (read-only vs read-write)
- Disable unused integrations
- AI must not be granted broad or unrestricted access to internal systems without explicit approval

An approved AI environment can still become high-risk if it is connected to excessive or sensitive data sources.

### Retention and Logging

Before approving an AI environment for sensitive data, verify:

- Prompt retention period (how long inputs are stored)
- Output retention period (how long responses are stored)
- Who can access logs (provider staff, admins, auditors)
- Whether data can be deleted on request
- Where data is stored (region and jurisdiction)

"No training" does not eliminate retention or logging risk. Data may still be stored, accessible to provider staff, or subject to legal requests.

### Shadow AI

Work data must not be processed through:

- Personal AI accounts (free tiers of ChatGPT, Claude, Gemini, etc.)
- Unapproved browser extensions or AI-powered add-ons
- Private API keys not managed by the organization
- Unreviewed third-party AI tools

Organizational work must use only approved tools and accounts. If approved tooling is insufficient, request access to additional tools — do not work around governance.

### AI Incident Handling

If sensitive data is sent to an unapproved AI tool or environment:

1. Stop further use immediately
2. Document what was shared, which tool, and when
3. Notify the appropriate owner (security, privacy, or legal)
4. Review retention and deletion options with the provider
5. Assess impact and required follow-up actions

Do not ignore or conceal AI-related incidents. Prompt disclosure limits damage.

### Human Decision Authority

AI may assist analysis, drafting, and research, but sensitive business, legal, financial, or people decisions must remain under accountable human review. AI output is input to decisions, not the decision itself.

### AI Tool and Model Approval

Organizations should maintain an approved list of AI tools, model providers, execution environments, and connectors. New tools or models must be reviewed before use with sensitive data.

Approval should consider:
- Data handling and retention policies
- Access scope and permissions
- Compliance requirements
- Risk of unintended data exposure

---

## Standards Alignment

- **ISO 27001 A.8.10:** Storage media (data residency and processing location)
- **NIST AI RMF:** MAP function — understanding where AI processing occurs
- **PIPEDA Principle 7:** Safeguards appropriate to sensitivity
- **GDPR Article 44-49:** International data transfers
- **OWASP LLM02:** Sensitive Information Disclosure — environment determines exposure risk
