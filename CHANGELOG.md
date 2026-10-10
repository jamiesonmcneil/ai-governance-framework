# Changelog

## [2.2.0] - 2026-10-10

### Changed
- `AI_ENVIRONMENTS.md`: new "Organization-approved accounts and services" under the Approval Requirement. An
  organization's accountable authority may approve a specific AI service and account type (a paid individual
  account included) for defined uses and data classifications, recorded in its governance, under a floor no
  approval can lower: never credentials, secrets, keys or Restricted data; personal, third-party confidential or
  regulated data only through a service under a business agreement; no universal requirement weakened; stricter
  rules prevail. A sole owner approving for the organization is not self-approval.
- `RULES.md` Rule 8, `SELF_GOVERNANCE.md`, `USER_SETUP.md`, `adapters/chatgpt/README.md`, `templates/cursorrules`
  and `templates/windsurfrules`, and the `examples/basic-project` and `examples/lightweight-project` CLAUDE.md files: the
  plan-tier statements now admit an organization-approved account.

### Why
The plan-tier rule assumed every organization buys a Team or Enterprise plan. A sole-owner company holds only
individual paid accounts, and had no way to approve one under its own accountable authority. Grounding:
ISO/IEC 27001:2022 Annex A 5.23 (the organization decides which cloud services it uses and on what terms) and
NIST AI RMF GOVERN 1 (risk decisions by an accountable authority).

### Migration
No change for any organization until it records an approval. Dependents walked per CONTRIBUTING:
`examples/acme-org/TECH_STACK.md` and `adapters/microsoft-copilot/canonical-reference-table.md` state no plan rule
and are unchanged.

---
## [2.1.0] - 2026-04-13

### Added
- Enforcement tiers model (A/B/C/D) in PLATFORM_SETUP.md
- `adapters/` folder with per-tool enforcement guidance
- Claude Code Tier A: `SessionStart` hook (`.claude/hooks/session-start.sh`) that injects live instruction for reliable Session Start Protocol execution
- Microsoft Copilot Tier C: full admin-side guidance (3 tiers + DLP starter policies)
- `USER_VERIFICATION.md` as universal backstop for all tiers

### Why
Claude.md alone is routinely skipped on short first messages. The hook + verification model closes this reliability gap while keeping the framework tool-agnostic.

### Migration
No breaking changes. Claude Code users: copy `adapters/claude-code/.claude/` into the project and run `chmod +x .claude/hooks/session-start.sh`. All users should adopt the one-second verification check in `USER_VERIFICATION.md`.

---

## [2.0.0] - 2026-04-02

### Breaking Changes
- **New centralized folder structure:** `.ai-governance/config.json` replaces `.ai-gov.json` as the single source of truth for all governance layers and their paths.
- **Layer architecture formalized:** Core (immutable, highest) → Org → Project (serves as team layer) → Custom layers → User (lowest).
- **Documentation relocated:** PROGRESS.md, TASKS.md, and other framework-specific docs now live in `.ai-governance/docs/` (no longer in the project's `docs/` folder).
- **Session Start Protocol updated:** AI entry-point files must read `config.json`, list every active layer with exact paths, confirm precedence, and wait for explicit user "YES" before proceeding.
- **Custom layers officially supported:** Any number of additional governance layers can be defined in `config.json` with explicit precedence ordering.
- **New entry-point templates:** CLAUDE.md, GROK.md, CURSOR.md, ENTRY_POINT_TEMPLATE.md — all production-ready with full Session Start Protocol (7 core files listed, confirmation block with paths, explicit YES gate).
- **Improved .gitignore:** Explicit protection for User layer and AI tool local files (.cursorignore, .claude/, .cursor/, .windsurf/, etc.).
- **Optional core/org subfolders:** Clarified that `.ai-governance/core/` and `.ai-governance/org/` are optional local symlinks; `config.json` paths take precedence.
- **v1 migration support:** Step-by-step migration guide with `rm -f .ai-gov.json .ai-gov.user.json`; v1 files are ignored once `config.json` exists.

### Why
Addresses issues with layer identification, folder organization, and scalability for company-wide use (central Core/Org + per-project + per-user). Single source of truth eliminates confusion from multiple config files.

### Migration
See "Migration from v1.x to v2.0" section in README.md.

### Deprecated
- `.ai-gov.json` — replaced by `.ai-governance/config.json`
- `.ai-gov.user.json` — replaced by `.ai-governance/user/` layer
- `project-governance/` folder — replaced by `.ai-governance/project/`

---

## [1.0.1] - 2026-04-01 (Final Polish)
- Added Quick Navigation, Versioning Policy, and For Teams sections to README.md
- Created minimal CHANGELOG.md
- Minor consistency updates (dates, references)

## [1.0.0] - 2026-03-25 (Initial Public Release)
- Added user layer: `USER_SETUP.md`, `.ai-gov.user.json`, and role-based onboarding
- Improved README with tiered adoption model and Session Start Protocol
- Stabilized core governance files
- Tagged `v1.0.0`
