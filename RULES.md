# AI-Assisted Development Rules

**Read this file in full before any work. Every session.** These rules are fundamental to reliable AI-assisted development.

These rules exist because AI tools consistently make the same categories of mistakes. Each rule addresses a documented failure pattern. Following these rules helps maintain reliability and trust throughout the workflow.

---

## Rule Categories

Rules are grouped by type. **All rules are mandatory** — categories indicate impact, not priority. There are no optional rules.

### CRITICAL — Security and data risk. Violation may cause data loss, security breach, or production incident.
- Rule 1: Never claim completion without verification
- Rule 8: Security first
- Rule 9: Production safety

### HIGH — Workflow discipline. Violation causes lost work, forgotten tasks, or broken continuity.
- Rule 2: Track ALL requests
- Rule 3: Document as you work
- Rule 14: Session protocol

### STANDARD — Development quality. Violation causes tech debt, duplication, or inconsistency.
- Rule 6: No hard-coded values
- Rule 7: Use existing components
- Rule 11: Apply changes to all relevant files
- Rule 12: Consistent coding standards

### BEHAVIORAL — Communication and process. Violation causes confusion or wasted effort.
- Rule 4: Ask, never assume
- Rule 5: Answer questions at the end
- Rule 10: Never revert working code
- Rule 13: Writing style

---

## Rule 1: Never Claim Completion Without Verification

**The most critical rule. This requirement is essential for reliable results.**

Before claiming any work is "done", you must have:

1. **Demonstrated the change** — show what was modified
2. **Tested end-to-end** — run it, verify output, check persistence
3. **Confirmed in the actual environment** — UI, API response, database state
4. **Documented the result** — update progress tracker

**What is NOT sufficient:**
- "Code compiles" is not verification
- "No errors" is not verification
- "The file was updated" is not verification
- "Should work" is not verification

**If you cannot verify, say so explicitly.** "I made the change but cannot verify because [reason]" is acceptable. "Task completed successfully" without proof is not.

---

## Rule 2: Track ALL Requests — Never Forget Items

When the user gives multiple tasks (compound requests, numbered lists, or tasks mentioned across messages):

1. **Immediately create a task list** with every item mentioned
2. **Work through items systematically** — mark each in-progress then complete
3. **Before ending any response** — check: "Are there pending items?"
4. **If stopping mid-way** — explicitly list what remains

The user should NEVER have to say "I already told you to do X."

**See `INTERACTION_PROTOCOL.md` for the step-by-step message parsing procedure that implements this rule.**

---

## Rule 3: Document As You Work — Not After

Update the progress tracker (`PROGRESS.md`) **immediately** after completing each task. Not at the end of the session. Not "in a moment." Immediately.

**What to document:**
- Files changed and why
- Decisions made and reasoning
- Issues discovered
- What remains to be done

**If documentation doesn't exist, the work wasn't properly completed.**

---

## Rule 4: Ask — Never Assume or Guess

When uncertain about any of the following, **stop and ask**:

- Which file, function, or component to modify
- What the expected behavior should be
- Whether to include/exclude something from scope
- What format, convention, or pattern to follow
- Whether a change is safe to make

**Never:**
- Guess at requirements ("I'll assume you want...")
- Invent specifications not discussed
- Make "improvements" beyond what was asked
- Add features, refactor code, or "clean up" unrequested areas

---

## Rule 5: Answer Questions at the End

When the user provides feedback, instructions, or corrections that contain embedded questions:

- **Do the work first**
- **Answer ALL questions together** at the end in a clearly labelled section
- **Never answer questions inline** as you go — it fragments the response
- If there are many questions, number them

**See `INTERACTION_PROTOCOL.md` for the full execution order: tasks first, then questions, then discussion items.**

---

## Rule 6: No Hard-Coded Values

All data must come from database, configuration, or environment — never hard-coded in application code.

**Forbidden:**
```
const API_URL = 'http://localhost:3000'
const options = [{ value: 'active', label: 'Active' }]
const DEFAULT_RATE = 0.98
```

**Required:**
```
const API_URL = process.env.API_URL
const options = await fetchFromDatabase('status_options')
const DEFAULT_RATE = await getConfig('default_rate')
```

**Exception:** UI framework constants (CSS classes, route definitions, component layouts) are acceptable in code.

---

## Rule 7: Use Existing Components — Never Duplicate

Before creating anything new:

1. Search the codebase for existing implementations
2. Check shared component libraries
3. Look at similar patterns in other files
4. Ask: "Does this already exist?"

If a pattern exists, use it. If it exists 3+ times, extract to a shared utility. Creating a duplicate implementation when one exists is a violation.

---

## Rule 8: Security First

### Code Security
- Parameterized queries only — never string concatenation for SQL
- Sanitize all user input
- Never expose internal IDs (numeric primary keys) in URLs or API responses — use UUIDs
- Never commit secrets, API keys, or credentials to version control
- Follow OWASP Top 10 practices

### AI-Specific Security (OWASP LLM Top 10)
- **Never paste credentials, API keys, PII, or proprietary algorithms into AI prompts** (LLM02: Sensitive Information Disclosure)
- Treat ALL AI-generated code as untrusted input — review before merge (LLM05: Improper Output Handling)
- Apply principle of least privilege to AI tool permissions (LLM06: Excessive Agency)
- Verify all AI-generated technical claims — AI tools fabricate API references, function names, and configuration options (LLM09: Misinformation)

### AI Tool-Calling and PII
- **Never scrub/tokenize user input before sending to a tool-calling AI model.** AI models that call tools (e.g., Claude tool-use, function calling) extract structured data from the message. If PII tokens like `[[PER_A]]` are in the message instead of real values, the AI stores tokens as data — corrupting it permanently.
- **Correct flow:** Current message (unscrubbed) -> trusted AI -> tool-use -> execute tool (real values) -> scrub logs after processing.
- **What to scrub:** Conversation history (before sending to AI), interaction logs (after processing). Never the current user message before a tool-calling AI.

### AI Execution Environment
- **Sensitive data must only be processed in environments approved for its classification.** Customer data, PII, financial data, and regulated information must not reach public AI tools.
- **Public AI tools must not be used for sensitive data** — regardless of plan tier or opt-out settings.
- **Enterprise AI may be used where approved by organizational policy** — with verified agreements, compliance certifications, and access controls in place.
- **External enterprise AI APIs (Claude API, OpenAI API, Bedrock, etc.) may be used only when approved and aligned with data classification** — "no training" policies reduce risk but do not eliminate exposure, compliance obligations, or accountability.
- **Self-hosted AI is required for data restricted to internal processing** — but self-hosted does not mean safe. Internal AI still requires verification, logging, access controls, and all governance rules.
- **When in doubt, use the more restrictive environment.**
- **Environment choice does not remove verification or accountability requirements** — all outputs must be verified regardless of where the AI runs.
- **If a scrubbing/protection layer is down, block external AI calls entirely** — never bypass safety because it's inconvenient.
- See `AI_ENVIRONMENTS.md` for the complete environment classification, enterprise AI guidance, and layered processing patterns.

### Credential Management
See `CREDENTIAL_SECURITY.md` for the complete credential handling protocol.

### Encryption Standards
See `ENCRYPTION.md` for encryption-at-rest, in-transit, and key management requirements.

---

## Rule 9: Production Safety — Explicit Confirmation Required

**No production data or code may be modified without explicit, typed confirmation.**

This is NOT the standard tool-approval prompt that users click through habitually. Production operations require a specific question-and-answer exchange:

**Before ANY production operation (deploy, database write, config change), the AI must:**

1. State clearly: "This will modify PRODUCTION [system/database/server]"
2. List exactly what will change
3. Ask: "Type CONFIRM PRODUCTION to proceed"
4. Wait for the user to type those exact words
5. If the user types anything else (including "yes", "ok", "do it", "1", "y"), do NOT proceed — re-ask

**This applies to:**
- INSERT/UPDATE/DELETE on production databases
- Deploying code to production servers
- Modifying production configuration files
- Pushing to production branches (main/master)
- Running migrations on production databases
- Modifying DNS, firewall, or infrastructure settings

**READ operations on production are allowed** without this protocol (SELECT queries, log viewing, etc.)

---

## Rule 10: Never Revert Working Code

**Never replace working code with older versions.**

- Build upon existing code
- Add features incrementally
- Fix issues by modifying current code, not reverting
- When confused, ask rather than reverting

If the user explicitly requests a revert, confirm what will be lost before proceeding.

---

## Rule 11: Apply Changes to All Relevant Files

When making a change that affects multiple pages, components, or files:

- **Apply to ALL affected files** — not just the one being discussed
- Check for other files that reference the same pattern, component, or data
- Update navigation, routes, and configuration if a page/feature is added or renamed
- Update tests if behavior changes

The user should not have to say "you forgot to update the other files."

---

## Rule 12: Consistent Coding Standards

Follow the project's established patterns. If no project standard exists:

### Naming
- **Files:** Follow project convention (kebab-case, PascalCase, etc.)
- **Variables/functions:** Clear, descriptive, action-oriented
- **Components:** PascalCase, descriptive names

### Code Organization
- One component per file
- Keep files under 300 lines when practical
- Extract reusable logic into utilities

### Comments
- Comment "why", not "what"
- Don't add comments to code you didn't change
- Remove TODO comments when completed

### Error Handling
- Handle potential errors explicitly
- Provide user-friendly error messages
- Log errors with context
- Never swallow errors silently

---

## Rule 13: Writing Style

When drafting emails, reports, or prose content on behalf of the user:

- Use first-person singular: "I", "me", "my"
- Never use first-person plural: "we", "our", "us" (unless the user is explicitly a team)
- Match the formality level of the context
- Be concise — lead with the point, not the reasoning

---

## Rule 14: Session Protocol

### Session Start
1. Read this file (`RULES.md`)
2. Read `PROGRESS.md` for current state
3. Read `TASKS.md` for outstanding items
4. Understand the current task before coding

### During Session
- Update `PROGRESS.md` after each completed task
- Update `TASKS.md` as items are completed or discovered
- Follow the Pre-Coding Checklist before writing code

### During Each Message Exchange
- Follow the Interaction Protocol (`INTERACTION_PROTOCOL.md`) for every user message
- Parse all items before responding — tasks, questions, discussion items
- Verify nothing was skipped before sending

### Session End
- Ensure `PROGRESS.md` reflects final state
- Ensure `TASKS.md` is current
- Document next steps
- Anyone starting a new session should be able to continue from documentation alone

---

## Pre-Coding Checklist

Before writing ANY code, verify:

- [ ] Have I read the relevant existing code?
- [ ] Am I following the project's established patterns?
- [ ] Am I using existing shared components (not duplicating)?
- [ ] Do I know how to test this end-to-end?
- [ ] Am I following the project's coding standards?
- [ ] Will this require documentation updates?
- [ ] Have I identified ALL files that need to change?
- [ ] Am I introducing any security risks?

State "Running Pre-Coding Checklist" before coding. This takes seconds and prevents minutes of rework.

---

## Summary: The Non-Negotiables

1. **Never claim completion without verification** — test everything
2. **Track ALL user requests** — never forget items
3. **Document as you work** — not after
4. **Ask, never assume** — uncertainty requires a question
5. **Questions answered at the end** — not inline
6. **No hard-coded values** — database or config only
7. **Use existing components** — never duplicate
8. **Security first** — OWASP, parameterized queries, no secrets in prompts
9. **Production safety** — typed CONFIRM PRODUCTION required
10. **Never revert** — build forward
11. **Apply to all files** — not just the one mentioned
12. **Follow coding standards** — established patterns
13. **First-person singular** — "I" not "we"
14. **Session protocol** — start, during, end procedures
