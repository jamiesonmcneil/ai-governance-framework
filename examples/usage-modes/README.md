# Usage Modes — Real-World Examples

How governance applies depends on what you're doing with AI. Here are common scenarios and what to watch for.

---

## Writing Emails or Documents

**Scenario:** You ask AI to draft a customer email, meeting summary, or internal memo.

**What to watch for:**
- Did you paste internal context (names, project details, financials) into the prompt? Use anonymized descriptions instead.
- Read the output before sending. AI produces generic, sometimes tone-deaf content.
- Check facts — AI will confidently include details you never mentioned.

**Example:**
> "Draft an email to a client explaining the project delay"

Good — no sensitive data in the prompt. Review the output for accuracy and tone before sending.

> "Draft an email to John Smith at Acme Corp about the $2.3M contract delay"

Bad — real name, company, and dollar amount in a public AI tool. Use: "Draft an email to a client about a project delay" instead.

---

## Analyzing Data or Reports

**Scenario:** You ask AI to summarize a report, calculate trends, or interpret financial data.

**What to watch for:**
- Never upload raw customer data, financial records, or PII. Anonymize or aggregate first.
- AI makes convincing math errors. Verify every number independently.
- AI may invent trends or correlations that don't exist in your data.

**Example:**
> "Here are quarterly revenue figures: Q1 $1.2M, Q2 $1.4M, Q3 $1.1M. What's the trend?"

Acceptable if these are not confidential. But verify whatever trend analysis AI produces — it may misinterpret a dip as a "concerning decline" or ignore seasonality.

> (Uploading a spreadsheet with customer names, emails, and purchase history)

Never do this with a public AI tool. Anonymize the data first or use an approved enterprise tool.

---

## Brainstorming Ideas

**Scenario:** You use AI to explore options, generate ideas, or think through a problem.

**What to watch for:**
- Lowest risk of all modes — but don't paste confidential business context to "give AI more to work with."
- AI suggestions sound good but may be impractical, already tried, or irrelevant to your industry.
- Treat outputs as starting points, not answers.

**Example:**
> "What are some ways to improve customer retention for a SaaS product?"

Fine — generic question, no sensitive data.

> "Our churn rate is 8.3% and our top 3 churning customers are Acme, Globex, and Initech. How do we fix this?"

Too specific. Real metrics and company names don't belong in public AI.

---

## Writing Code

**Scenario:** You ask AI to write, review, or debug code.

**What to watch for:**
- AI generates code that compiles but doesn't work correctly. Test everything end-to-end.
- AI invents package names, API methods, and configuration options that don't exist. Verify imports.
- AI-generated code frequently contains security vulnerabilities (SQL injection, hardcoded secrets, missing auth checks). Review before merging.
- Never paste API keys, database credentials, or connection strings into AI prompts.

**Example:**
> "Write a function that validates email addresses"

Fine. Review the output, test it, check edge cases.

> "Here's my database connection string: postgresql://admin:secret@prod-db:5432/main — write a migration"

Never do this. The credential is now on a remote server. Use a placeholder: `postgresql://user:password@host:5432/db`

---

## Producing Final Outputs

**Scenario:** The AI output will go to a customer, be published, submitted to a regulator, or used in a decision.

**What to watch for:**
- Maximum verification required. You own every word, number, and claim.
- AI-generated legal language may be wrong. AI-generated financial figures may be fabricated. AI-generated medical claims may be dangerous.
- Disclose AI involvement where required by regulation or company policy.
- Never let AI be the sole basis for a decision that affects people, money, or legal outcomes.

**Example:**
> Using AI to draft a blog post, then editing and fact-checking before publishing.

Good — AI assisted, human verified and finalized.

> Copying an AI-generated contract clause directly into a legal agreement without lawyer review.

Never acceptable. AI confidently produces legally incorrect language.

---

## Quick Reference

| What You're Doing | Risk Level | Key Action |
|-------------------|-----------|------------|
| Writing emails/docs | Low–Medium | Review before sending, don't paste sensitive context |
| Analyzing data | Medium | Anonymize inputs, verify all numbers |
| Brainstorming | Low | Don't overshare confidential context |
| Writing code | Medium–High | Test everything, review for security, verify imports exist |
| Final outputs | High | Maximum verification, disclose AI use, human owns the result |
