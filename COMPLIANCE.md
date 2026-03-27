# Regulatory Compliance Reference

**How this governance framework aligns with recognized standards.**

This document maps framework controls to regulatory requirements. It is a reference — not a substitute for legal or compliance advice.

---

## Framework-to-Standard Mapping

### NIST AI Risk Management Framework (AI RMF 1.0 + AI 600-1)

| NIST Function | Framework Coverage | Document |
|---------------|-------------------|----------|
| **GOVERN** — Policies, accountability, culture | Rules 1-14 establish mandatory policies; session protocol creates accountability | `RULES.md` |
| **MAP** — Identify AI risks in context | Credential security, production safety, execution environment classification, data sensitivity | `CREDENTIAL_SECURITY.md`, `PRODUCTION_SAFETY.md`, `AI_ENVIRONMENTS.md` |
| **MEASURE** — Assess risks with metrics | QA standards, verification hierarchy, testing checklists | `QA_STANDARDS.md` |
| **MANAGE** — Act on identified risks | Production confirmation protocol, rollback planning, incident procedures | `PRODUCTION_SAFETY.md` |

**GenAI-specific risks addressed (NIST AI 600-1):**
- **Confabulation** → Rule 1 (never claim completion without verification), QA (verify hallucinated APIs)
- **Information security** → Rule 8 (security first), OWASP LLM controls
- **Information integrity** → Rule 4 (ask, never assume), QA (verify AI claims)
- **Intellectual property** → Credential Security (no proprietary code in prompts)

### ISO/IEC 42001:2023 — AI Management System

| ISO 42001 Control | Framework Coverage | Document |
|-------------------|-------------------|----------|
| **A.2 AI Policy** | Complete rule set as organizational AI policy | `RULES.md` |
| **A.3 Internal Organization** | Session protocol, role accountability | `RULES.md` (Rule 14) |
| **A.4 Resources** | Platform setup guides, AI tool inventory | `PLATFORM_SETUP.md` |
| **A.5 AI System Lifecycle** | Pre-coding checklist, QA standards, verification | `QA_STANDARDS.md` |
| **A.6 Data** | Credential security, data classification for AI prompts | `CREDENTIAL_SECURITY.md` |
| **A.7 System Information** | Progress tracking, documentation requirements | `TRACKING.md` |
| **A.8 Use of AI Systems** | All operational rules, production safety | `RULES.md`, `PRODUCTION_SAFETY.md` |
| **A.9 Third-Party Relationships** | Platform setup (vendor-specific configurations) | `PLATFORM_SETUP.md` |

### ISO/IEC 27001:2022 — Information Security

| ISO 27001 Control | Framework Coverage |
|-------------------|-------------------|
| **A.5.1** Policies for information security | `RULES.md` (complete policy set) |
| **A.5.10** Acceptable use of information | Rule 8 (security), `CREDENTIAL_SECURITY.md` (what can/cannot go to AI tools) |
| **A.5.12** Classification of information | `CREDENTIAL_SECURITY.md` (credential types), `AI_ENVIRONMENTS.md` (data sensitivity to environment mapping) |
| **A.5.14** Information transfer | `AI_ENVIRONMENTS.md` (environment-based data transfer rules), `CREDENTIAL_SECURITY.md` (AI tool restrictions) |
| **A.5.32** Intellectual property rights | Rule 8 (no proprietary code in AI prompts) |
| **A.6.3** Security awareness | `PLATFORM_SETUP.md` (training on each tool's risks) |
| **A.8.3** Information access restriction | `PRODUCTION_SAFETY.md` (environment classification, least privilege) |
| **A.8.10** Storage media | `AI_ENVIRONMENTS.md` (data residency and processing location requirements) |
| **A.8.11** Data masking | `AI_ENVIRONMENTS.md` (layered processing, PII scrubbing cascade), `CREDENTIAL_SECURITY.md` |
| **A.8.12** Data leakage prevention | `CREDENTIAL_SECURITY.md` (never send credentials to AI) |
| **A.8.25** Secure development lifecycle | `QA_STANDARDS.md` (verification, review requirements) |
| **A.8.28** Secure coding | Rule 8 (parameterized queries, input sanitization, OWASP) |

### PIPEDA — Canadian Privacy (10 Fair Information Principles)

| PIPEDA Principle | Framework Coverage |
|------------------|-------------------|
| **1. Accountability** | Session protocol assigns accountability; tracking creates audit trail |
| **2. Identifying Purposes** | Documentation requirements (CONTEXT.md, decision logging) |
| **3. Consent** | Not directly applicable (internal tool use), but credential security prevents unauthorized disclosure |
| **4. Limiting Collection** | `CREDENTIAL_SECURITY.md` — data minimization in AI prompts |
| **5. Limiting Use/Disclosure** | Rule 8 — match AI environment to data sensitivity; `AI_ENVIRONMENTS.md` — layered processing |
| **6. Accuracy** | Rule 1 — verify all AI output; QA Standards — AI code review checklist |
| **7. Safeguards** | `CREDENTIAL_SECURITY.md` — encryption, bcrypt, key separation |
| **8. Openness** | Framework is distributable; transparency about AI tool usage |
| **9. Individual Access** | Not directly applicable (internal tool use) |
| **10. Challenging Compliance** | Tracking files provide audit trail for compliance review |

### OWASP Top 10 for LLMs (2025)

| OWASP Risk | Framework Control |
|------------|-------------------|
| **LLM01** Prompt Injection | Rule 4 (verify AI output, don't trust blindly) |
| **LLM02** Sensitive Information Disclosure | `CREDENTIAL_SECURITY.md` (never send secrets to AI tools) |
| **LLM03** Supply Chain | `PLATFORM_SETUP.md` (approved tools, vendor assessment) |
| **LLM05** Improper Output Handling | Rule 1 (verify), `QA_STANDARDS.md` (AI code review checklist) |
| **LLM06** Excessive Agency | `PRODUCTION_SAFETY.md` (least privilege, CONFIRM PRODUCTION) |
| **LLM07** System Prompt Leakage | `CREDENTIAL_SECURITY.md` (no secrets in AI context) |
| **LLM09** Misinformation | Rule 4 (ask, don't assume), QA (verify hallucinated APIs) |
| **LLM10** Unbounded Consumption | Organizational — set usage budgets per tool |

### EU AI Act (Article 4 — AI Literacy)

| Requirement | Framework Coverage |
|-------------|-------------------|
| Staff must have sufficient AI literacy | `PLATFORM_SETUP.md` serves as training material |
| Training must be documented | Session tracking in `PROGRESS.md` / `HISTORY.md` |
| Proportionate to role and context | Rules are role-agnostic; platform setup is tool-specific |

### Canadian Directive on Automated Decision-Making

| Requirement | Framework Coverage |
|-------------|-------------------|
| Impact assessment before AI use | Pre-coding checklist (Rule 14), risk identification |
| Human-in-the-loop | Rule 1 (never claim completion without human verification) |
| Transparency | `TRACKING.md` (all AI work documented and auditable) |
| Audit trail | `PROGRESS.md`, `HISTORY.md`, `TASKS.md` |

### SOC 2 Type II

| Trust Service Criterion | Framework Coverage |
|------------------------|-------------------|
| **Security** | Rule 8, `CREDENTIAL_SECURITY.md`, `PRODUCTION_SAFETY.md` |
| **Availability** | `PLATFORM_SETUP.md` (multi-tool approach avoids single-point dependency) |
| **Processing Integrity** | `QA_STANDARDS.md` (verification hierarchy, AI code review) |
| **Confidentiality** | `CREDENTIAL_SECURITY.md` (data classification, DLP for AI) |
| **Privacy** | PIPEDA alignment above, PII handling rules |

---

## Organizational Responsibilities

To fully comply with these standards, the organization should also:

1. **Maintain an AI Tool Inventory** — list all AI tools in use, who uses them, what data they access
2. **Conduct AI Impact Assessments** — before adopting new AI tools, assess risks per NIST MAP function
3. **Review AI Tool Provider Policies** — verify data handling, retention, and security of each provider
4. **Include AI in Incident Response** — add AI data leakage scenarios to IR procedures
5. **Set Usage Budgets** — control API costs and consumption per OWASP LLM10
6. **Train Staff** — use `PLATFORM_SETUP.md` as baseline; supplement with tool-specific training
7. **Audit Periodically** — review AI tool usage patterns, check for policy violations
