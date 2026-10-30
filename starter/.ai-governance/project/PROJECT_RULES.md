# [Project name]: project layer

Adds to Core and the organization layer; never relaxes them. Fill in the brackets and delete sections that do not
apply. Rules inside `<!-- EXAMPLE ... -->` blocks are inactive.

## What this project is

[One paragraph: what it does, who uses it, where it runs.]

## Stack and environments

| Item | Value |
|---|---|
| Languages and frameworks | [ ] |
| Data stores | [ ] |
| Environments | [local, test, production: names and URLs without credentials] |
| How to build and test | [commands] |
| Where secrets live | [secrets manager; never in the repository] |

## Active project rules

[None yet.]

<!-- EXAMPLE (inactive):
1. Run [test command] before calling any change done, and report what passed and what was not tested.
2. Never connect to production from a development machine; use [read-only replica] for investigation.
3. Database changes go through migrations in [folder]; never edit a schema by hand.
4. Follow the naming and folder conventions in [CONVENTIONS.md or link].
-->

## Definition of done

[What must be true before work is called done: tests, review, documentation, deployment.]

<!-- EXAMPLE (inactive):
- Builds and tests pass; the changed workflow was run end to end in [environment].
- A person reviewed the change.
- PROGRESS.md and TASKS.md are updated.
-->

## Forbidden in this project

[Project-specific things the AI must never do.]
