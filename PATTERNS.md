# Required Code Patterns

**Universal patterns that apply to ALL projects. Project-specific PATTERNS.md files ADD project-specific patterns.**

---

## 1. Parameterized Queries

All dynamic values in SQL MUST be parameterized. Never use string concatenation.

```sql
-- CORRECT
SELECT * FROM items WHERE id = $1 AND tenant_id = $2;

-- WRONG (SQL injection vulnerability)
SELECT * FROM items WHERE id = ${id};
```

This applies regardless of ORM — raw SQL, query builders, and ORMs all support parameterization. Project-specific PATTERNS.md should document the exact syntax for the project's ORM.

---

## 2. UUID Public Identifiers

All public-facing identifiers (URLs, API params, API responses) use UUID or slug, never numeric IDs.

```
CORRECT: /items/a1b2c3d4-e5f6-7890-abcd-ef1234567890
CORRECT: /items/my-grocery-list (slug)
WRONG:   /items/42 (enumerable)
```

Numeric IDs are internal to the database. Resolvers/controllers accept UUID, look up by UUID, return UUID.

---

## 3. Auth Context from Session

Account/tenant identifiers come from the authenticated session, never from user input.

```typescript
// CORRECT — from JWT/session
const accountId = context.req.user.account_id;

// WRONG — from user input (tenant spoofing)
const accountId = input.accountId;
```

---

## 4. Audit Logging with Fallback

Mutations that modify data should log the action. Audit logging must not block the operation if it fails.

```typescript
try {
  await auditLogger.log({
    userId, accountId, action: 'CREATE', resource: 'item',
    resourceId: newItem.uuid,
    req: context.req || { headers: {} },  // Fallback for service-to-service calls
  });
} catch (auditError) {
  console.error('Audit logging failed (non-fatal):', auditError.message);
}
```

---

## 5. SSR/Hydration Guard

Components using browser APIs (window, localStorage, navigator) must guard against server-side rendering.

```typescript
const [mounted, setMounted] = useState(false);
useEffect(() => { setMounted(true); }, []);
if (!mounted) return <Loading />;
// Safe to use browser APIs after this point
```

---

## 6. API-Layer Data Access

Frontends access data through an API layer (GraphQL, REST), never directly to the database.

```
Browser -> GraphQL/REST API -> Backend Service -> Database
                                    ^
                            Auth + tenant filter applied here
```

---

## 7. Error Handling

Errors are handled explicitly. User-facing errors are friendly. Internal errors are logged with context. Errors are never silently swallowed.

```typescript
try {
  const result = await operation();
  return result;
} catch (error) {
  console.error('Operation failed:', error.message);  // Log with context
  throw new UserFacingError('Something went wrong. Please try again.');  // Friendly message
}
```

---

**Project-specific PATTERNS.md files add patterns for the project's specific technology stack (e.g., ORM syntax, component libraries, authentication extractors, GraphQL conventions).**
