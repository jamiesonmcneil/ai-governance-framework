# Progress, Task, and Memory Tracking

**AI tools lose context between sessions. Written tracking is the only reliable continuity mechanism.**

No established framework (NIST AI RMF, ISO 42001, OWASP, AGENTS.md) addresses the practical problem of AI session continuity. Enterprise tools like IBM watsonx.governance track model lifecycles, but nothing addresses the developer's daily reality: starting a new AI chat session and having zero context from yesterday. This tracking system fills that gap.

---

## Lightweight Mode (Small Projects)

For one-off scripts, personal projects, or short-lived work:

- Use a single `PROGRESS.md` combining progress and tasks
- Skip HISTORY.md and CONTEXT.md
- Update at session end (not after each task)

Use the full tracking system for any project that spans multiple sessions, has production users, or involves more than one contributor. If the project grows beyond a single session, migrate to full tracking immediately. When in doubt, use full tracking — the cost of maintaining files is far lower than the cost of losing context.

---

## Tracking Files (Full Mode)

Every project using AI assistance should maintain these files in a `.ai-governance/docs/` directory (or equivalent like `.claude/`):

| File | Purpose | Update Frequency |
|------|---------|-----------------|
| `PROGRESS.md` | What was done, when, and why | After EACH completed task |
| `TASKS.md` | Outstanding work items, action items, follow-ups | As items are discovered or completed |
| `HISTORY.md` | Archived completed sessions | At session end (move from PROGRESS) |
| `CONTEXT.md` | Business context, stakeholders, terminology | When new context is learned |

---

## PROGRESS.md — Active Progress Tracker

**Purpose:** Current session work log. Updated in real-time, not at session end.

### Structure
```markdown
# Current Progress

**Last Updated:** [Date] (Session [N])

---

## Session [N] - IN PROGRESS ([Date])

### Summary
[1-2 sentence summary of session focus]

### Tasks Completed
- [x] Task description — [brief outcome]
- [ ] Task in progress — [current state]

### Files Changed
| File | Change |
|------|--------|
| `path/to/file.ts` | Added feature X |
| `path/to/file2.ts` | Fixed bug Y |

### Key Decisions
1. **Decision:** [What] — **Reason:** [Why]

### Issues Discovered
- [Description] — [Status: resolved/open]

### Next Steps
- [ ] Remaining item 1
- [ ] Remaining item 2

---

## Session [N-1] - COMPLETED ([Date])
[Previous session — moves to HISTORY.md when PROGRESS.md exceeds 300 lines]
```

### Rules
- Update **immediately** after each task — not batched at end
- Include file paths for every change
- Document decisions with reasoning
- Note anything that would help a future session continue

---

## TASKS.md — Outstanding Work Tracker

**Purpose:** All known work items — open, in-progress, waiting, and recently completed.

### Structure
```markdown
# Action Items & Follow-ups

**Last Updated:** [Date]

---

## Open Action Items

### High Priority
| ID | Task | Project | Owner | Due | Status |
|----|------|---------|-------|-----|--------|
| T001 | Description | Project | Name | Date | OPEN / IN PROGRESS / BLOCKED |

### Medium Priority
[Same format]

### Low Priority / Future
[Same format]

---

## Waiting For Response
| ID | Waiting For | From | Asked | Context |
|----|-------------|------|-------|---------|
| W001 | Description | Person | Date | Why waiting |

---

## Recently Completed
| ID | Task | Project | Completed |
|----|------|---------|-----------|
| C001 | Description | Project | Date |
```

### Rules
- Assign unique IDs (T001, T002...) to every task
- Never remove a task — mark it completed and move to Recently Completed
- Tasks discovered during work get added immediately
- Include "Waiting For" section for items blocked on others
- Review at session start — are any completed? any new blockers?

---

## HISTORY.md — Session Archive

**Purpose:** Permanent record of completed sessions. Searchable history.

### Archiving Protocol

When `PROGRESS.md` exceeds **300 lines**:

1. Move all completed sessions (everything except the current session) to `HISTORY.md`
2. Add them at the top (newest first)
3. Keep only the current session in `PROGRESS.md`
4. HISTORY.md is append-only — never delete entries

### Structure
```markdown
# Session History

---

## [Month] [Year]

### [Date] - [Focus] (Session [N])
**Summary:** [What was accomplished]
**Completed:** [Key items]
**Files Changed:** [Count]
**Key Decisions:** [If any]

---
```

### Archiving Schedule
- Archive when PROGRESS.md > 300 lines
- Archive at minimum once per month
- Never lose session data — if in doubt, archive to HISTORY.md

---

## CONTEXT.md — Business Context

**Purpose:** Information that helps AI tools understand the project but isn't derivable from code.

### What to Include
- Company/project overview
- Key terminology and abbreviations
- Stakeholder names, roles, and responsibilities
- System architecture (high-level)
- External integrations and their purposes
- Important business rules
- Timeline and deadline information

### What NOT to Include
- Credentials (see `CREDENTIAL_SECURITY.md`)
- Code patterns (derivable from codebase)
- Git history (use `git log`)

---

## Memory / AI Context Files

Some AI tools (Claude Code, Cursor) support persistent memory files that carry context across sessions.

### Rules for AI Memory
- Store only information useful across sessions (user preferences, project decisions, confirmed approaches)
- Never store credentials, passwords, or PII
- Keep memory concise — bloated context degrades performance
- Review periodically — remove stale or incorrect information
- Memory supplements tracking files — it does not replace them

### What Belongs in Memory vs Tracking

| Information | Memory | PROGRESS | TASKS |
|-------------|--------|----------|-------|
| User preferences | Yes | No | No |
| Feedback on approach | Yes | No | No |
| Current task details | No | Yes | Yes |
| Completed work | No | Yes (then HISTORY) | Yes (Recently Completed) |
| Outstanding items | No | No | Yes |
| Business decisions | Yes (if recurring) | Yes (when made) | No |
| Technical patterns | No (in codebase) | No | No |

---

## File Size Limits

| File | Target Size | Max Size | Action When Exceeded |
|------|------------|----------|---------------------|
| PROGRESS.md | < 200 lines | 300 lines | Archive to HISTORY.md |
| TASKS.md | < 300 lines | 500 lines | Archive completed items |
| HISTORY.md | Unlimited | — | Organize by month/year |
| CONTEXT.md | < 200 lines | 300 lines | Move details to separate topic files |
