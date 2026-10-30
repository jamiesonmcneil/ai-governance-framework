# Role: IT / operations

Covers: infrastructure, networking, servers, cloud, endpoints, scripts and runbooks with AI assistance.

Adds to Core, the organization layer and the project layer; never relaxes them. Rules inside
`<!-- EXAMPLE ... -->` blocks are inactive examples: copy one into **Active rules** (and edit it to fit) to adopt
it. Approved by: [governance owner], [date].

## Active rules

[None yet. Add the rules your team adopts here, one per line.]

## Never without a person's approval

[List actions this role's AI use must stop and ask about. Core already requires CONFIRM PRODUCTION for
production changes.]

<!-- EXAMPLE (inactive): rules an operations team might adopt
- Never paste device configurations, firewall rules, network diagrams or IP plans into a tool not approved for that data; redact secrets and internal addressing first.
- AI-written scripts and commands are read line by line, and run first in a test environment or with a dry-run option.
- Any change to a production system follows CONFIRM PRODUCTION and the change process ([change system]), with a rollback plan written before the change.
- Never give an AI tool standing credentials to production; give it the least access the task needs, for the time it needs it.
- Runbooks drafted with AI are tested step by step before they are published.
-->
