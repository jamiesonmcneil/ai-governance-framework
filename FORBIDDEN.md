# Forbidden Practices

**Universal prohibitions that apply to ALL projects using this governance framework. Project-specific FORBIDDEN.md files ADD to this list but cannot remove from it.**

---

## Security

### Numeric IDs in Public Interfaces
```
FORBIDDEN: /items/42, mutation updateItem($id: Int!)
REQUIRED:  /items/a1b2c3d4-..., mutation updateItem($uuid: String!)
```
Never expose sequential numeric primary keys in URLs, GraphQL parameters, or API responses. Use UUIDs or slugs. Numeric IDs enable enumeration attacks (IDOR).

### Queries Without Scope/Tenant Filter
```sql
-- FORBIDDEN
SELECT * FROM items WHERE uuid = $1;

-- REQUIRED (multi-tenant)
SELECT * FROM items WHERE tenant_id = $1 AND uuid = $2;
```
Every query on tenant-scoped tables MUST include a scope/tenant filter. Missing filters leak data between tenants.

### Auth Context from User Input
```
FORBIDDEN: accountId = input.accountId; accountId = req.body.accountId;
REQUIRED:  accountId = context.req.user.account_id;  // From JWT/session
```
Tenant/account identifiers MUST come from the authenticated session (JWT, cookie, server session), never from user-supplied input.

### Predictable Tokens
```
FORBIDDEN: shareToken = `share-${id}-${Date.now()}`
REQUIRED:  shareToken = crypto.randomUUID()  // or gen_random_uuid() in PostgreSQL
```
Share links, invite tokens, password reset tokens, and API keys MUST be cryptographically random.

### Credentials in Code or Prompts
```
FORBIDDEN: const API_KEY = "sk-abc123..."; password: "mypassword"
FORBIDDEN: Pasting API keys, passwords, or PII into AI tool prompts
REQUIRED:  process.env.API_KEY or encrypted credential store
```
See CREDENTIAL_SECURITY.md for the complete protocol.

---

## Code Quality

### Hard-Coded Values
```
FORBIDDEN: const STATUS_OPTIONS = [{ value: 'active', label: 'Active' }];
REQUIRED:  const options = await fetchFromAPI('/statuses');
```
Configuration, option lists, feature flags, and business rules come from database/config/environment, not hard-coded arrays.

### console.log in Production
```
FORBIDDEN: console.log('User data:', userData);
ALLOWED:   console.error('Failed to fetch:', error.message);  // Errors only
ALLOWED:   if (process.env.NODE_ENV === 'development') console.log(...);
```

### Code Reverts Without Approval
```
FORBIDDEN: Replacing newer code with an older version
FORBIDDEN: "Simplifying" by removing recent work
REQUIRED:  Build on existing code, fix issues in place, ask if confused
```

---

## AI-Specific

### Scrubbing Before Tool-Calling AI
```
FORBIDDEN: scrub(userMessage) -> sendToAI(scrubbedMessage)  // AI stores tokens as data
REQUIRED:  sendToAI(userMessage) -> AI calls tools with real values -> scrub logs after
```
See RULES.md Rule 8 "AI Tool-Calling and PII" for the full explanation.

### Localhost URLs in Production Bundles
```
FORBIDDEN: const apiUrl = process.env.API_URL || 'http://localhost:3009';  // In production JS
```
When `NEXT_PUBLIC_*` (or equivalent) env vars are missing at build time, `|| 'http://localhost:PORT'` fallbacks get baked into the production JavaScript bundle. This causes browsers to prompt "wants to access other apps on your local network" and sends API requests to the user's machine instead of the server. **Always set all environment variables at build time for production builds.**

### GraphQL Introspection in Production
```
FORBIDDEN: Leaving GraphQL introspection enabled in production
REQUIRED:  introspection: process.env.NODE_ENV !== 'production'
```
Introspection exposes the entire API schema to attackers — every type, field, argument, and relationship. Disable it in production. Use persisted queries or API documentation for legitimate consumers.

### Direct Database Access from Frontend
```
FORBIDDEN: const result = await pool.query('SELECT * FROM items');  // In browser code
REQUIRED:  const { data } = useQuery(GET_ITEMS);  // Through API layer
```
Frontends access data through GraphQL/REST APIs, never directly to the database.

---

## Process

### Claiming Completion Without Testing
```
FORBIDDEN: "I updated the file" (without verifying the change works end-to-end)
REQUIRED:  Test the full workflow, verify data persists, confirm in the actual environment
```

### Forgetting User Requests
```
FORBIDDEN: Working on task A and silently dropping tasks B, C, D that were also requested
REQUIRED:  Track ALL requests in a task list, complete each one, review before ending
```

---

**Project-specific FORBIDDEN.md files extend this list with project-specific prohibitions (e.g., specific UI components, ORM patterns, deprecated modules).**
