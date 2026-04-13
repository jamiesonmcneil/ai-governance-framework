# Contributing

This framework is intentionally strict. Every rule exists because of a real-world failure. Contributions are welcome, but they must maintain the framework's integrity.

## Contribution Guidelines

### Contributions MUST:

- **Not weaken safety or verification** — rules are mandatory, not suggestions. Do not propose making rules optional or reducing verification requirements.
- **Maintain separation of concerns** — governance is not architecture. Core rules are not project-specific patterns. Keep the layers distinct.
- **Be grounded in real-world failure** — every rule traces to a documented incident or established standard. "It would be nice to..." is not sufficient justification.
- **Not introduce project-specific content** — the core framework is universal. Project-specific patterns, conventions, and tools belong in project-governance extensions, not here.

### How to Contribute

1. **Open an issue first** for major changes — describe the problem, the proposed solution, and the real-world failure or standard it addresses.
2. **Small fixes** (typos, broken links, outdated platform info) can go directly to a pull request.
3. **New rules** require evidence of a failure pattern they prevent. "This seems like a good idea" is not evidence.
4. **Platform updates** (SELF_GOVERNANCE.md training policies, PLATFORM_SETUP.md tool configurations) are encouraged — these change frequently and community help keeping them current is valuable.

### What We Will NOT Accept

- Proposals to make core rules optional or configurable
- Project-specific or vendor-specific content in core documents
- Changes that reduce the strictness of security, verification, or production safety requirements
- Additions without clear justification grounded in failure prevention
- Contributions that introduce ambiguity — if a rule can be interpreted two ways, it will be rejected until clarified

## Dependent Updates — Sync Protocol

**When you edit a Core-layer file, one or more adapter/template/example files may need corresponding updates.** This checklist is load-bearing — the framework's tier-A hook enforcement and tier-C admin-side enforcement only stay aligned if contributors follow it. Skipping this step is how MS Copilot enforcement mappings drift from the rules they're supposed to enforce.

**Rule:** Before committing a change to any Core file listed in the left column, review and update (or explicitly confirm no update is needed for) every file in the right column.

| If you edit... | Then review... | Why |
|----------------|----------------|-----|
| `RULES.md` | `adapters/microsoft-copilot/enforcement-mapping.md` (when it exists), `templates/CLAUDE.md`, `templates/CURSOR.md`, `templates/GROK.md`, `templates/ENTRY_POINT_TEMPLATE.md`, `examples/*/CLAUDE.md`, `README.md` summary | Rule changes must propagate to every entry-point and every control mapping |
| `SELF_GOVERNANCE.md` (training-policy table or When-to-Use-Which-Tool) | `USER_SETUP.md` opt-out checklist, `AI_ENVIRONMENTS.md`, `adapters/microsoft-copilot/canonical-reference-table.md`, `adapters/microsoft-copilot/README.md`, `examples/acme-org/TECH_STACK.md`, `examples/usage-modes/README.md` | Platform/tier classifications must stay consistent across the framework |
| `FORBIDDEN.md` | `templates/copilot-instructions.md`, `templates/cursorrules`, `templates/windsurfrules`, every project-level `FORBIDDEN.md` in `examples/` | Forbidden patterns surface in every tool's instruction file |
| `INTERACTION_PROTOCOL.md` | All four entry-point templates (`CLAUDE.md`, `CURSOR.md`, `GROK.md`, `ENTRY_POINT_TEMPLATE.md`) | The protocol is referenced by each template's Session Start Protocol section |
| `PRODUCTION_SAFETY.md` | `templates/CLAUDE.md`, `templates/CURSOR.md`, `templates/GROK.md`, `templates/ENTRY_POINT_TEMPLATE.md` | The CONFIRM PRODUCTION protocol is referenced in every entry-point |
| `QA_STANDARDS.md` (Verification Hierarchy) | Entry-point templates, `adapters/microsoft-copilot/dlp-policy-template.md` Verification Tests section | Verification levels referenced in every entry-point and the DLP rollout plan |
| `CREDENTIAL_SECURITY.md` | `templates/CLAUDE.md`, `templates/copilot-instructions.md`, `adapters/microsoft-copilot/dlp-policy-template.md` Policy 1 | Credential rules map to DLP sensitive-info-type list in MS Copilot adapter |
| `AI_ENVIRONMENTS.md` | `adapters/microsoft-copilot/canonical-reference-table.md`, `examples/acme-org/TECH_STACK.md` | Environment classification informs per-scenario Copilot classification |
| `adapters/microsoft-copilot/canonical-reference-table.md` | `SELF_GOVERNANCE.md` MS Copilot rows, `USER_SETUP.md` opt-out checklist + role sections, `USER_VERIFICATION.md` scenario list, `adapters/microsoft-copilot/README.md`, `adapters/microsoft-copilot/tier-classification.md`, `adapters/microsoft-copilot/dlp-policy-template.md`, `examples/acme-org/TECH_STACK.md` | Scenario definitions are referenced by every piece of MS Copilot governance |
| `USER_VERIFICATION.md` | Entry-point templates (recovery-reply examples), `adapters/*/README.md` pointers | The recovery replies must stay consistent with the per-tool guidance |
| Any `adapters/*/README.md` | `adapters/README.md` tier table, `PLATFORM_SETUP.md` tool-specific section | Per-tool mechanism changes propagate to the tier model and setup guide |
| `CHANGELOG.md` | `README.md` (version badge + "Current stable release" line), git tag | Version bumps: CHANGELOG first, then README, then tag |

**Checklist sequence when editing Core:**

1. Make the Core change
2. Walk the row above for the file you changed
3. For each listed dependent, read it and either:
   - Update it to align with the Core change
   - Confirm out loud (in the commit message or PR description) that no update is needed and why
4. Only then commit
5. If multiple Core files changed in one commit, walk every applicable row

**Adding new items to the checklist:** when you create a new adapter, template, or example, add a row to this table pointing at the upstream files that affect it. A file not in this table is invisible to future contributors and will drift.

**This checklist replaces no other rule.** Rule 1 (verification), Rule 11 (apply to all relevant files), and Rule 3 (document as you work) still apply — this checklist is the concrete implementation of Rule 11 for framework-internal edits.

---

## Code of Conduct

Be direct, be constructive, be respectful. This is a governance framework — precision and clarity matter more than style.
