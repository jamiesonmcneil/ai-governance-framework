# AI Self-Governance Guide

**For everyone who uses AI tools — developers, managers, HR, legal, finance, marketing, or anyone typing into a chat box.**

Last Reviewed: 2026-03-24 | Next Review Due: 2026-06-24 (90-day cycle — AI platform policies change frequently)

## Purpose

This document defines the core safety boundary for all AI usage. If you read only one file in this framework, read this one.

---

## The One Rule That Matters

**Assume anything you enter into an AI tool may be seen or accessed beyond your control.**

Even if a platform says "we don't train on your data," your input is still transmitted to remote servers, processed by third parties, and potentially logged. Treat AI prompts the same way you'd treat an email — don't include anything you wouldn't want forwarded.

This is a general safety posture. Approved environments may provide stronger guarantees depending on their configuration and agreements.

### Supporting Principles

- **AI output can be wrong, even when it looks correct.** AI tools fabricate facts, invent APIs, hallucinate references, and generate plausible but incorrect code, legal clauses, financial calculations, and medical claims. Verification is not optional.
- **You are responsible for all decisions made using AI.** The AI is an assistant, not an authority. If you act on its output without checking, the consequences are yours.

---

## When AI Goes Wrong (Common Misuse)

AI is most dangerous when it is:
- **Trusted without verification** — it produces confident, well-formatted, completely wrong answers
- **Used for decisions instead of support** — it should inform your thinking, not replace it
- **Given real data when examples would suffice** — you exposed real information for no benefit

Use AI as:
- A drafting tool (you own and review the output)
- A thinking partner (not a decision-maker)
- A search accelerator (but verify what it finds)

Never:
- Treat output as authoritative
- Skip verification because it "looks right"
- Assume code works because it compiles
- Assume an AI is safe because it runs internally — self-hosted reduces some risks but does not eliminate incorrect outputs, data misuse, or governance requirements

---

## What You Must NEVER Put Into Public or Unapproved AI Tools

The following must NEVER be entered into public AI tools (ChatGPT free, Claude free, Gemini free, or any tool without an approved enterprise agreement):

| Category | Examples | Why |
|----------|----------|-----|
| **Passwords & secrets** | API keys, tokens, SSH keys, database credentials | Even "no-training" platforms transmit and process your input on remote servers |
| **Customer PII** | Names + addresses, emails, phone numbers, account numbers | Privacy law violations (PIPEDA, GDPR). Once sent, you cannot guarantee deletion |
| **Financial data** | Credit card numbers, bank accounts, salary information | Regulatory and liability risk (SOX, securities regulations) |
| **Health information** | Medical records, diagnoses, insurance details | Subject to additional privacy protections (HIPAA, provincial health privacy acts) |
| **Legal/privileged content** | Attorney-client communications, NDA content, board materials | Privilege may be waived by disclosure to a third party |
| **Proprietary algorithms** | Core business logic, trade secrets, competitive advantages | IP exposure. Even with no-training guarantees, your data is on someone else's server |

**This applies to ALL input methods** — typed text, file uploads (PDFs, spreadsheets, images), voice input, and data accessed through plugins/integrations.

Sensitive data may be processed in approved enterprise or self-hosted AI environments under organizational policy. See `AI_ENVIRONMENTS.md` for environment classification and the layered processing pattern.

**If unsure whether something is safe to share, assume it is NOT and do not include it.**

**Safe alternatives:**
- Use placeholder data: `API_KEY_HERE`, `John Doe`, `123 Main St`
- Describe the pattern: "I have a function that calculates X based on Y" instead of pasting actual code
- Use anonymized examples: change names, companies, amounts
- For data analysis: aggregate or anonymize before uploading (remove names, use category labels)

---

## Know Your Plan — Training Policies by Platform (March 2026)

### Does Your AI Train on Your Input?

| Platform | Free / Personal | Team / Business | Enterprise | API |
|----------|----------------|-----------------|------------|-----|
| **Claude** (Anthropic) | YES by default — opt out via Settings > Privacy > "Help improve Claude" | NO (Work plans) | NO | NO |
| **ChatGPT** (OpenAI) | YES — opt out via Settings > Data Controls > "Improve the model for everyone" | NO | NO | NO |
| **Gemini** (Google) | YES — opt out via Gemini app Activity panel or myactivity.google.com | NO (Workspace) | NO (Vertex AI) | Depends* |
| **GitHub Copilot** | — | NO | NO | — |
| **Microsoft Copilot** | YES (consumer) | — | NO (M365) | — |
| **Cursor** | May store (privacy mode off) | Privacy mode available | NO | Via provider |
| **Windsurf** | Telemetry collected | NO | NO | — |
| **Perplexity AI** | YES (free tier) | NO (Pro) | — | — |
| **Grok** (xAI) | Check current policy — integrated into X/Twitter | — | — | NO |
| **Meta AI** | YES — integrated into WhatsApp, Instagram, Facebook | — | — | — |

*Google AI Studio free API may train; paid Vertex AI does not.

**Important nuances:**
- **Claude Free/Pro/Max:** Anthropic reversed its policy in September 2025. Training is now **on by default — you MUST disable it** via Settings > Privacy > "Help improve Claude." If left enabled, Anthropic may retain your conversations for up to 5 years for model training. Even with opt-out, safety-flagged conversations may still be reviewed.
- **ChatGPT:** If you give thumbs-up/down feedback, the **entire conversation** may be used for training regardless of your opt-out setting. Use Temporary Chat mode for sensitive one-off queries.
- **Gemini in Workspace:** Has different privacy terms than standalone Gemini. The boundary between "using Gemini" and "Google applying Gemini to your email" is increasingly blurred.

**Rules:**
1. **Disable training on EVERY AI tool you use.** If the platform offers an opt-out setting, turn it off immediately — regardless of what plan you're on or what you use it for. There is no reason to let any AI provider train on your input. See the Opt-Out Checklist below.
2. **For any work involving company code, customer data, or proprietary information — use a Team, Business, or Enterprise plan.** Free tiers train by default and may not honor opt-out in all cases. Never use free tiers for confidential work.

---

## Opt-Out Checklist — Do This NOW

If you use free or personal plans for anything work-related, opt out of training immediately:

### Claude (claude.ai)
- [ ] Go to `claude.ai/settings`
- [ ] Under Privacy Settings, turn OFF **"Help improve Claude"**
- [ ] Note: Even with opt-out, Anthropic retains conversations for 30 days for safety review

### ChatGPT (chatgpt.com)
- [ ] Go to Profile > Settings > Data Controls
- [ ] Turn OFF **"Improve the model for everyone"**
- [ ] For sensitive queries, use **Temporary Chat** mode (not saved, not trained on)
- [ ] Avoid giving thumbs feedback on conversations containing sensitive data

### Gemini (gemini.google.com)
- [ ] Open the Gemini app > Activity panel (or `myactivity.google.com/product/gemini`)
- [ ] Turn OFF **"Gemini Apps Activity"**
- [ ] Note: This also disables conversation history

### GitHub Copilot
- [ ] Go to `github.com/settings/copilot`
- [ ] Uncheck "Allow GitHub to use my code snippets for product improvements"

### Cursor
- [ ] Settings > General > enable **Privacy Mode**

### Microsoft Copilot
- [ ] Consumer: Check privacy settings at `copilot.microsoft.com` > Settings
- [ ] M365 Enterprise: No action needed — enterprise tier does not train

---

## Role-Specific Risks

### For Developers (using AI coding tools)
- **Code security:** AI-generated code frequently contains SQL injection, XSS, hardcoded secrets, and insecure patterns. Treat all AI code as untrusted — review before merge.
- **Dependency hallucination:** AI invents package names, API methods, and configuration options that don't exist. Verify imports and dependencies.
- **License contamination:** AI may reproduce copyrighted code from its training data. Be cautious with large code blocks that seem too perfect.
- See `RULES.md` and `QA_STANDARDS.md` for the full development governance.

### For HR / People Operations
- **Resume screening:** Never paste full resumes into AI tools — this discloses candidate PII and may create bias/discrimination liability.
- **Performance reviews:** AI-drafted reviews based on employee data are a PII disclosure. Use anonymized descriptions.
- **Job postings:** AI may generate biased or legally problematic language. Review against employment law requirements.

### For Legal
- **Privilege risk:** Using AI to draft legal documents may waive attorney-client privilege depending on jurisdiction. Several bar associations have issued specific guidance.
- **Accuracy:** AI confidently generates plausible but legally incorrect clauses. Every AI-drafted legal document must be reviewed by a qualified lawyer.
- **NDA/contract content:** Never paste contract text, negotiation positions, or deal terms into AI.

### For Finance
- **Regulatory risk:** AI-assisted financial reporting may trigger SOX compliance questions. Document AI involvement in any financial analysis.
- **Insider information:** Non-public financial data entered into AI tools creates insider trading risk.
- **Calculation errors:** AI makes convincing but wrong mathematical assertions. Verify all calculations independently.

### For Marketing
- **Trademark/copyright:** AI may generate content that infringes existing trademarks or reproduces copyrighted material.
- **FTC compliance:** AI-generated product claims must comply with advertising standards. The AI doesn't know what claims are substantiated.
- **Brand voice:** AI produces generic content. Review for brand consistency before publishing.

### For Managers / Executives
- **Company data:** A spreadsheet with client names is customer data, even if you think of it as "your team's sales numbers."
- **File uploads:** PDFs, spreadsheets, and images uploaded to AI tools are processed on remote servers — same risks as typed text.
- **AI plugins/integrations:** ChatGPT plugins, Claude MCP integrations, and Gemini extensions can access calendar, email, and files. Understand what you're granting access to.

---

## AI-Generated Content Disclosure

**When must you disclose that content was AI-generated?**

| Context | Disclosure Required? | Authority |
|---------|---------------------|-----------|
| EU-published content | YES — AI-generated content must be labeled | EU AI Act Article 50 |
| Professional writing (some jurisdictions) | Check local rules | Various professional bodies |
| Academic/educational submissions | YES (in most institutions) | Institutional policies |
| Legal filings | YES (in most jurisdictions) | Court rules, bar associations |
| Internal business use | Follow your organization's policy | Internal governance |
| Personal/creative use | Generally no, but ethical best practice to disclose | N/A |

**When in doubt, disclose.** It's easier to explain "I used AI to help draft this" than to explain why you didn't mention it.

---

## When to Use Which Tool

| Scenario | Recommended Tool | Tier |
|----------|-----------------|------|
| Writing code at work | Claude Code, Copilot, Cursor | API / Business / Enterprise |
| Quick personal question | Any chat interface | Free (with opt-out) |
| Analyzing company documents | Claude Team/Enterprise or ChatGPT Team | Team+ only |
| Customer data analysis | **None** — use internal/self-hosted tools only | Never external AI |
| Drafting emails with internal info | Claude Team or M365 Copilot Enterprise | Team+ only |
| Resume screening or HR analysis | **None** or fully anonymized data only | Internal tools preferred |
| Legal document drafting | Claude Team/Enterprise with lawyer review | Team+ only, always reviewed |
| Financial analysis | Anonymized/aggregated data only | Team+ only, verify calculations |
| Marketing copy | Any (no customer data involved) | Free is fine |
| Learning / tutorials | Any | Free is fine (no sensitive data) |

---

## Incident Response

**If you accidentally sent sensitive data to an AI tool:**

1. **Stop immediately** — close the conversation, do not continue
2. **Document what was sent** — note the platform, what data, and when
3. **Report to your security/privacy team** — this is a data disclosure incident
4. **Delete the conversation** if the platform allows it (this may not remove it from training pipelines or server logs)
5. **Rotate any credentials** that were exposed — API keys, passwords, tokens
6. **Assess the risk** — was it PII? Credentials? Proprietary IP? Each has different remediation paths

**Do not assume it's fine because you "deleted the chat."** Platform log retention, training pipeline ingestion, and safety review processes may have already captured your data.

---

## Shadow AI

Work data must not be processed through:

- Personal AI accounts (free tiers of ChatGPT, Claude, Gemini, etc.)
- Unapproved browser extensions or AI-powered add-ons
- Private API keys not managed by the organization
- Unreviewed third-party tools or AI wrappers

Organizational work must use only approved tools and accounts. If approved tooling is insufficient, request access to additional tools — do not work around governance.

---

## Human Decision Authority

AI may assist analysis, drafting, and summarization, but sensitive business, legal, financial, or people decisions must remain under accountable human review.

AI output must not be used as the sole basis for high-impact decisions.

---

## Quick Reference Card (The 5-Second Version)

1. **Never paste secrets, PII, or proprietary data** into any AI tool
2. **Use Team/Enterprise plans** for company work — free tiers train by default
3. **Opt out of training** on every platform you use — do it today
4. **Verify everything AI generates** — it lies confidently
5. **Report incidents immediately** — accidental disclosure is a security event
6. **Disclose AI involvement** when required by regulation or policy
