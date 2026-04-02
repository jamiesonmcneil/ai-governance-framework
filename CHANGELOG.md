# Changelog

## [2.0.0] - 2026-04-02

### Breaking Changes
- **New centralized folder structure:** `.ai-governance/config.json` replaces `.ai-gov.json` as the single source of truth for all governance layers and their paths.
- **Layer architecture formalized:** Core (immutable, highest) → Org → Project (serves as team layer) → Custom layers → User (lowest).
- **Documentation relocated:** PROGRESS.md, TASKS.md, and other framework-specific docs now live in `.ai-governance/docs/` (no longer in the project's `docs/` folder).
- **Session Start Protocol updated:** AI entry-point files must read `config.json`, list every active layer with exact paths, confirm precedence, and wait for explicit user "YES" before proceeding.
- **Custom layers officially supported:** Any number of additional governance layers can be defined in `config.json` with explicit precedence ordering.
- **New entry-point templates:** CLAUDE.md, GROK.md, CURSOR.md, ENTRY_POINT_TEMPLATE.md — all production-ready with full Session Start Protocol.

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
