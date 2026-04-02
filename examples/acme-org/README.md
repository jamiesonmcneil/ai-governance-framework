# acme-org AI Governance Layer

This is the official **Org layer** example for Acme Organization.

It sits between the immutable **Core** (this framework repo) and individual **Project** layers.

## Purpose
- Enforce company-wide AI usage, security, and compliance policies
- Strengthen (never weaken) the immutable Core rules
- Provide consistent conventions across all teams and projects

## How to Use This Org Layer

1. Clone or reference this repository:
   ```bash
   git clone https://github.com/acme/acme-org-ai-governance.git
   ```

2. In every project, update `.ai-governance/config.json`:
   ```json
   {
     "schema_version": "2.0",
     "layers": {
       "core": {
         "path": "/path/to/ai-governance-framework",
         "immutable": true
       },
       "org": {
         "path": "/path/to/acme-org-ai-governance",
         "description": "Acme Organization company-wide policies"
       },
       "project": {
         "path": ".ai-governance/project"
       },
       "user": {
         "path": "~/.ai-governance/user",
         "gitignored": true
       }
     }
   }
   ```

3. Optional convenience symlinks (in `.ai-governance/`):
   ```bash
   ln -s /path/to/ai-governance-framework core
   ln -s /path/to/acme-org-ai-governance org
   ```

The Session Start Protocol will automatically load and display all active layers with their exact paths.

## Files in This Org Layer

- `RULES.md` – Company-specific rules (additive only)
- `FORBIDDEN.md` – Additional prohibitions
- `PRODUCTION_SAFETY.md` – Org-level production confirmation requirements
- `COMPLIANCE.md` – Acme-specific compliance mappings
- `CONVENTIONS.md` – Coding and AI interaction conventions
- `TECH_STACK.md` – Approved tools and versions

All files are additive. They can only make rules stricter than the Core.
