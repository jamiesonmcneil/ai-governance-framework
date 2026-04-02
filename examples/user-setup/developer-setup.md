# Developer Setup — Completed Example

This shows what a completed developer onboarding looks like.

---

## Quick Setup (Done)

- [x] Read the 3 core rules (no sensitive data, verify outputs, you own the results)
- [x] Disabled training on Claude (Settings > Privacy > "Help improve Claude" OFF)
- [x] Disabled training on GitHub Copilot (github.com/settings/copilot > unchecked snippets)
- [x] Usage type: **Developer**
- [x] Acknowledged governance (created `.ai-governance/user/`)

## Required Reading (Done)

- [x] `SELF_GOVERNANCE.md` — understood what never goes into AI tools
- [x] `RULES.md` — reviewed all 14 rules, key takeaways:
  - Never claim work is done without testing it end-to-end
  - Track all tasks, don't forget items
  - Use existing components before creating new ones
  - No hard-coded values, no credentials in code
- [x] `PRODUCTION_SAFETY.md` — understood CONFIRM PRODUCTION protocol

## User Config (Created)

File: `.ai-governance/user/`

```json
{
  "role": "developer",
  "ai_tools": ["claude-code"],
  "governance_acknowledged": "2026-03-30"
}
```

## Tools Configured

- **Claude Code:** CLAUDE.md present in project, memory enabled
- **GitHub Copilot:** `.github/copilot-instructions.md` present, privacy mode on

## Time Spent

~10 minutes (reading + setup)
