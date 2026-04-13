# AI Tool Adapters

**How the governance framework is enforced on each AI tool.**

Last Reviewed: 2026-04-12 | Next Review Due: 2026-07-12 (90-day cycle)

---

## Why This Folder Exists

The framework's rules are tool-agnostic. But **enforcement** is not — every AI tool has different mechanisms (or no mechanism) for loading instructions at session start. A prose-level instruction in a context file like `CLAUDE.md` is *advisory*; the model may skip or abbreviate it. True enforcement requires either a harness-level hook or organizational admin controls.

This folder contains, per tool:
- The strongest enforcement mechanism that tool supports
- Setup instructions for that mechanism
- Fallback guidance when no hook-level enforcement is possible
- A pointer to the user-verification step from `USER_VERIFICATION.md`

The `templates/` folder (at the repo root) contains the portable prose content — the rules the AI is told to follow. This folder (`adapters/`) contains the wiring that makes the tool actually *read and execute* that content at the right time.

---

## Enforcement Tiers

| Tier | Description | Reliability |
|------|-------------|-------------|
| **A — Harness-enforced** | The tool's harness runs a hook/script at session start that injects a live instruction into the model's context. The model almost always complies because it arrives as a current instruction, not background material. | Strong |
| **B — Context-file** | The tool reads a context file (CLAUDE.md, .cursorrules, etc.) automatically. Compliance is model-dependent and drifts on short prompts. | Medium |
| **C — Admin-enforced** | No in-session mechanism. Enforcement happens at the organizational layer (DLP, sensitivity labels, access controls). | Strong for data protection, weak for behavioral rules |
| **D — User-invoked** | Governance only loads when the user pastes it or explicitly asks the AI to read it. | Weak |

**User verification (Option 4 from the framework's design) is mandatory for all tiers.** See `../USER_VERIFICATION.md`.

---

## Per-Tool Summary

| Tool | Tier | Mechanism | See |
|------|------|-----------|-----|
| **Claude Code** (CLI / Desktop / Web / IDE) | A | `SessionStart` hook in `.claude/settings.json` | `claude-code/` |
| **Microsoft Copilot** (7 scenarios — see matrix) | C | Purview DLP, sensitivity labels, Copilot Control System, Conditional Access, Power Platform admin DLP. No session hook — admin + user discipline only. | `microsoft-copilot/` (start with `canonical-reference-table.md`) |
| **Cursor** | B | `.cursorrules` file | `cursor/` |
| **Windsurf** | B | `.windsurfrules` file | `windsurf/` |
| **GitHub Copilot** | B | `.github/copilot-instructions.md` | `github-copilot/` |
| **ChatGPT** (Team / Enterprise) | B | Custom Instructions, Projects, Custom GPTs | `chatgpt/` |
| **Gemini** (Workspace / Vertex) | B | System instruction parameter, context file | `gemini/` |
| **Grok** (xAI) | B | System prompt, pasted entry-point | `grok/` |

---

## Installation Pattern

For tier A (harness-enforced) tools:

```bash
# From the project root
cp -r /path/to/ai-governance-framework/adapters/claude-code/.claude ./
# Review .claude/settings.json and edit paths for your project
```

For tier B (context-file) tools, the setup is from the `templates/` folder (as documented in `PLATFORM_SETUP.md`). The adapter folder for these tools contains only setup notes and references.

For tier C (admin-enforced) tools, the adapter folder contains admin-side configuration guidance — nothing is installed into the project itself.

---

## Why Not Just Rely on Context Files?

Context files like `CLAUDE.md`, `.cursorrules`, and `copilot-instructions.md` are loaded automatically, but they are treated by models as **reference material**, not **live instructions**. When a user's first message is short ("fix this bug", "hi"), models prioritize responding to the user's stated request over executing a 7-step preamble defined in a background file. This is a documented compliance failure pattern, not a bug in any one model.

Harness hooks (tier A) and admin controls (tier C) bypass this because they inject instructions **at the moment of session start**, which models treat as a current user/system message. The same prose in a context file vs. a hook produces very different compliance rates.

For tools that only support tier B or D, `USER_VERIFICATION.md` is the backstop.
