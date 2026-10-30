# Role: Developer

Covers: writing, changing and reviewing code, tests, scripts and build configuration with AI assistance.

Adds to Core, the organization layer and the project layer; never relaxes them. Rules inside
`<!-- EXAMPLE ... -->` blocks are inactive examples: copy one into **Active rules** (and edit it to fit) to adopt
it. Approved by: [governance owner], [date].

## Active rules

[None yet. Add the rules your team adopts here, one per line.]

## Never without a person's approval

[List actions this role's AI use must stop and ask about. Core already requires CONFIRM PRODUCTION for
production changes.]

<!-- EXAMPLE (inactive): rules a development team might adopt
- Read the code being changed, and search for an existing helper or pattern, before writing new code.
- Never invent an API, package, function, configuration key, table or column; check the source, the schema or the docs, or run it.
- Every changed behavior gets a test. A bug fix starts with a test that reproduces the bug.
- Never weaken, skip or delete a test to make a build pass. If a test changes because the intended behavior changed, say so.
- After two failed attempts at the same fix, stop and report what was tried and the failure output.
- Use parameterized queries, validate input at trust boundaries, and check authorization on every protected resource.
- Configuration (URLs, hosts, IDs, defaults) comes from configuration, defined once, and fails loudly when missing.
- Report exactly what was run, where, on what data, and which relevant cases were not exercised. "Compiles" is not "works".
- A person reviews AI-written code before it merges. New dependencies are checked for existence, maintenance and license before they are added.
- Never point development or test code at production data or systems.
-->
