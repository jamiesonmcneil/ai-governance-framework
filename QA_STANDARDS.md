# Quality Assurance Standards

**Every change must be verified through the complete user workflow before claiming completion.**

**A task is only complete when it meets Level 5 verification (end-to-end workflow). Levels 1–4 indicate progress, not completion. See the Verification Hierarchy below.**

## Standards Alignment
- NIST AI RMF: Measure function — Testing, Evaluation, Verification, Validation (TEVV)
- ISO 42001: A.5 — AI System Lifecycle controls
- SOC 2: Processing Integrity

---

## Verification Hierarchy

Not all verification is equal. Higher levels subsume lower levels.

| Level | What It Proves | Sufficient? |
|-------|---------------|-------------|
| 1. Code compiles | Syntax is valid | NO |
| 2. No console errors | No runtime exceptions | NO |
| 3. API returns data | Backend works | NO |
| 4. UI displays correctly | Frontend renders | NO |
| 5. **End-to-end workflow works** | Feature functions | **YES** |
| 6. **Persists after refresh** | State is saved | **YES (for data features)** |

**Minimum acceptable: Level 5.** For data features: Level 6.

---

## Testing Checklist (Every Change)

- [ ] Does the feature work in the UI?
- [ ] Does data persist correctly (survives page refresh)?
- [ ] Does it work for different user roles (if applicable)?
- [ ] Are error cases handled gracefully?
- [ ] Does existing functionality still work (no regressions)?
- [ ] Is the build clean (no warnings introduced)?

---

## Test Case Format

For formal QA, use the **6-Column Format**:

| Column | Description |
|--------|-------------|
| **Test Summary** | Brief description of what is being tested |
| **Pre-Conditions** | Required state before test execution |
| **Action** | Step-by-step actions to perform |
| **Expected Result** | What should happen |
| **Actual Result** | PASS / FAIL / SKIP (with reason) |
| **Evidence** | Screenshot, log output, or API response |

---

## AI-Generated Code Review

All AI-generated code must be reviewed with the same rigor as human-authored code. Additional checks:

- [ ] **No hallucinated APIs** — verify that all imported modules, functions, and methods actually exist
- [ ] **No fabricated configuration** — verify that config options, flags, and parameters are real
- [ ] **No security vulnerabilities** — check for SQL injection, XSS, IDOR, hardcoded secrets
- [ ] **No placeholder data** — ensure no mock/test data was left in production code
- [ ] **Follows project patterns** — not introducing a new pattern when one exists
- [ ] **Dependencies exist** — any new imports/packages actually exist in the registry

---

## Severity Levels

| Level | Name | Definition | Response |
|-------|------|------------|----------|
| S1 | Blocker | System crash, data loss, no workaround | Fix immediately |
| S2 | Critical | Major feature broken, workaround exists | Fix within 1 day |
| S3 | Major | Feature works with significant limitation | Fix within 1 sprint |
| S4 | Minor | Cosmetic issue, easy workaround | Backlog |
| S5 | Trivial | Typo, alignment, no functional impact | Low priority |

---

## Red Flags — Stop and Investigate

When these symptoms appear, do NOT continue coding — investigate systematically:

### "Data resets / doesn't persist"
1. Check database directly — was the data written?
2. Verify API is receiving correct data
3. Check frontend is sending correct payload
4. Verify no caching issues

### "I already told you to fix this"
1. Acknowledge the failure
2. Read the previous instructions carefully
3. Diagnose the complete flow (DB → API → Frontend)
4. Test every layer
5. Only claim success after end-to-end verification

### "No errors but nothing happens"
1. Check browser console
2. Check network requests
3. Check server logs
4. Verify event handlers are attached
5. Check for silent error swallowing
