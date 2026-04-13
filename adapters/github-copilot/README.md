# GitHub Copilot Adapter

**Tier B — Context-file only. No hook-level enforcement available.**

---

## What GitHub Copilot Supports

GitHub Copilot reads `.github/copilot-instructions.md` at the repo root. This provides instructions to Copilot Chat and, to a lesser extent, inline suggestions.

Limitations:
- Inline code suggestions rarely honor the full instruction set — they prioritize code completion speed
- Copilot Chat respects instructions more consistently but still tier B
- No session memory, no progress tracking, no Session Start Protocol enforcement
- No hook-equivalent mechanism

---

## Installation

```bash
mkdir -p .github
cp /path/to/ai-governance-framework/templates/copilot-instructions.md ./.github/copilot-instructions.md
```

Edit the file to fill in project-specific context. Keep it **short** — Copilot Chat truncates long instruction files.

---

## User Verification Is Mandatory

Tier B enforcement. For Copilot Chat, users must verify that governance-relevant responses reference the rules. The full Session Start audit block pattern is not practical for Copilot Chat's UI; instead, use the condensed verification pattern in `../../USER_VERIFICATION.md`.

If Copilot Chat produces output that violates a governance rule, reply: `Review .github/copilot-instructions.md — this violates [specific rule].`

---

## Copilot-Specific Notes

- **Inline suggestions are not governable.** Assume inline code suggestions may produce hard-coded values, missing account filters, or insecure patterns. Review all inline suggestions before accepting.
- **Code review Copilot:** If you use Copilot for code review, add a second reviewer (human or another AI tool) that does respect the full framework.
- **Copilot for Business/Enterprise:** These tiers do not train on your code; free tier does. Do not use free Copilot for work code.
- **Copilot Chat @workspace:** When asking Copilot about your codebase, it has access to all indexed files. Do not index files containing secrets even temporarily.

---

## Known Gaps

GitHub Copilot is the weakest-enforced tool in the framework's coverage because:

1. No session model
2. Instruction files are frequently truncated
3. Inline suggestions bypass instructions entirely
4. No way to force the Session Start Protocol

For projects handling regulated data, use Claude Code (tier A) for governance-sensitive work. Use GitHub Copilot as a productivity tool with strict human review, not as a governed AI assistant.
