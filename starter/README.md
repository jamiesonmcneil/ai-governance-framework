# Starter kit: governance a team can use today

A copy-ready set of files that puts this framework in front of your AI tools in about ten minutes. Nothing here
needs a terminal except the Claude Code option. It works in four places:

| Where you use AI | What you set up | Enforcement |
|---|---|---|
| Claude Cowork (desktop app) | Paste `instructions/claude-project-instructions.md` into Cowork's Global instructions | The model reads them. Organizations on Team or Enterprise also control plugins, skills and connectors (`adapters/claude-cowork/`). |
| Claude Code (terminal, IDE, desktop) | `CLAUDE.md` and `.ai-governance/` in the repository | Rules load at every session start. Add the hook in `adapters/claude-code/` for harness-level checks. |
| Claude chat (claude.ai Projects) | Paste `instructions/claude-project-instructions.md` into the project's instructions | The model reads them. Nothing blocks a mistake. |
| Microsoft 365 Copilot | Paste `instructions/m365-copilot-instructions.md` where your Copilot accepts instructions | The model reads them. Real control is your admin's (see `adapters/microsoft-copilot/`). |

Instructions are guidance the model follows most of the time. They are not a control. Anything that must never
happen (sensitive data leaving the organization, an unapproved production change) also needs a control outside
the model: tool settings, admin policy, access rights, or a hook.

## What is in it

```
starter/
  CLAUDE.md.template                 Claude Code entry point; copy to CLAUDE.md (imports the layers below)
  CLAUDE.local.md.example            Your personal file: pick your role, add your own preferences
  .ai-governance/
    config.json                      Which layers apply, in which order
    org/ORG_RULES.md                 Organization layer: approved tools, data classes, contacts
    project/PROJECT_RULES.md         Project layer: stack, environments, definition of done
    roles/                           One file per role, rules commented out as examples
  instructions/
    claude-project-instructions.md   Paste-in text for Claude chat Projects
    m365-copilot-instructions.md     Paste-in text for Microsoft 365 Copilot
```

## How the role files work

Every role file has the same shape: what the role covers, an **Active rules** section that starts empty, and
a set of example rules inside `<!-- EXAMPLE ... -->` comment blocks.

- **Examples are inactive.** They show the kind of rule a team might adopt. The entry points tell the AI to
  ignore anything inside an EXAMPLE block, and Claude Code also strips block-level HTML comments from
  CLAUDE.md files before they reach the model.
- **To adopt an example,** copy the line into **Active rules** (edit it to fit) or write your own. Keep the
  example block as a reference or delete it.
- **Rules only add strictness.** A role rule can never relax a Core rule (`RULES.md`, `SELF_GOVERNANCE.md`,
  `PRODUCTION_SAFETY.md`, `CREDENTIAL_SECURITY.md`). If two rules conflict, the stricter one wins.
- **Get rules approved.** Whoever owns AI governance in your organization approves changes to the org and role
  files. Put them under version control so every change has a record.

Roles included: `developer`, `qa-tester`, `architect`, `security`, `it-operations`, `business-analyst`,
`project-manager`, `data-analyst`, `general-staff`. Copy `_TEMPLATE.md` for any other role.

## Ten-minute setup

### Claude Code

Run these from your repository root (macOS, Linux or Git Bash on Windows).

1. Add the framework as `.ai-governance/core/`:
   `git submodule add https://github.com/jamiesonmcneil/ai-governance-framework .ai-governance/core`
   (or copy the framework's files there if your organization does not allow outside submodules).
2. Copy the starter into place:
   `cp .ai-governance/core/starter/CLAUDE.md.template CLAUDE.md`
   `cp .ai-governance/core/starter/CLAUDE.local.md.example .`
   `cp -R .ai-governance/core/starter/.ai-governance/. .ai-governance/`
   `printf 'CLAUDE.local.md\n' >> .gitignore`
3. Fill in the bracketed fields in `.ai-governance/org/ORG_RULES.md` and `.ai-governance/project/PROJECT_RULES.md`.
   Delete what does not apply. Commit.
4. Each person copies `CLAUDE.local.md.example` to `CLAUDE.local.md` and adds the one import line for their role
   (the file shows how). `CLAUDE.local.md` stays out of git.
5. Start Claude Code. The first reply shows the governance block listing Core, org, project, role and user; reply
   YES if it is right. If a layer is missing, check the import paths (`/memory` lists what loaded).
6. Optional, stronger: install the SessionStart hook in `adapters/claude-code/`. It reminds the model to run the
   protocol at every start; it lists the core, org, project and user layers, and the role arrives through
   `CLAUDE.local.md`.

The starter's entry point is named `CLAUDE.md.template` inside the framework so that Claude Code does not load
it from `.ai-governance/core/starter/` as a nested CLAUDE.md.

If everyone in a repository works in one role (a service repository with only developers, say), import that
role directly in `CLAUDE.md` instead of per person.

### Claude Cowork (desktop app, no terminal)

1. Use the Claude desktop app signed in with the account type your organization approved for work data.
2. Open Settings > Cowork and edit Global instructions (newer layouts: Settings > "Instructions for Claude").
   Paste the text from `instructions/claude-project-instructions.md` and fill in the brackets.
3. Paste your role's **Active rules** under "My role". Use folder or Project instructions for rules that apply to
   one folder or project only.
4. Ask Cowork "What rules are you following for my work?" to check they took. Details:
   `adapters/claude-cowork/README.md`.

### Claude chat (Projects)

1. Use a Claude account type your organization approved for work data (`AI_ENVIRONMENTS.md`). Turn off model
   training in your settings if your plan allows it (`USER_SETUP.md` has the checklist).
2. Create a Project, open its instructions, and paste the text from `instructions/claude-project-instructions.md`.
3. Paste your role's **Active rules** under "My role" at the end. Upload no files with credentials or data your
   organization classifies above what that account is approved for.

### Microsoft 365 Copilot

1. Use Copilot signed in with your work account. A personal Microsoft account is a different product with
   different data terms; see `adapters/microsoft-copilot/canonical-reference-table.md`.
2. In the Microsoft 365 Copilot app (desktop or web): Copilot Chat > "..." > Chat settings > Personalization >
   Custom instructions. Paste the text from `instructions/m365-copilot-instructions.md` and your role's active
   rules. For a team, build one agent with the same text as its instructions and share it. If your
   organization has turned these off, keep the rules in a document you reread; the admin controls in
   `adapters/microsoft-copilot/` do the enforcing.
3. Admins: the DLP, sensitivity label and audit templates in `adapters/microsoft-copilot/` are where the hard
   controls are.

## What this kit does not do

- It does not decide which tools or data your organization allows. `org/ORG_RULES.md` has blanks for that,
  and someone accountable fills them in.
- It does not enforce anything by itself outside Claude Code's loading of the files. See the table above.
- It is not legal or compliance advice. `COMPLIANCE.md` maps the framework to common standards.
