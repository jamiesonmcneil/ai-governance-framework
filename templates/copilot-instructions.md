# GitHub Copilot Instructions
# Place this file at: .github/copilot-instructions.md
#
# Scope: This file governs **GitHub Copilot** only — Copilot Chat in IDE,
# inline suggestions, and @workspace queries.
#
# This is NOT for Microsoft 365 Copilot, Copilot Chat with Entra,
# Power Platform Copilot, or consumer Microsoft Copilot. Those are governed
# admin-side via Purview DLP and the seven-scenario matrix in
# /path/to/ai-governance-framework/adapters/microsoft-copilot/canonical-reference-table.md
# — there is no per-project context file for those Copilot surfaces.

## Governance

Follow all rules in the AI Governance Framework (/path/to/ai-governance-framework/RULES.md).
Follow the Interaction Protocol (/path/to/ai-governance-framework/INTERACTION_PROTOCOL.md) for message parsing and response structure.
All rules apply — categories (Critical/High/Standard/Behavioral) indicate impact, not priority.
Never paste credentials, PII, or proprietary data into prompts. See SELF_GOVERNANCE.md.
If unsure about any requirement or behavior, ask instead of assuming.
Match the AI execution environment to data sensitivity. Never process sensitive data through public AI.
Use approved tools and accounts for work data — avoid personal or unapproved tools.
AI assists decisions — humans remain accountable. AI output should not be the sole basis for high-impact decisions.

## Mandatory Rules

1. **No hard-coded values** — use environment variables, database queries, or configuration files. Never inline API URLs, options lists, default values, or magic numbers.
2. **No credentials in code** — never include passwords, API keys, tokens, or secrets. Use env vars or the project's credential store.
3. **Parameterized queries only** — never use string concatenation for SQL. Use prepared statements with bound parameters.
4. **UUIDs in URLs and APIs** — never expose numeric database IDs in URL paths, query parameters, or API responses. Use UUIDs.
5. **Use existing components** — before creating anything, search the codebase for existing implementations. Reuse shared components, utilities, and patterns.
6. **Follow project patterns** — match the naming conventions, file structure, and coding style already established in the project.
7. **No code duplication** — if a pattern exists, use it. If it exists 3+ times, extract to shared utility.
8. **Security first** — sanitize all user input, handle errors explicitly, never swallow exceptions silently. Follow OWASP Top 10.
9. **Treat AI output as untrusted** — all generated code must be reviewed. Verify that imported modules, functions, and config options actually exist.

## Code Style

- One component per file
- Keep files under 300 lines
- Comment "why", not "what"
- Descriptive variable and function names
- Handle all error cases explicitly

## Testing

- Every change must be testable end-to-end
- Code compiling is NOT sufficient verification
- Verify in the actual UI, not just the console

## User Verification (Tier B fallback)

GitHub Copilot enforcement is Tier B (instructions file). Inline suggestions in particular bypass these instructions. Users must:
- Review every inline suggestion before accepting
- For Copilot Chat: if a response violates a rule above, reply: `Review .github/copilot-instructions.md — this violates [specific rule].`
- See /path/to/ai-governance-framework/USER_VERIFICATION.md for the full verification protocol.
