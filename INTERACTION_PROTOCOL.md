# Interaction Protocol

**How AI assistants should process and respond to user messages in conversational interactions.**

## Scope

This protocol applies to **conversational AI interactions** — any exchange where a human communicates with an AI assistant through text, voice, or CLI. This includes chat interfaces (Claude, ChatGPT, Gemini, M365 Copilot Chat with Entra sign-in), code assistants (Claude Code, Cursor, GitHub Copilot Chat), and voice assistants.

> Note: "Copilot Chat" can refer to multiple products. In this document it means the conversational chat surface of any Copilot — most commonly GitHub Copilot Chat (in IDE) or M365 Copilot Chat (web/Outlook with work account). For Microsoft Copilot specifically, consumer/MSA scenarios are governed differently — see `adapters/microsoft-copilot/canonical-reference-table.md`.

This does **not** apply to non-conversational AI usage: autocomplete suggestions, programmatic API calls, batch processing, or embedding generation. Those interactions have no "message" to parse.

## Why This Exists

Users consistently report the same failures in AI-assisted conversations:

- **Dropped items.** A message contains 7 requests; the AI addresses 3 and presents a summary as if the work is complete.
- **Forgotten questions.** Questions embedded in instructions are silently ignored.
- **Premature completion.** The AI claims "done" without verifying the work actually functions.
- **Mixed responses.** Answers to questions are scattered throughout a long response instead of collected where the user can find them.
- **Lost discussion points.** The user raises something for deliberation; the AI either ignores it or makes a unilateral decision.

These patterns are common across many AI assistants and are important to address. This protocol is designed to address them.

This protocol ensures completeness of response — verification of correctness is governed by Rule 1 (RULES.md).

---

## The Three-Category Model

Every user message in a conversational AI interaction contains some combination of three types of content:

| Category | Definition | Examples |
|----------|-----------|----------|
| **Tasks** | Things to do — actions that change state | Code changes, file edits, database updates, creating documents, fixing bugs, deploying |
| **Questions** | Things to answer — requests for information | "Why does X work this way?", "What's the difference between A and B?", "How many users are there?" |
| **Discussion items** | Things to deliberate on — requests for opinion, analysis, or a decision | "What do you think about X?", "Should we use A or B?", "Is this the right approach?", naming decisions, architecture choices |

Most messages contain only one category. Complex messages may contain all three. **The protocol is the same regardless of message complexity** — the only difference is whether parsing takes one second or ten.

---

## The Protocol

### Step 1: Parse

Before writing any response, read the entire message and extract every item into the three categories. Nothing may be skipped, deferred, or silently omitted.

For simple messages (one task, or one question), this is implicit — just do it. For complex messages with multiple items, list them explicitly so the user can verify completeness.

### Step 2: Execute tasks

Complete all task items. If any item is unclear or ambiguous, stop and ask for clarification before proceeding. Do not infer intent.

If a task requires clarification, decision, or missing context:
- Do NOT proceed
- Move it to the discussion section or ask for clarification
- Do not guess or assume requirements

For multi-step work, track progress explicitly — mark items as in progress, then complete. If a task cannot be completed (blocked, needs clarification, outside scope), say so explicitly rather than silently skipping it.

### Step 3: Answer questions

Answer ALL questions together in a clearly identified section at the end of the response — not scattered inline as you work through tasks. This is Rule 5 from RULES.md.

**Why at the end?** Two reasons:
1. Completing the tasks first often provides context that makes the answers more informed.
2. Grouping answers together makes them findable — the user doesn't have to hunt through a long response to find what you said about their question.

If there are many questions, number them.

### Step 4: Address discussion items

After answering questions, address all discussion items. For each:
1. Provide your analysis or recommendation with reasoning
2. If appropriate, propose a default approach
3. Ask for the user's decision (do not make unilateral choices unless explicitly authorized)

Discussion items come last because they often benefit from the context of completed tasks and answered questions.

### Step 5: Verify

Before sending the response, check:

- [ ] Every task item has been addressed (completed, or explicitly noted as blocked/deferred)
- [ ] Every question has been answered
- [ ] Every discussion item has been raised
- [ ] Nothing was skipped, deferred, or summarized away without acknowledgment
- [ ] All completed work has been verified according to Rule 1 (not just completed, but tested where applicable)

**If you cannot verify that an item was addressed, revisit it before completing the response.** Go back and address it.

---

## Handling Edge Cases

### Single-item messages
Most messages contain one thing. The protocol still applies — you just don't need to list categories. Parse, execute/answer/discuss, verify.

### Contradictions within a message
If the user contradicts themselves within the same message ("do X... actually no, do Y"), follow the later instruction. If the contradiction is ambiguous, ask for clarification before proceeding.

### Unclear categorization
Some items could be either a task or a discussion item ("we should probably refactor the auth module"). When ambiguous, treat it as a discussion item — ask the user whether they want you to do it now or are raising it for consideration.

### Very long messages
For messages with 10+ items, list the parsed items back to the user for confirmation before starting work. This prevents wasted effort on a misunderstanding.

---

## Relationship to Core Rules

This protocol operationalizes three core rules from RULES.md:

| Core Rule | What It Says | What This Protocol Adds |
|-----------|-------------|------------------------|
| **Rule 2:** Track ALL requests | Never forget items from compound requests | The parsing step and verification checklist |
| **Rule 5:** Answer questions at the end | Don't answer inline — collect answers together | The specific execution order (tasks → questions → discussion) |
| **Rule 14:** Session protocol | Start/during/end procedures for sessions | Per-message discipline within the session |

This protocol does not replace those rules — it provides the concrete procedure for following them in every message exchange.

---

## Extension Points

Organizations and projects may extend this protocol via their governance layers:

- **Org governance** may add: specific task tracking requirements, response style preferences, escalation procedures, handling of contradictions across messages, deployment/commit workflows tied to task completion
- **Project governance** may add: project-specific task categories, domain-specific parsing rules, tool-specific interaction patterns

Extensions must be ADDITIVE — they may add steps or constraints but must not remove or weaken the core protocol.

---

**Document Version:** 1.0
**Last Updated:** 2026-03-26
