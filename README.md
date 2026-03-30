# AI Governance Framework

**Version:** 1.0
**License:** MIT

![Version](https://img.shields.io/badge/version-1.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Practical AI governance — focused on execution.

Defines how AI is actually used, not just policy, risk, or compliance.

## Why This Exists

AI-assisted work today can often be unstructured, unverified, and inconsistent. Common issues include untested AI-generated code, sensitive data shared in prompts, and production changes made without proper confirmation.

There is no widely adopted standard for how AI tools should be used consistently in professional environments.

AI output can be incorrect, incomplete, or misleading — verification is required for reliable results. This framework provides a structured approach to consistent behavior, verification, safe data handling, and controlled AI-assisted workflows — across any AI tool, any project, any team.

**This framework applies to anyone using AI tools — not just developers.** Analysts, managers, HR, finance, marketing — anyone who types into an AI chat box.

## Quick Start

**New user?** Start with `USER_SETUP.md` — a 5-minute onboarding guide that covers everything you need, regardless of your role.

**Setting up a project?** Copy the `templates/` folder into your project, configure `.ai-gov.json`, and start your AI tool. Full instructions and tiered adoption guide below.

## About

This framework is published as an independent open-source project. It may be adopted or adapted by organizations under the provided license.

## Author

Created by Jamieson McNeil
Maintained by Jamieson McNeil · by Suitethink

---

## Start Here

**If you are a new user** — read `USER_SETUP.md`. It takes 5 minutes, covers all roles (developers, analysts, general users, managers), and tells you exactly what to do. Everything else is optional unless your role or team requires it.

**If you are setting up a project or team** — continue reading below for the tiered adoption guide.

You do not need to adopt the entire framework at once.

Choose the path that matches your project's needs:

### 1. Individual use
Start with:
- `USER_SETUP.md` (5-minute onboarding for any role)
- `SELF_GOVERNANCE.md` (complete safety guide)
- Training opt-out on your AI tools
- Placeholder data instead of real sensitive data

### 2. Project use
Add:
- `RULES.md`
- `INTERACTION_PROTOCOL.md`
- `TRACKING.md`
- `.ai-gov.json` (project config)
- `.ai-gov.user.json` (per-user config — gitignored, optional for non-developers)

### 3. Production or business use
Add:
- `PRODUCTION_SAFETY.md`
- `CREDENTIAL_SECURITY.md`
- `ENCRYPTION.md`
- `QA_STANDARDS.md`
- `AI_ENVIRONMENTS.md`
- `COMPLIANCE.md` (if needed)

Start with the smallest useful path and expand as your use of AI grows.

You can begin with just `USER_SETUP.md` and a minimal setup, then adopt additional controls over time.

---

## What This Is

This is a practical AI governance framework designed for day-to-day use.

It is:
- A behavioral system for using AI safely
- A workflow system for AI-assisted development
- Tool-agnostic (Claude, ChatGPT, Copilot, Cursor, Gemini, etc.)
- Extendable per project or organization

**This framework focuses on HOW AI is used, not WHAT is being built.**

It is NOT:
- A compliance certification (though it aligns with NIST, ISO, OWASP, and others)
- Theoretical guidance — every rule is based on a real incident
- Tied to a specific AI vendor or platform

This document is the framework entry point and architecture guide. **For the full safety boundary on what must NEVER be shared with AI tools, see SELF_GOVERNANCE.md — if you read only one file, read that one.**

---

## How to Use This Framework

You do NOT need to implement everything at once.

### Tier 1 — Personal Use (Minimum)

Use this if you are asking questions, writing content, or doing light development.

**Do this:**
- Read SELF_GOVERNANCE.md
- Disable training in your AI tools (every tool, every account)
- Never paste credentials or sensitive data
- Use placeholders instead of real data

### Tier 2 — Project Use (Standard)

Use this for active development projects or multi-session work with AI.

**Add:**
- RULES.md (mandatory behavioral rules)
- INTERACTION_PROTOCOL.md (how to parse and respond to user messages)
- TRACKING.md (session continuity via PROGRESS.md + TASKS.md)
- `.ai-gov.json` (project configuration)
- Project-specific governance files (if needed)

### Tier 3 — Production / Business Use (Full Governance)

Use this when working with real users, real data, or production systems.

**Add:**
- PRODUCTION_SAFETY.md (CONFIRM PRODUCTION protocol)
- CREDENTIAL_SECURITY.md (encrypted credential storage)
- ENCRYPTION.md (at-rest and in-transit encryption standards)
- QA_STANDARDS.md (verification hierarchy)
- AI_ENVIRONMENTS.md (execution environment classification and layered processing)
- COMPLIANCE.md (if regulatory requirements apply)

Sensitive data may be used with AI only in approved enterprise or self-hosted environments — never in public AI tools.

**The tier determines your entry point, not the strictness of the rules. Every rule that applies at your tier is mandatory.**

---

## How It Works

This framework has **one core** and **many extensions**. The core lives here and is **never modified** — projects only extend it.

```
THIS DIRECTORY (read-only, shared by all projects)
/path/to/ai-governance-framework/
  USER_SETUP.md           Start here — 5-minute onboarding for any role
  RULES.md                14 mandatory behavioral rules
  INTERACTION_PROTOCOL.md How to parse and respond to user messages
  FORBIDDEN.md            Universal prohibitions
  PATTERNS.md             Universal code patterns
  CREDENTIAL_SECURITY.md  Context-aware credential handling + DDL
  PRODUCTION_SAFETY.md    CONFIRM PRODUCTION protocol
  QA_STANDARDS.md         Verification hierarchy
  TRACKING.md             PROGRESS/TASKS/HISTORY standards
  SELF_GOVERNANCE.md      What NOT to put into AI tools
  AI_ENVIRONMENTS.md      Execution environments and layered AI processing
  COMPLIANCE.md           Regulatory alignment (NIST, ISO, OWASP, PIPEDA)
  ENCRYPTION.md           Encryption standards (at-rest, in-transit, key management)
  templates/              Starter files for new projects
  examples/               Real-world setup and usage examples

YOUR PROJECT (extends core — this is what you modify)
/path/to/your-project/
  .ai-gov.json                    Project config (credential storage, governance paths)
  .ai-gov.user.json               User config (role, tools — gitignored, per-user)
  CLAUDE.md                       AI tool entry point (references core + project governance)
  docs/PROGRESS.md                Active progress log
  docs/TASKS.md                   Outstanding work items
  project-governance/             Project-specific extensions (optional)
    PROJECT_RULES.md              Rules that ADD to core (never override)
    FORBIDDEN.md                  Project-specific prohibitions
    CONVENTIONS.md                Naming, styling, file structure OVERRIDES
    PATTERNS.md                   Project-specific code patterns
    TECH_STACK.md                 Approved technologies
    DEFINITION_OF_DONE.md         Project-specific DoD checklist
```

## Session Start Protocol

Every new AI session (Claude Code, Copilot chat, Cursor, etc.) must:

1. **Read `.ai-gov.json`** in the working directory
2. **If it doesn't exist:** Ask the user to answer the configuration questions (see below), create the file
3. **If it exists:** Present the config summary and ask the user to confirm before proceeding
4. **Read `.ai-gov.user.json`** (if it exists) — use the user's role to adjust guidance emphasis and verbosity. Role does not restrict which rules apply — all rules remain universal
5. **Read core governance** (RULES.md at minimum)
6. **Read project governance** (if paths are configured in `.ai-gov.json`)
7. **Read PROGRESS.md and TASKS.md** (if they exist)

### .ai-gov.json Configuration Questions

When starting a new project, the AI asks:

| Question | Key | Example Values |
|----------|-----|---------------|
| How should credentials be stored? | `credential_storage` | `"postgres"`, `"file"`, `"secrets_manager"` |
| Path to core governance? | `core_governance_path` | `"/path/to/ai-governance-framework"` |
| Path to org governance? (if any) | `org_governance_path` | `null` or path |
| Path to project governance? | `project_governance_path` | `"./project-governance"` or `null` |
| Which compliance frameworks apply? | `compliance_frameworks` | `["hipaa", "soc2"]` or `[]` |
| Is there a production environment? | `production_environment` | `{ "type": "aws_ec2", "host": "..." }` or `null` |
| What AI execution environment is in use? | `ai_execution_environment` | `{ "type": "public" }`, `"self_hosted"`, `"layered"` |
| Which AI tools does the team use? | `ai_tools` | `["claude-code", "copilot"]` |

### Example .ai-gov.json

```json
{
  "schema_version": "1.0",
  "credential_storage": "postgres",
  "core_governance_path": "/path/to/ai-governance-framework",
  "org_governance_path": null,
  "project_governance_path": "./project-governance",
  "compliance_frameworks": ["hipaa", "ai-governance", "multi-tenant"],
  "production_environment": {
    "type": "aws_ec2",
    "host": "your-server.example.com",
    "requires_confirm_production": true
  },
  "ai_execution_environment": {
    "type": "layered",
    "notes": "PII scrubbing via local cascade, external AI for reasoning"
  },
  "ai_tools": ["claude-code"],
  "confirmed_date": "2026-03-24"
}
```

## Override / Extension Model

Project-level governance can modify some parts of the framework — but not all. The system is divided into four categories:

### 1. IMMUTABLE (cannot be overridden)

These are non-negotiable framework guarantees:

- Core behavioral rules (RULES.md)
- Core prohibitions (FORBIDDEN.md)
- Production confirmation protocol (PRODUCTION_SAFETY.md)
- AI safety boundary (SELF_GOVERNANCE.md)
- Minimum verification requirements (QA_STANDARDS.md)

Project-level governance may NOT weaken, redefine, or create exceptions to these.

### 2. ADDITIVE (can be enhanced, not weakened)

Project-level governance may add stricter controls:

- `project-governance/PROJECT_RULES.md` — add project-specific rules
- `project-governance/FORBIDDEN.md` — add project-specific prohibitions
- Additional validation, approval, or compliance requirements

Project-level governance may NOT remove or weaken core requirements.

### 3. CONFIGURABLE (project chooses implementation)

Projects select how rules are implemented — the rule stays the same, the implementation varies:

- Credential storage method — postgres, file, or secrets manager (`.ai-gov.json`)
- Compliance frameworks — which apply to this project (`.ai-gov.json`)
- AI tools in use (`.ai-gov.json`)
- Tracking mode — lightweight or full (TRACKING.md)

### 4. OVERRIDABLE (local conventions only)

Projects may override local conventions via `project-governance/CONVENTIONS.md`:

- Naming conventions, file structure, styling approach
- Branch naming, commit format
- Import ordering, comment style

These must NOT conflict with security requirements, verification standards, or core rules.

### Precedence Rules

1. Core immutable rules always win
2. Additive project governance may strengthen but never weaken core
3. Configuration selects implementation, not behavior
4. Conventions may override defaults only where explicitly allowed
5. **If there is any conflict, follow the stricter rule**

| Capability | Allowed? |
|---|---|
| Override security rules | No |
| Override production safety | No |
| Override verification standards | No |
| Add stricter rules | Yes |
| Add stricter prohibitions | Yes |
| Choose implementation details | Yes |
| Override naming / structure | Yes |

## Quick Start for a New Project

```bash
# 1. Copy templates to your project
cp /path/to/ai-governance-framework/templates/CLAUDE.md ./CLAUDE.md
cp /path/to/ai-governance-framework/templates/.ai-gov.json ./.ai-gov.json
mkdir -p docs project-governance
cp /path/to/ai-governance-framework/templates/PROGRESS.md ./docs/PROGRESS.md
cp /path/to/ai-governance-framework/templates/TASKS.md ./docs/TASKS.md

# 2. Edit .ai-gov.json with your project's answers
# 3. Edit CLAUDE.md with your project context
# 4. Optionally create project-governance/ files for project-specific rules
# 5. Start your AI tool — it reads .ai-gov.json and confirms config with you
```

## Standards Alignment & References

This framework was built on established international standards for information security, AI governance, and privacy. Each core document maps to specific controls from these frameworks. See COMPLIANCE.md for the detailed control-by-control mapping.

### Standards Incorporated

| Standard | Issuing Body | What It Governs | How We Use It |
|----------|-------------|-----------------|---------------|
| **NIST AI RMF 1.0** | U.S. National Institute of Standards and Technology | AI risk management lifecycle | GOVERN, MAP, MEASURE, MANAGE functions inform our session protocol, QA standards, and production safety |
| **NIST AI 600-1** | NIST | Generative AI risks (confabulation, integrity, IP) | AI-generated code review checklist, verification hierarchy |
| **ISO/IEC 42001:2023** | International Organization for Standardization | AI management systems | Controls A.2–A.9 mapped to rules, tracking, QA, and credential management |
| **ISO/IEC 27001:2022** | ISO | Information security management | A.5 (policies), A.6 (people), A.8 (technology) inform credential security, encryption, access control |
| **OWASP Top 10 for LLMs (2025)** | Open Worldwide Application Security Project | LLM-specific vulnerabilities | LLM01 (prompt injection), LLM02 (sensitive data), LLM05 (output handling), LLM06 (excessive agency), LLM09 (misinformation) |
| **PIPEDA** | Office of the Privacy Commissioner of Canada | Canadian personal information protection | 10 fair information principles inform credential handling, PII scrubbing, data minimization |
| **GDPR** | European Union | EU data protection and privacy | Right to erasure, data portability, consent management, breach notification |
| **SOC 2 Type II** | AICPA | Service organization trust criteria | Security, Availability, Processing Integrity, Confidentiality, Privacy trust criteria |
| **HIPAA** | U.S. Department of Health and Human Services | Protected health information | Encryption at rest/transit, audit trails, minimum necessary access |
| **PCI-DSS** | Payment Card Industry Security Standards Council | Cardholder data protection | 12 requirements for handling payment data |
| **FedRAMP** | U.S. General Services Administration | Federal cloud security | NIST 800-53 controls, FIPS-validated cryptography |
| **EU AI Act (Article 4)** | European Union | AI literacy and transparency | Staff training requirements, AI tool awareness |
| **Canadian Directive on Automated Decision-Making** | Treasury Board of Canada | Government AI accountability | Impact assessment, human-in-the-loop, transparency, audit trail |

### Additional References

- **CIS Controls v8** (Center for Internet Security) — Informed our credential rotation schedules and access control patterns
- **NIST SP 800-63B** (Digital Identity Guidelines) — Password hashing requirements (bcrypt, cost factor 12+)
- **NIST SP 800-132** (Recommendation for Password-Based Key Derivation) — Key derivation and encryption key management
- **RFC 6749 / RFC 7519** (OAuth 2.0 / JWT) — Token handling, rotation, and session management patterns

### Why This Matters

Anyone reviewing this framework can verify that:
1. **Every rule traces to an established standard** — not arbitrary preferences
2. **Credential handling follows ISO 27001 + NIST** — industry-standard key separation, rotation, and encryption
3. **AI-specific risks are addressed via OWASP LLM Top 10** — not an afterthought
4. **Privacy requirements meet PIPEDA + GDPR** — applicable to Canadian and international operations
5. **The layered governance model follows ISO 42001** — central policy with project-level extensions

See COMPLIANCE.md for the full control-by-control mapping.

## What Makes This Framework Different

This framework is not limited to compliance requirements. It was built by practitioners who shipped AI-assisted code to production and informed by observed failure modes. The standards above provide the foundation, but the following patterns reflect lessons derived from real-world implementation and operational issues:

### Original Contributions

**1. PII Scrubbing + Tool-Calling AI (RULES.md Rule 8, FORBIDDEN.md)**
No standard addresses what happens when you scrub personally identifiable information *before* sending a message to an AI that calls tools. We discovered that PII tokens like `[[PER_A]]` get stored as actual data values by the tool-calling AI, permanently corrupting the database. The correct flow: send the current message unscrubbed to the trusted AI, let it call tools with real values, then scrub the conversation history and logs after processing. This single insight prevented ongoing data corruption in production.

**2. CONFIRM PRODUCTION Protocol (PRODUCTION_SAFETY.md)**
Standard change management says "get approval." In practice, AI tool users develop muscle memory and approve destructive operations reflexively. Our protocol requires typing the exact phrase "CONFIRM PRODUCTION" — not "yes", "ok", or Enter. This deliberate friction has prevented accidental production modifications.

**3. Context-Aware Credential Storage (CREDENTIAL_SECURITY.md)**
Most frameworks assume one credential storage method. We support three (database, secrets manager, file) with a decision tree, because the same developer may work on a production system with PostgreSQL and a side project with only `.env` files. The `.ai-gov.json` config file records which method is in use so the AI assistant knows how to handle credentials in each context.

**4. Session-Start Configuration Confirmation (.ai-gov.json)**
AI assistants lose context between sessions. Instead of hoping the AI "remembers" project settings, we persist them in a JSON file that the AI reads and confirms with the user at the start of every session. This eliminates the class of errors where the AI assumes the wrong environment, credential store, or compliance requirements.

**5. Verification Hierarchy (QA_STANDARDS.md)**
"It compiles" is not verification. We define six explicit levels and mark which are sufficient (end-to-end workflow = yes, "code compiles" = no). This directly addresses the failure mode where AI assistants claim completion after writing code that compiles but doesn't actually work.

**6. Real-World Gotchas (CREDENTIAL_SECURITY.md, FORBIDDEN.md)**
We document specific production failures that no standard covers: DATABASE_URL passwords with special characters silently failing, localhost URLs baking into production JS bundles, GraphQL introspection exposing entire API schemas, and frontend env vars requiring literal references for build-time inlining. These are the kinds of issues that cost hours to debug and seconds to prevent.

## Future Work

This framework may be extended with tooling that enforces governance automatically across environments. The rules and structure defined here are designed to be machine-readable and enforceable by automated systems.
