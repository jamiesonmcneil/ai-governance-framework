# Encryption Standards

**Requirements for encryption at rest, in transit, and key management across all projects.**

---

## Encryption at Rest

### Database Column-Level Encryption

For sensitive data stored in database columns (PII, credentials, vault items):

- **Algorithm:** AES-256-GCM (authenticated encryption with associated data)
- **Key size:** 256 bits minimum
- **IV (Initialization Vector):** Unique per encryption operation, stored with ciphertext
- **Auth tag:** Stored with ciphertext for integrity verification
- **Storage format:** BYTEA column containing `IV || AuthTag || Ciphertext`

```
Plaintext -> AES-256-GCM(key, IV) -> [IV (12 bytes) | AuthTag (16 bytes) | Ciphertext]
```

### Envelope Encryption (for multi-tenant systems)

When different tenants/accounts need separate encryption:

1. **Master key:** Stored in environment variable (`VAULT_MASTER_KEY`), never in database
2. **Data keys:** Per-tenant, encrypted with master key, stored in database
3. **Data:** Encrypted with the tenant's data key

```
Master Key (env var)
  -> encrypts -> Data Key A (stored in DB, encrypted)
                   -> encrypts -> Tenant A's sensitive data
  -> encrypts -> Data Key B (stored in DB, encrypted)
                   -> encrypts -> Tenant B's sensitive data
```

### Password Hashing

Passwords are NEVER encrypted — they are one-way hashed.

- **Algorithm:** bcrypt
- **Cost factor:** 12 minimum (increase as hardware improves)
- **Never:** MD5, SHA-1, SHA-256 alone (without salt + key stretching), plaintext storage

```typescript
// Hashing
const hash = await bcrypt.hash(password, 12);

// Verification
const isValid = await bcrypt.compare(password, storedHash);
```

---

## Encryption in Transit

- **TLS 1.2+ required** for all external communication (HTTPS, database connections, API calls)
- **Internal service-to-service:** TLS recommended; if on same host/VPC, plaintext acceptable with network isolation
- **Database connections:** Use SSL/TLS when database is on a separate host
- **API calls to AI providers:** Always HTTPS (data includes user content)

---

## Key Management

### Key Separation Rule

**The encryption key and the encrypted data MUST NEVER be stored in the same location.**

| Data Location | Key Location | Example |
|--------------|-------------|---------|
| Database | Environment variable (.env) | DB credentials encrypted, key in `VAULT_MASTER_KEY` env var |
| File | Different file or env var | Config file encrypted, key in `.env` |
| Secrets Manager | Environment variable | AWS SM stores secrets, access key in env |

### Key Rotation

| Key Type | Rotation Frequency | On Breach |
|----------|-------------------|-----------|
| Vault master key | Annual | Immediate rotate + re-encrypt all data keys |
| Per-tenant data keys | Annual or on demand | Immediate rotate + re-encrypt tenant data |
| JWT signing key | Annual | Immediate rotate + invalidate all sessions |
| TLS certificates | Before expiry (auto-renew) | Immediate reissue |

### Key Rotation Procedure

1. Generate new key (same algorithm and length)
2. Encrypt new data with new key, mark with new version number
3. Keep old key available for decrypting existing data
4. Re-encrypt existing data with new key (background job)
5. Once all data re-encrypted, archive old key (do not delete immediately)

---

## Project-Specific Configuration

The `.ai-governance/config.json` file specifies the credential storage method. See `CREDENTIAL_SECURITY.md` for the storage decision tree and DDL for database-backed credential stores.
