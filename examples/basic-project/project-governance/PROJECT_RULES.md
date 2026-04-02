# Project Rules

Project rules are ADDITIVE only. They may strengthen or extend core governance but must not weaken or contradict core rules.

Core rules: `/path/to/ai-governance-framework/RULES.md` (14 rules, all mandatory)

---

## Rule P1: Input Validation on All Endpoints

**Severity:** HIGH
**Applies to:** All API endpoints
**Requirement:** Every endpoint must validate input before processing. Never trust client-provided data.
**Why:** Prevents injection attacks, data corruption, and unexpected behavior.

---

## Rule P2: All Changes Reflected in Tracking Files

**Severity:** STANDARD
**Applies to:** All development work
**Requirement:** Every change must be recorded in PROGRESS.md and relevant tasks updated in TASKS.md.
**Why:** Maintains continuity across AI sessions and provides audit trail.

---

## Rule P3: No Unapproved AI Tool Usage

**Severity:** HIGH
**Applies to:** All project work
**Requirement:** Only use AI tools and accounts approved for this project (as configured in `.ai-governance/config.json`). No personal AI accounts or unapproved browser extensions.
**Why:** Prevents data leakage through shadow AI usage.
