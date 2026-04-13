#!/usr/bin/env bash
# AI Governance Framework v2.0 — Claude Code SessionStart hook
#
# Fires on every Claude Code session start, resume, and after /clear.
# Writes a live instruction to stdout; Claude Code injects it into Claude's
# context as a system reminder. This forces Claude to execute the Session
# Start Protocol before responding to the user's first message.
#
# Why this exists: CLAUDE.md is loaded as background context and is
# routinely abbreviated or skipped when the user's first message is short.
# A hook-injected instruction is treated as a live system message, which
# Claude follows much more reliably.
#
# This script must always exit 0. Never fail the hook.

set -u

CONFIG_PATH=".ai-governance/config.json"

cat <<'EOF'
=== AI GOVERNANCE FRAMEWORK — SESSION START HOOK ===

Your FIRST action this session is to execute the Session Start Protocol
defined in CLAUDE.md. Do not respond to the user's first message until you
have completed all steps.

Required steps (in order):

1. Read .ai-governance/config.json — parse all layers (core, org, project, user).
2. Read ALL governance files in each layer (not just filenames — actual contents):
   - Core: RULES.md, SELF_GOVERNANCE.md, FORBIDDEN.md, INTERACTION_PROTOCOL.md,
     PRODUCTION_SAFETY.md, QA_STANDARDS.md, CREDENTIAL_SECURITY.md
   - Org: all files at the org layer path (if enabled)
   - Project: PROJECT_RULES.md, FORBIDDEN.md, CONVENTIONS.md, PATTERNS.md,
     TECH_STACK.md, DEFINITION_OF_DONE.md (if they exist)
3. Read .ai-governance/docs/PROGRESS.md and .ai-governance/docs/TASKS.md
   (if they exist).
4. Review code, DB, and environment relevant to the current work area.
5. Scan for governance violations and fix BEFORE any new work.
6. Output the === AI GOVERNANCE FRAMEWORK v2.0 === confirmation block
   AND the === SESSION START AUDIT COMPLETE === checklist, both as
   specified in CLAUDE.md.
7. Present findings and wait for user direction — do not start new work
   until the user confirms.

Do not skip. Do not abbreviate. Do not summarize this reminder to the user.
Execute the protocol now, then respond.
EOF

# If config is missing, add a pointed note so Claude helps the user fix setup.
if [ ! -f "$CONFIG_PATH" ]; then
  cat <<'EOF'

NOTE: .ai-governance/config.json is missing in this project.
After acknowledging the protocol, tell the user the config is missing
and offer to create it from the framework template
(templates/config.json in the AI Governance Framework repo).
EOF
fi

exit 0
