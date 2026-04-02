# AI Governance Framework

**Version:** 2.0.0
**License:** MIT

![Version](https://img.shields.io/badge/version-2.0.0-blue)
![License](https://img.shields.io/badge/license-MIT-green)

Practical AI governance — focused on execution.

Defines how AI is actually used, not just policy, risk, or compliance.

**Quick Navigation**
- New user? → `USER_SETUP.md` (5-minute onboarding for any role)
- Core safety boundary → `SELF_GOVERNANCE.md` (read this first)
- Daily behavioral rules → `RULES.md`
- How to interact with AI → `INTERACTION_PROTOCOL.md`
- Session & project continuity → `TRACKING.md`
- Production safety → `PRODUCTION_SAFETY.md`

## Why This Exists

AI-assisted work today can often be unstructured, unverified, and inconsistent. Common issues include untested AI-generated code, sensitive data shared in prompts, and production changes made without proper confirmation.

There is no widely adopted standard for how AI tools should be used consistently in professional environments.

AI output can be incorrect, incomplete, or misleading — verification is required for reliable results. This framework provides a structured approach to consistent behavior, verification, safe data handling, and controlled AI-assisted workflows — across any AI tool, any project, any team.

**This framework applies to anyone using AI tools — not just developers.** Analysts, managers, HR, finance, marketing — anyone who types into an AI chat box.

## Quick Start

**New user?** Start with `USER_SETUP.md` — a 5-minute onboarding guide that covers everything you need, regardless of your role.

**Setting up a project?** Create `.ai-governance/config.json` in your project root and copy an entry-point template (CLAUDE.md, GROK.md, etc.). Full instructions and tiered adoption guide below.

## About

This framework is published as an independent open-source project. It may be adopted or adapted by organizations under the provided license.

## Author

Created by Jamieson McNeil
Maintained by Jamieson McNeil · by Suitethink

---

## Versioning Policy

We keep public releases stable and infrequent while allowing continuous refinement on the main branch.

- **Commits**: Ongoing iteration — wording, clarity, and small refinements.
- **Milestone tags** (e.g. `v1.0-rollout-ready`, `v1.1-user-layer-complete`): Significant checkpoints or structural improvements.
- **Semantic versions** (`v2.x.y`): Reserved for material changes to core structure, immutable rules, or `.ai-governance/config.json` schema. Breaking changes will always include migration notes.

**Current stable release:** `v2.0.0` — Centralized Layer Architecture (April 2026)

**Key principles**:
- `.ai-governance/config.json` schema remains stable for the entire v2.x series.
- Full commit history is preserved (no more resets).
- A lightweight `CHANGELOG.md` tracks notable changes.

This approach optimizes for traceability, stability, and user confidence.

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
- `.ai-governance/config.json` (project config — single source of truth)
- User layer (personal preferences — gitignored, optional)

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
- `.ai-governance/config.json` (project configuration)
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

## For Teams and Small Organizations

This framework scales naturally from individual use to small teams with almost no added process.

**Recommended team practices:**
- Every new team member completes `USER_SETUP.md` (5-minute onboarding) in their first week.
- All AI-assisted work on shared projects uses at least **Tier 2** (project-level governance with `.ai-governance/config.json` and tracking files).
- Developers follow `RULES.md` and the Session Start Protocol.
- Managers treat AI output as "draft / assisted" unless it has passed the verification hierarchy in `QA_STANDARDS.md`.

**Lightweight tracking:**
- Use the User layer (`.ai-governance/user/`) for role + tool preferences, plus a simple acknowledgment (Slack message, ticket, or shared doc) to confirm onboarding.
- Optional monthly 10-minute review: pick one or two recent AI sessions and check core rule adherence.

If repeated onboarding gaps or ownership questions appear, designate a lightweight "AI Governance Champion" per team. A full `TEAM_ADOPTION.md` will only be added later if real usage demonstrates the need.

The focus remains on **behavior and verification**, not bureaucracy.

---

## How It Works (v2.0)

This framework has **one core** and **many extensions**. The core lives in this repository and is **never modified** — projects only extend it through additional layers.

### Framework Repository (this repo — the Core distribution)

```
/path/to/ai-governance-framework/
  RULES.md                14 mandatory behavioral rules (immutable)
  SELF_GOVERNANCE.md      What NOT to put into AI tools (immutable)
  FORBIDDEN.md            Universal prohibitions (immutable)
  INTERACTION_PROTOCOL.md How to parse and respond to user messages
  PRODUCTION_SAFETY.md    CONFIRM PRODUCTION protocol (immutable)
  QA_STANDARDS.md         Verification hierarchy
  CREDENTIAL_SECURITY.md  Context-aware credential handling + DDL
  TRACKING.md             PROGRESS/TASKS/HISTORY standards
  AI_ENVIRONMENTS.md      Execution environments and layered processing
  ENCRYPTION.md           Encryption standards (at-rest, in-transit, key mgmt)
  COMPLIANCE.md           Regulatory alignment (NIST, ISO, OWASP, PIPEDA)
  USER_SETUP.md           5-minute onboarding for any role
  templates/              Starter files for new projects
  examples/               Real-world setup and usage examples
```

### Your Project (extends core)

```
your-project-root/
├── .ai-governance/                     ← REQUIRED entry point
│   ├── config.json                     ← REQUIRED: single source of truth
│   ├── core/                           ← optional: symlink to central Core
│   ├── org/                            ← optional: symlink to central Org
│   ├── project/                        ← project-specific rules (team layer)
│   │   ├── PROJECT_RULES.md
│   │   ├── FORBIDDEN.md
│   │   ├── CONVENTIONS.md
│   │   ├── PATTERNS.md
│   │   ├── TECH_STACK.md
│   │   └── DEFINITION_OF_DONE.md
│   ├── user/                           ← personal preferences (gitignored)
│   └── docs/                           ← PROGRESS.md, TASKS.md
├── CLAUDE.md (or GROK.md, CURSOR.md)   ← REQUIRED: AI entry point
└── ... (your code)
```

> **Important:** The `core/` and `org/` subfolders inside `.ai-governance/` are **optional**. In most company setups, `config.json` points to external absolute or relative paths for Core and Org (e.g., a shared repo). Use symlinks only if you want local copies: `ln -s /path/to/ai-governance-framework .ai-governance/core`. The `config.json` paths always take precedence.

**Minimum required files per project:**
- `.ai-governance/` folder
- `.ai-governance/config.json`
- One AI entry-point file (CLAUDE.md, GROK.md, CURSOR.md, etc.)

Everything else is created as needed.

### Layer Definitions & Precedence

| Layer | Scope | Immutable | Typical Location | Precedence |
|-------|-------|-----------|------------------|------------|
| **Core** | Universal safety rules | Yes | Central shared repo | Highest |
| **Org** | Company-wide policies | No | Central shared location | 2nd |
| **Project** | Project/team rules | No | `.ai-governance/project/` | 3rd |
| **Custom** | Any extra layers | No | As defined in config | As listed |
| **User** | Personal preferences | No | `~/.ai-governance/user/` (gitignored) | Lowest |

**Core is always highest and cannot be weakened by any other layer.** If any conflict exists between layers, the stricter rule wins.

The **Project layer also serves as the team layer.** This is sufficient for most organizations. If you need more granularity (division, department, legal), add custom layers in `config.json`.

### Custom Layers

Custom layers are fully supported. Add them in `config.json` under `custom_layers`:

```json
{
  "custom_layers": {
    "legal": {
      "path": "/path/to/legal-governance",
      "description": "Legal and compliance team requirements"
    }
  }
}
```

Custom layers load after Core/Org/Project and before User, in the exact order listed.

---

## Session Start Protocol (v2.0)

Every new AI session (Claude Code, Grok, Cursor, Copilot, etc.) must:

1. **Read** `.ai-governance/config.json` in the project root
2. **If it doesn't exist:** Inform the user and offer to create it from the template
3. **Parse** all layers defined in `layers` and `custom_layers`
4. **Read** governance files from each active layer:
   - **Core:** RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md
   - **Org/Project/User:** As defined in config
5. **Read** `.ai-governance/docs/PROGRESS.md` and `.ai-governance/docs/TASKS.md` (if they exist)
6. **Output** a confirmation block listing every active layer + exact path
7. **Ask** the user for explicit **YES** before proceeding with any work

The entry-point file (CLAUDE.md, GROK.md, etc.) contains the full protocol instructions for each AI tool.

### Example config.json

```json
{
  "schema_version": "2.0",
  "project_name": "My Project",
  "layers": {
    "core": {
      "path": "/path/to/ai-governance-framework",
      "immutable": true,
      "description": "Universal safety and behavioral rules"
    },
    "org": {
      "path": "/path/to/org-governance",
      "enabled": true,
      "description": "Organization-wide policies"
    },
    "project": {
      "path": ".ai-governance/project",
      "description": "Project-specific rules (team layer)"
    },
    "user": {
      "path": "~/.ai-governance/user",
      "gitignored": true,
      "description": "Personal preferences (cannot weaken rules)"
    }
  },
  "custom_layers": {},
  "credential_storage": "file",
  "compliance_frameworks": [],
  "production_environment": null,
  "ai_tools": ["claude-code"],
  "confirmed_date": "2026-04-02"
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

- `.ai-governance/project/PROJECT_RULES.md` — add project-specific rules
- `.ai-governance/project/FORBIDDEN.md` — add project-specific prohibitions
- Additional validation, approval, or compliance requirements

Project-level governance may NOT remove or weaken core requirements.

### 3. CONFIGURABLE (project chooses implementation)

Projects select how rules are implemented — the rule stays the same, the implementation varies:

- Credential storage method — postgres, file, or secrets manager (`.ai-governance/config.json`)
- Compliance frameworks — which apply to this project (`.ai-governance/config.json`)
- AI tools in use (`.ai-governance/config.json`)
- Tracking mode — lightweight or full (TRACKING.md)

### 4. OVERRIDABLE (local conventions only)

Projects may override local conventions via `.ai-governance/project/CONVENTIONS.md`:

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
# 1. Create the governance folder
mkdir -p .ai-governance/project .ai-governance/docs

# 2. Copy the config template
cp /path/to/ai-governance-framework/templates/config.json .ai-governance/config.json

# 3. Copy the entry-point template for your AI tool
cp /path/to/ai-governance-framework/templates/CLAUDE.md ./CLAUDE.md
# (or GROK.md, CURSOR.md, ENTRY_POINT_TEMPLATE.md)

# 4. Copy tracking templates
cp /path/to/ai-governance-framework/templates/PROGRESS.md .ai-governance/docs/PROGRESS.md
cp /path/to/ai-governance-framework/templates/TASKS.md .ai-governance/docs/TASKS.md

# 5. Edit config.json — set your Core path, Org path, and project details
# 6. Edit CLAUDE.md — add your project overview and specific rules
# 7. Add .ai-governance/user/ to your .gitignore
# 8. Start your AI tool — it reads config.json and confirms layers with you
```

## Migration from v1.x to v2.0

```bash
# 1. Create the new governance folder structure
mkdir -p .ai-governance/project .ai-governance/docs

# 2. Move project governance files
mv project-governance/* .ai-governance/project/ 2>/dev/null
rmdir project-governance 2>/dev/null

# 3. Move tracking files
mv docs/PROGRESS.md .ai-governance/docs/ 2>/dev/null
mv docs/TASKS.md .ai-governance/docs/ 2>/dev/null
mv docs/HISTORY.md .ai-governance/docs/ 2>/dev/null

# 4. Create the new config from template
cp /path/to/ai-governance-framework/templates/config.json .ai-governance/config.json
# Edit config.json — set your Core path, Org path, etc.

# 5. Replace your entry-point file
cp /path/to/ai-governance-framework/templates/CLAUDE.md ./CLAUDE.md
# (or GROK.md, CURSOR.md — pick your tool)
# Edit to add your project overview and specific rules

# 6. Update .gitignore
echo '.ai-governance/user/' >> .gitignore

# 7. Remove deprecated v1 files
rm -f .ai-gov.json .ai-gov.user.json
```

The framework is backward-compatible during transition — old files will still be found by AI tools until you delete them. These v1 files are ignored by the new protocol once `.ai-governance/config.json` exists. Complete the migration at your own pace.

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
Most frameworks assume one credential storage method. We support three (database, secrets manager, file) with a decision tree, because the same developer may work on a production system with PostgreSQL and a side project with only `.env` files. The `.ai-governance/config.json` config file records which method is in use so the AI assistant knows how to handle credentials in each context.

**4. Session-Start Configuration Confirmation (.ai-governance/config.json)**
AI assistants lose context between sessions. Instead of hoping the AI "remembers" project settings, we persist them in a JSON file that the AI reads and confirms with the user at the start of every session. This eliminates the class of errors where the AI assumes the wrong environment, credential store, or compliance requirements.

**5. Verification Hierarchy (QA_STANDARDS.md)**
"It compiles" is not verification. We define six explicit levels and mark which are sufficient (end-to-end workflow = yes, "code compiles" = no). This directly addresses the failure mode where AI assistants claim completion after writing code that compiles but doesn't actually work.

**6. Real-World Gotchas (CREDENTIAL_SECURITY.md, FORBIDDEN.md)**
We document specific production failures that no standard covers: DATABASE_URL passwords with special characters silently failing, localhost URLs baking into production JS bundles, GraphQL introspection exposing entire API schemas, and frontend env vars requiring literal references for build-time inlining. These are the kinds of issues that cost hours to debug and seconds to prevent.

## Future Work

This framework may be extended with tooling that enforces governance automatically across environments. The rules and structure defined here are designed to be machine-readable and enforceable by automated systems.
