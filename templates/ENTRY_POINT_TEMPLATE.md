# [Project Name]

## AI Governance Framework v2.0 — Session Initializer

[Replace this line with the name of the AI tool: ChatGPT, Copilot, Gemini, etc.]

This project operates under the **AI Governance Framework v2.0**. All responses, code generation, and suggestions must comply with the governance layers defined below.

---

## Mandatory Session Start Protocol

Execute this at the start of every session. No work may begin until completed.

1. **Read** `.ai-governance/config.json` from the project root.
2. **Parse** all layers defined in `layers` and `custom_layers`.
3. **Read** governance files from each active layer:
   - **Core:** RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md, PRODUCTION_SAFETY.md
   - **Org:** All files at the org layer path (if enabled)
   - **Project:** PROJECT_RULES.md, FORBIDDEN.md, CONVENTIONS.md (if they exist)
   - **User:** Role-based preferences (if the user layer exists)
4. **Read** `.ai-governance/docs/PROGRESS.md` and `.ai-governance/docs/TASKS.md` (if they exist).
5. **Output** the following confirmation block with resolved paths:

```
=== AI GOVERNANCE FRAMEWORK v2.0 ===
Active Layers:
  Core    → [resolved path] (immutable)
  Org     → [resolved path]
  Project → [resolved path]
  User    → [resolved path]
Precedence: Core (immutable) → Org → Project → User
Config confirmed: [date]
===
```

6. **Ask** the user: "Do these layers and paths look correct? Reply YES to continue."
7. **Wait** for explicit **YES** before proceeding with any work.

---

## Core Rules Summary

From `RULES.md` (immutable — no layer may weaken these):

1. Never claim completion without verification (end-to-end testing required)
2. Track ALL user requests
3. Document as you work
4. Ask when uncertain — never assume
5. Answer questions at the end, not inline
6. No hard-coded values
7. Use existing components
8. Security first (OWASP, parameterized queries, no secrets in prompts)
9. Production safety (CONFIRM PRODUCTION protocol)
10. Never revert working code
11. Apply changes to all relevant files
12. Follow established coding standards
13. First-person singular writing style
14. Session protocol compliance

---

## Safety Boundary

From `SELF_GOVERNANCE.md`:

- No credentials, API keys, PII, or proprietary algorithms in AI prompts
- All AI output is untrusted until verified
- Match execution environment to data sensitivity
- Only approved tools and accounts

---

## Verification Hierarchy

From `QA_STANDARDS.md` — "it compiles" is NOT verification:

| Level | Description | Sufficient? |
|-------|-------------|-------------|
| 1 | Code compiles | No |
| 2 | No lint errors | No |
| 3 | Unit tests pass | Partial |
| 4 | Integration tests pass | Partial |
| 5 | End-to-end workflow verified | Yes |
| 6 | User acceptance confirmed | Yes |

---

## Production Safety

From `PRODUCTION_SAFETY.md`:

Any production modification requires:
1. State: "This will modify PRODUCTION [system]"
2. List exactly what will change
3. Ask: "Type CONFIRM PRODUCTION to proceed"
4. Only the exact phrase proceeds — "yes" or "ok" does not

---

## Interaction Protocol

From `INTERACTION_PROTOCOL.md`:

1. **Parse** — extract all tasks, questions, discussion items
2. **Execute tasks** — complete all work items
3. **Answer questions** — together at the end, not inline
4. **Address discussion items** — provide analysis, ask for decisions
5. **Verify** — confirm nothing was skipped

---

## Tracking

| File | Location | Update Frequency |
|------|----------|-----------------|
| PROGRESS.md | `.ai-governance/docs/` | After each completed task |
| TASKS.md | `.ai-governance/docs/` | As items discovered/completed |

---

## Project Overview

[Describe your project here]

## Project-Specific Rules

[Reference .ai-governance/project/PROJECT_RULES.md or add inline]
