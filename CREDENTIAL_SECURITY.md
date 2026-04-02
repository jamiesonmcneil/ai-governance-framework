# Credential Security Protocol

**Context-aware credential storage, handling, rotation, and incident response.**

---

## Storage Decision Tree

The storage method is configured per-project in `.ai-governance/config.json` (`credential_storage` field).

```
1. Is a PostgreSQL (or other) database available?
   YES -> Use encrypted database table (see DDL below)
          Encryption key in .env file (never in DB)
          Set .ai-governance/config.json: "credential_storage": "postgres"

2. Is a secrets manager available (AWS SM, Azure KV, HashiCorp Vault)?
   YES -> Use secrets manager
          Access credentials in .env
          Set .ai-governance/config.json: "credential_storage": "secrets_manager"

3. Neither available:
   -> Use encrypted file storage
      Credentials in .env.local (gitignored, chmod 600)
      Encryption key in separate .env or system env var
      Set .ai-governance/config.json: "credential_storage": "file"

ALL METHODS:
- Encryption key and encrypted data NEVER in the same location
- .env files NEVER committed to version control
- chmod 600 on all credential files
```

---

## Database Credential Store DDL

When using `"credential_storage": "postgres"`, create this schema:

```sql
-- Schema for credential management
CREATE SCHEMA IF NOT EXISTS auth;

-- Central credential store
CREATE TABLE IF NOT EXISTS auth.system_credentials (
    id BIGSERIAL PRIMARY KEY,
    uuid UUID NOT NULL DEFAULT gen_random_uuid() UNIQUE,

    -- What this credential is for
    system_name VARCHAR(100) NOT NULL,          -- e.g., 'aws', 'stripe', 'smtp', 'xai'
    credential_key VARCHAR(100) NOT NULL,       -- e.g., 'api_key', 'client_secret', 'password'
    environment VARCHAR(20) NOT NULL DEFAULT 'production',  -- 'production', 'staging', 'development'

    -- The credential (encrypted with CREDENTIAL_ENCRYPTION_KEY env var)
    encrypted_value BYTEA NOT NULL,             -- AES-256-GCM: IV(12) || AuthTag(16) || Ciphertext
    encryption_key_version INTEGER NOT NULL DEFAULT 1,

    -- Metadata
    description TEXT,
    url VARCHAR(500),                           -- Service URL (not the credential itself)
    username VARCHAR(200),                      -- Username if applicable (may also be encrypted)
    rotation_frequency_days INTEGER DEFAULT 180,
    last_rotated_date TIMESTAMPTZ,
    expires_date TIMESTAMPTZ,

    -- Lifecycle
    is_active BOOLEAN NOT NULL DEFAULT true,
    is_deleted BOOLEAN NOT NULL DEFAULT false,
    created_date TIMESTAMPTZ DEFAULT now(),
    updated_date TIMESTAMPTZ DEFAULT now(),

    -- Prevent duplicate active credentials
    CONSTRAINT uq_system_credential UNIQUE (system_name, credential_key, environment)
);

CREATE INDEX IF NOT EXISTS idx_credentials_active
    ON auth.system_credentials (system_name, environment)
    WHERE is_active = true AND is_deleted = false;

CREATE INDEX IF NOT EXISTS idx_credentials_rotation
    ON auth.system_credentials (last_rotated_date, rotation_frequency_days)
    WHERE is_active = true AND is_deleted = false;

COMMENT ON TABLE auth.system_credentials IS 'Encrypted credential store. Values encrypted with CREDENTIAL_ENCRYPTION_KEY env var.';
COMMENT ON COLUMN auth.system_credentials.encrypted_value IS 'AES-256-GCM encrypted. Format: IV (12 bytes) || AuthTag (16 bytes) || Ciphertext';

-- Credential access audit log
CREATE TABLE IF NOT EXISTS auth.credential_access_log (
    id BIGSERIAL PRIMARY KEY,
    fk_credential_id BIGINT NOT NULL REFERENCES auth.system_credentials(id),
    action VARCHAR(20) NOT NULL,                -- 'read', 'rotate', 'create', 'deactivate'
    performed_by VARCHAR(200) NOT NULL,         -- user email or service name
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_date TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_credential_access_log
    ON auth.credential_access_log (fk_credential_id, created_date DESC);
```

**Required environment variable:** `CREDENTIAL_ENCRYPTION_KEY` — a 256-bit key used to encrypt/decrypt credential values. This key MUST be in `.env` (never in the database).

---

## What Goes Where

| Credential Type | Storage Location | Never Store In |
|----------------|-----------------|----------------|
| User passwords | bcrypt hash in user table | Plaintext anywhere |
| API keys (3rd party) | Encrypted credential store | Code, committed config, docs |
| Service passwords | Encrypted credential store | Code, .env in repo |
| OAuth client secrets | Encrypted credential store | Code, docs |
| JWT signing keys | Environment variable (loaded at startup) | Code, database |
| DB connection strings | `.env` file (gitignored) | Code, committed config |
| Encryption keys | Environment variable only | Code, database, docs |

---

## Automated Secret Scanning

Use automated tools to catch accidental credential exposure before it reaches version control:

- **GitHub Secret Scanning** — enabled by default on public repos, available for private repos with GitHub Advanced Security
- **gitleaks** — open-source, runs locally or in CI (`gitleaks detect --source .`)
- **pre-commit hooks** — add gitleaks as a pre-commit hook to catch secrets before they're committed

These tools reduce risk but do not replace proper credential handling practices. They are a safety net, not a substitute for the rules below.

---

## Forbidden Practices

- Store plaintext passwords anywhere (code, docs, AI memory, chat, config)
- Commit `.env` files with credentials to version control
- Include real credentials in documentation (use: `[STORED IN: auth.system_credentials]`)
- Pass credentials as CLI arguments (visible in process list)
- Paste credentials into AI tool prompts (see SELF_GOVERNANCE.md)
- Store credentials in AI memory/context files
- Hard-code fallback credentials (e.g., `|| 'default_key'`)

---

## Real-World Gotchas

These are documented from production incidents. They are subtle and hard to debug.

### DATABASE_URL Special Characters

**Never use special characters** (`!`, `@`, `#`, `$`, `%`, `&`, etc.) in database passwords that appear in connection URLs.

```
# BROKEN — ! and @ are URL-meaningful characters
DATABASE_URL=postgresql://user:p@ss!word@host:5432/db
# psql works fine (no URL parsing), but Node.js pg library silently fails

# CORRECT — alphanumeric only
DATABASE_URL=postgresql://user:s3cureP4ss@host:5432/db
```

**Symptom:** `password authentication failed` from the application, but `psql` with the same credentials works. The Node.js `pg` library URL-parses the connection string — special characters corrupt the password extraction. This is nearly impossible to debug because the error message doesn't mention URL parsing.

### Environment Variables in Frontend Builds

Frontend frameworks (Next.js, Vite, etc.) inline environment variables at **build time**, not runtime. If `NEXT_PUBLIC_API_URL` is not set when `next build` runs, the fallback value (often `http://localhost:PORT`) gets permanently baked into the JavaScript bundle.

```bash
# WRONG — build without env vars, then set them later
next build              # localhost baked into JS
NEXT_PUBLIC_API_URL=... # Too late — already compiled

# CORRECT — set at build time
NEXT_PUBLIC_API_URL=https://api.example.com next build
```

**Also:** Never use dynamic key construction for these vars:
```typescript
// BROKEN — Next.js can't inline this at build time
const url = process.env[`NEXT_PUBLIC_${serviceName}_URL`];

// CORRECT — literal reference required for build-time inlining
const url = process.env.NEXT_PUBLIC_CORE_SERVICE_URL;
```

---

## AI Tool Safety

### Never Send to AI Tools
- Production passwords, API keys, encryption keys
- SSH/TLS private keys
- Database connection strings with credentials
- JWT secrets
- Customer PII (names + contact info, financial data, health records)

### Safe to Discuss with AI Tools
- Credential storage architecture and schema design
- Hashing algorithms and cost factors
- Placeholder examples (`API_KEY_HERE`, `[STORED IN: auth.system_credentials]`)
- Rotation procedures and schedules
- Access control patterns

---

## Rotation Schedule

| Credential Type | Frequency | On Breach |
|----------------|-----------|-----------|
| User passwords | 90 days | Immediate reset + notify user |
| API keys | 180 days | Immediate revoke + regenerate |
| Service account passwords | 180 days | Immediate reset + restart services |
| JWT signing keys | 365 days | Immediate rotate + invalidate all sessions |
| OAuth client secrets | 365 days | Immediate revoke + regenerate |
| Encryption keys | 365 days | Immediate rotate + re-encrypt (see ENCRYPTION.md) |

---

## Incident Response

If credentials are accidentally exposed (committed to git, pasted in AI, sent in email):

1. **Stop immediately** — do not continue the conversation/commit
2. **Document:** What was exposed, which platform, when, by whom
3. **Report:** Notify security/privacy lead
4. **Rotate:** Immediately revoke and regenerate the exposed credential
5. **Delete:** Remove from git history (`git filter-branch` or BFG), delete AI conversation if possible
6. **Assess:** Determine blast radius — what could an attacker do with this credential?
7. **Monitor:** Watch for unauthorized access using the exposed credential

---

## Standards Alignment

- **ISO 27001:** A.8.2 (privileged access), A.8.5 (authentication)
- **OWASP LLM02:** Sensitive Information Disclosure
- **PIPEDA:** Principle 7 (Safeguards)
- **SOC 2:** Security + Confidentiality trust criteria
