# [Organization name]: AI governance, organization layer

Owner: [role or team accountable for AI governance]. Approved: [date]. Review: [at least yearly].

These rules add to Core and never relax it. Fill in every bracketed field; until a field is filled, the AI asks
the user instead of assuming. Rules inside `<!-- EXAMPLE ... -->` blocks are inactive.

## 1. Approved AI tools and accounts

Only these tools and account types may be used for work. Anything not listed is not approved for work data.

| Tool | Account type | Approved for data up to | Notes |
|---|---|---|---|
| [Tool] | [work account, enterprise plan, ...] | [Public / Internal / Confidential / Restricted] | [training off, retention, ...] |

<!-- EXAMPLE (inactive):
| Microsoft 365 Copilot | Work account (Entra) | Confidential | Admin DLP and sensitivity labels on |
| Claude (Team or Enterprise plan) | Work account | Internal | No customer personal data |
| Claude Code | Work account, commercial terms | Internal source code | No secrets, no production data |
| Any tool on a personal account | Personal | Public only | Never work data |
-->

## 2. Data classes

| Class | Examples in this organization | May go into |
|---|---|---|
| Public | [published material] | Any approved tool |
| Internal | [internal docs, most source code] | [tools] |
| Confidential | [customer data, contracts, financials] | [tools, or none] |
| Restricted | [credentials, regulated data, legal privilege] | Never into an AI tool |

When unsure which class applies, treat it as the stricter one and ask [contact].

## 3. Active organization rules

[None yet. Add rules here once approved.]

<!-- EXAMPLE (inactive):
1. Credentials, keys and passwords never go into any AI tool, file, chat or ticket. They live in [secrets manager].
2. Customer names, contact details and account data go only into tools approved for Confidential data.
3. Anything AI-drafted that leaves the organization (email, proposal, public post) is read in full and sent by
   a person, never sent by the AI.
4. AI output is never the only basis for a decision about a person (hiring, performance, discipline).
5. Production changes follow the CONFIRM PRODUCTION protocol plus [approver] sign-off.
6. AI-written code is reviewed by a person before it merges.
7. Meeting recordings and transcripts go into AI tools only with the participants' knowledge and an approved tool.
8. Report a suspected data exposure to [contact] the same day, using Core's Incident Response steps.
-->

## 4. Contacts

| Need | Contact |
|---|---|
| Is this tool or data allowed? | [team or role] |
| Suspected data exposure or leaked credential | [security contact] |
| Changing these rules | [governance owner] |

## 5. Production

Production environments: [list, or "none"]. Confirmation phrase: `CONFIRM PRODUCTION` (Core). Additional
approver: [role or "none"].
