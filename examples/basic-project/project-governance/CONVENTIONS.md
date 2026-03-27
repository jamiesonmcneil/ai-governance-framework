# Naming & Style Conventions

These conventions OVERRIDE default patterns for this project. They must NOT conflict with core rules, security requirements, or verification standards.

---

## File Naming

| Category | Convention | Example |
|----------|-----------|---------|
| Source files | kebab-case | `user-service.ts` |
| Test files | `.test.ts` suffix | `user-service.test.ts` |
| Config files | lowercase | `tsconfig.json` |

## Naming Patterns

| Category | Convention | Example |
|----------|-----------|---------|
| Variables | camelCase | `userId`, `isActive` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES`, `API_BASE_URL` |
| Functions | camelCase | `getUserById()`, `validateInput()` |
| Types/Interfaces | PascalCase | `UserProfile`, `ApiResponse` |

## Git

- **Branch naming:** `feature/description`, `fix/description`
- **Commit messages:** Conventional commits (`feat:`, `fix:`, `chore:`, `docs:`)
