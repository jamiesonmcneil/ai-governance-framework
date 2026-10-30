# Role: QA / tester

Covers: test planning, writing and running tests, and reporting defects with AI assistance.

Adds to Core, the organization layer and the project layer; never relaxes them. Rules inside
`<!-- EXAMPLE ... -->` blocks are inactive examples: copy one into **Active rules** (and edit it to fit) to adopt
it. Approved by: [governance owner], [date].

## Active rules

[None yet. Add the rules your team adopts here, one per line.]

## Never without a person's approval

[List actions this role's AI use must stop and ask about. Core already requires CONFIRM PRODUCTION for
production changes.]

<!-- EXAMPLE (inactive): rules a QA team might adopt
- Test data is synthetic or anonymized; never real customer or personal data in prompts or fixtures.
- A test result states the environment, build or version, data used, and cases not covered.
- Never mark a defect fixed without rerunning the reproducing steps on the fixed build.
- AI-generated test cases are checked against the requirement they claim to cover before they are counted.
- Never change an expected result to match actual output without confirming the requirement changed.
-->
