# Forbidden Practices (Project-Specific)

Project-specific prohibitions are ADDITIVE only. They add to core prohibitions at `/path/to/ai-governance-framework/FORBIDDEN.md`.

If unsure whether something is allowed, pause and confirm before proceeding.

---

## Forbidden

### Hardcoded Configuration
```
// FORBIDDEN
const DB_HOST = "192.168.1.100";
const API_KEY = "sk-abc123";

// REQUIRED
const DB_HOST = process.env.DB_HOST;
const API_KEY = process.env.API_KEY;
```

### Direct Database Access Without Abstraction
```
// FORBIDDEN
const users = await pool.query("SELECT * FROM users WHERE id = " + userId);

// REQUIRED
const users = await userRepository.findById(userId);  // Parameterized internally
```

### Skipping Input Validation
```
// FORBIDDEN
app.post('/users', (req, res) => {
  db.insert(req.body);  // Trusting raw input
});

// REQUIRED
app.post('/users', validate(userSchema), (req, res) => {
  db.insert(req.validated);
});
```

### Using Personal AI Accounts for Work
```
FORBIDDEN: Pasting project code into personal ChatGPT/Claude free accounts
FORBIDDEN: Using unapproved browser AI extensions on work data
REQUIRED:  Use only approved AI tools configured in .ai-governance/config.json
```

### Granting AI Broad Data Access
```
FORBIDDEN: Enabling all available connectors/plugins without review
REQUIRED:  Enable only required integrations, review data access scope
```
