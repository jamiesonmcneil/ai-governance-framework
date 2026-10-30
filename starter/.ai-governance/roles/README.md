# Roles

One file per role. Each starts with an empty **Active rules** section and example rules inside
`<!-- EXAMPLE ... -->` comment blocks, which are inactive until a team copies them into **Active rules**.

| File | Role |
|---|---|
| `developer.md` | Developer |
| `qa-tester.md` | QA / tester |
| `architect.md` | Architect |
| `security.md` | Security |
| `it-operations.md` | IT / operations |
| `business-analyst.md` | Business analyst |
| `project-manager.md` | Project / product manager |
| `data-analyst.md` | Data / reporting analyst |
| `general-staff.md` | General staff |

To add a role, copy `_TEMPLATE.md`. Role rules add strictness only; where a role rule and a higher layer differ,
the stricter applies. Each person selects a role in their own `CLAUDE.local.md` (Claude Code) or pastes the
role's active rules into their tool's instructions (Claude chat, Microsoft 365 Copilot).
