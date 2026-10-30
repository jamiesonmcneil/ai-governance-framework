# Role: Security

Covers: security review, threat modeling, incident handling and security tooling with AI assistance.

Adds to Core, the organization layer and the project layer; never relaxes them. Rules inside
`<!-- EXAMPLE ... -->` blocks are inactive examples: copy one into **Active rules** (and edit it to fit) to adopt
it. Approved by: [governance owner], [date].

## Active rules

[None yet. Add the rules your team adopts here, one per line.]

## Never without a person's approval

[List actions this role's AI use must stop and ask about. Core already requires CONFIRM PRODUCTION for
production changes.]

<!-- EXAMPLE (inactive): rules a security team might adopt
- Never paste live credentials, keys, tokens, details of unpatched vulnerabilities or incident evidence containing personal data into an AI tool not approved for Restricted data.
- Logs, alerts and samples are redacted (hosts, IPs, usernames, personal data) before analysis in an AI tool.
- AI-suggested findings are confirmed against the system before they are reported.
- AI-generated detection rules, scripts and configurations are tested in a non-production environment first.
- Testing tools are used only within an authorized scope, written down before the work starts.
-->
