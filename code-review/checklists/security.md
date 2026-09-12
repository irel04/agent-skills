# Security review checklist

Activate this checklist when the PR touches: authentication, authorization,
session management, cryptography, input validation, SQL/queries, file I/O,
environment config, secrets, or any HTTP handler that processes user input.

All items marked BLOCKING must be resolved before merge. No exceptions.

## Authentication and sessions
- [ ] BLOCKING — New endpoints check authentication before doing any work
- [ ] BLOCKING — Session tokens are generated with a CSPRNG, not Math.random() or time-based seed
- [ ] BLOCKING — Passwords are hashed with bcrypt/argon2/scrypt — never MD5, SHA1, or plain SHA256
- [ ] BLOCKING — Password comparison uses constant-time equality, not == or ===
- [ ] SUGGESTION — Session expiry is enforced server-side, not just client-side
- [ ] SUGGESTION — Login endpoints have rate limiting or lockout after N failures

## Authorization
- [ ] BLOCKING — Every state-mutating endpoint checks the caller owns or can access the resource
- [ ] BLOCKING — Admin/privileged routes are protected by role check, not just auth check
- [ ] SUGGESTION — Authorization logic is centralised (middleware/guard) not scattered per handler
- [ ] SUGGESTION — IDOR: object IDs in requests are validated against the authenticated user's scope

## Input validation and injection
- [ ] BLOCKING — No raw user input interpolated into SQL strings — use parameterised queries/ORM
- [ ] BLOCKING — No raw user input in shell commands (`exec`, `spawn`, `subprocess`) without sanitisation
- [ ] BLOCKING — No `eval()` or `Function()` on user-controlled strings
- [ ] BLOCKING — File path inputs are sanitised against path traversal (../, %2e%2e)
- [ ] SUGGESTION — Input validation happens at the boundary (controller/handler), not deep in business logic
- [ ] SUGGESTION — Uploaded files are validated by content type, not just extension

## Secrets and sensitive data
- [ ] BLOCKING — No API keys, tokens, or passwords hardcoded in source
- [ ] BLOCKING — Secrets are not logged at any level (info, debug, error)
- [ ] BLOCKING — Sensitive fields are not returned in API responses unnecessarily (e.g. password hash in user object)
- [ ] SUGGESTION — New secrets are documented in .env.example with placeholder values
- [ ] SUGGESTION — PII is not written to application logs

## Cryptography
- [ ] BLOCKING — No use of deprecated algorithms: MD5, SHA1, DES, RC4, ECB mode
- [ ] BLOCKING — IVs and salts are randomly generated per operation, not hardcoded or reused
- [ ] SUGGESTION — TLS verification is not disabled (verify=False, rejectUnauthorized: false)
- [ ] SUGGESTION — JWT libraries are used correctly — alg:none attack, secret vs public key confusion

## Dependencies
- [ ] SUGGESTION — New dependencies are from reputable sources with active maintenance
- [ ] SUGGESTION — No known CVEs in newly added dependency versions (check snyk.io or osv.dev)
- [ ] NIT — Dependency versions are pinned or range-constrained to prevent surprise upgrades

## HTTP security
- [ ] SUGGESTION — CSRF protection on state-mutating endpoints that accept browser sessions
- [ ] SUGGESTION — Redirect destinations are validated against an allowlist (open redirect)
- [ ] NIT — Security headers are present on new HTTP handlers if applicable