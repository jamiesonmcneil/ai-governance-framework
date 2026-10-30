# Claude Cowork Adapter

**Tier B (context instructions), with organization controls on Team and Enterprise plans.**

Last Reviewed: 2026-10-30 | Next Review Due: 2027-01-30

Cowork is the agent mode in the Claude desktop app (macOS and Windows; Linux in beta). It works on folders you
connect, can use connectors and a browser, and runs code in an isolated cloud environment. Most people who use
it never open a terminal, so this adapter uses the app's own settings, not files and hooks.

Sources (checked 2026-10-30): support.claude.com articles 13345190 (using Cowork), 13455879 (Team and
Enterprise), 13837433 (organization plugins); academy.claude.com "Customize Claude Cowork". Settings move
between releases; if a path below has changed, look for the same name in Settings.

---

## Where governance goes

| Place | What to put there | Applies to |
|---|---|---|
| **Global instructions** (Settings > Cowork, "Edit" next to Global instructions; newer layouts: Settings > "Instructions for Claude") | The text from `starter/instructions/claude-project-instructions.md`, with your role's active rules at the end | Every Cowork session for that person |
| **Folder instructions** (set when you select a local folder) | Rules that apply only to that folder's work (a client, a project, a data class) | Sessions on that folder |
| **Project instructions** (the Project's right panel, Instructions) | Project rules, layered on top of the global instructions | That Project |
| **Organization plugins and skills** (Team and Enterprise owners: Organization settings > Plugins & skills) | A shared plugin or skill that holds the organization's procedures; can be set as Required | Every member |

Rules go in instructions; a repeatable procedure goes in a skill. A skill loads only when Claude judges it
relevant, so never rely on a skill alone for a rule that must always apply.

A `CLAUDE.md` file in a connected folder is not a documented Cowork setting. Do not rely on it for Cowork; use
the instructions above. (Claude Code's own documentation does describe some import handling in Cowork
sessions, so a folder prepared for Claude Code with `starter/` may also help, but treat that as a bonus.)

---

## Setup for a person (five minutes)

1. Sign in to the Claude desktop app with the account type your organization approved for work data
   (`AI_ENVIRONMENTS.md`). Check the model-training setting under Privacy (`USER_SETUP.md`).
2. Copy the text below the line in `starter/instructions/claude-project-instructions.md` into Global
   instructions. Replace the bracketed fields.
3. Open your role file in `starter/.ai-governance/roles/`, copy the rules your team adopted from its
   **Active rules** section, and paste them under "My role".
4. Connect only the folders the task needs. Keep folders holding credentials or data above your approved class
   out of Cowork.
5. Start a session and ask: "What rules are you following for my work?" The answer should repeat the data,
   accuracy and approval rules. If it does not, check the Global instructions saved.

## Setup for an organization (owners and admins)

1. Decide whether Cowork is on, and whether cloud runs, the built-in browser, and connector auto-approval are
   allowed (Team and Enterprise settings, article 13455879).
2. Require per-task approval for connector tools that can write, where your plan offers it.
3. Publish the organization's procedures as a Required plugin or organization skills; turn off member-created
   skills if your policy needs it.
4. Give staff the paste-in text with your organization's fields filled in, so everyone starts from the same
   wording. Instructions are per person: there is no documented way to push them to every member.

## What this does not enforce

- Instructions are followed most of the time, not always. Data protection comes from the account type,
  connected folders, connector settings and your organization's controls, not from the instructions.
- Permission modes (Manual, Auto, Skip) decide how much Cowork does without asking. For work that can change
  shared data or live systems, use Manual. Permanent deletion always asks.
- The user check in `USER_VERIFICATION.md` still applies: if an answer ignores a rule, stop and correct it
  before going on.
