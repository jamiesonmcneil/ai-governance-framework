# Production Safety Protocol

**Production environments require explicit, intentional confirmation before any modification.**

## Standards Alignment
- NIST AI RMF: Manage function — risk mitigation controls
- ISO 42001: A.8 — Use of AI Systems (controlled usage)
- OWASP LLM06: Excessive Agency — principle of least privilege
- SOC 2: Processing Integrity, Security

## Human Responsibility

This protocol reduces risk but does not eliminate it. The human operator is always responsible for confirming correctness, understanding impact, and verifying outcomes. An AI tool following this protocol correctly does not absolve the human of responsibility for the result.

---

## The Confirmation Protocol

Standard tool-approval prompts (click "Allow", press Enter, type "y") are insufficient for production operations. Users develop muscle memory and approve dangerous operations reflexively.

### Required Sequence

**Step 1:** State the environment explicitly
```
WARNING: This operation targets PRODUCTION [system name].
```

**Step 2:** List exactly what will change
```
Changes:
- INSERT 5 rows into billing..payment_config
- UPDATE orders..settings SET helcim_enabled = 1
```

**Step 3:** Ask for typed confirmation
```
To proceed, type: CONFIRM PRODUCTION
Any other response will cancel this operation.
```

**Step 4:** Validate the response
- "CONFIRM PRODUCTION" (exact match, case-insensitive) → proceed
- Anything else ("yes", "ok", "do it", "1", "y", Enter) → do NOT proceed, re-explain and re-ask

### Operations Requiring This Protocol

| Category | Examples |
|----------|----------|
| **Database writes** | INSERT, UPDATE, DELETE, ALTER, DROP on production databases |
| **Code deployment** | git push to main/master, rsync to production servers, PM2 restart |
| **Configuration changes** | .env modifications on production, DNS changes, firewall rules |
| **Infrastructure** | Server restarts, certificate changes, load balancer config |
| **Data migration** | Schema changes, data transforms, bulk updates |
| **Irreversible operations** | Hard deletes, branch deletion, credential rotation |

### Operations NOT Requiring This Protocol

| Category | Examples |
|----------|----------|
| **Read operations** | SELECT queries, log viewing, status checks |
| **Local development** | All operations on localhost, dev environments |
| **Staging/QA** | Operations on non-production environments |
| **Documentation** | Updating docs, README files, comments |

---

## Environment Classification

Every system must be classified:

| Environment | Risk Level | Confirmation Required |
|-------------|-----------|----------------------|
| **Production** | CRITICAL | CONFIRM PRODUCTION protocol |
| **Staging/UAT** | HIGH | Standard confirmation ("proceed? y/n") |
| **Development** | MEDIUM | Minimal confirmation |
| **Local** | LOW | No confirmation needed |

---

## Read-Only Default

When interacting with any production system, the default posture is **READ-ONLY**.

**Allowed without confirmation:**
- SELECT queries
- GET API calls
- Viewing logs, configs, status
- Reading file contents

**Forbidden without explicit instruction + CONFIRM PRODUCTION:**
- INSERT, UPDATE, DELETE queries
- POST, PUT, PATCH, DELETE API calls
- Writing/modifying files
- Restarting services
- Changing configurations

---

## Rollback Planning

Before any production modification, document:

1. **What will change** — specific tables, files, configs
2. **How to verify success** — what to check after the change
3. **How to rollback** — exact steps to undo if something goes wrong
4. **Who to contact** — escalation path if rollback fails

---

## Deployment Safety

### Pre-Deployment Checklist
- [ ] Code builds successfully **locally** (never rely on building on the production server — resource-constrained servers OOM during builds)
- [ ] All tests pass
- [ ] Changes reviewed (diff examined)
- [ ] No localhost URLs in production build artifacts (`grep -c "localhost" dist/` or `.next/static/`)
- [ ] All required environment variables set **at build time** (especially `NEXT_PUBLIC_*` or framework equivalents)
- [ ] Rollback plan documented
- [ ] CONFIRM PRODUCTION received
- [ ] Disk space verified on target server (`df -h /` — builds and deploys need free space)

### Deployment Rules
- Never deploy on Fridays (unless emergency)
- Never deploy during business hours without stakeholder awareness
- Always verify the deployment succeeded (health check, smoke test)
- Keep the previous version available for immediate rollback
- Never skip pre-commit hooks (--no-verify) — fix the underlying issue
- Never overwrite `.env` or infrastructure config files during deployment — exclude them from sync/copy
- Restart services one at a time with delays (not `pm2 restart all`) — cascading restarts on resource-constrained servers cause OOM
- After restart, verify the service is actually listening (not just "online" in process manager — ENOSPC and port conflicts can make services appear running but non-functional)

### Post-Deployment Verification
- [ ] All services responding (health check endpoints)
- [ ] Service actually listening on expected port (not just process manager status)
- [ ] Login flow works end-to-end
- [ ] Key data queries return results (not empty or error)
- [ ] No new errors in application logs
- [ ] No "local network access" browser prompts (indicates localhost in JS bundle)
