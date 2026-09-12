# General review checklist

Use this as a rapid scan pass after reading the diff. Check each item and note
any that warrant a comment. Do not post a comment for items that pass cleanly.

## PR hygiene
- [ ] PR title clearly describes what changed (not "fix bug" or "updates")
- [ ] PR description explains WHY, not just what (link to issue or context)
- [ ] PR is scoped to one concern — not mixing refactor + feature + bugfix
- [ ] Draft PRs are not accidentally submitted for review
- [ ] Requested reviewers are appropriate for the changes

## Code quality
- [ ] No leftover debug statements (console.log, print, debugger, binding.pry)
- [ ] No commented-out code blocks without explanation
- [ ] No hardcoded environment-specific values (URLs, ports, credentials)
- [ ] No TODO/FIXME without an associated ticket or owner
- [ ] File and function names match what they actually do
- [ ] No obvious copy-paste duplication between files

## Error handling
- [ ] All error paths return or throw — none are silently swallowed
- [ ] Error messages are useful for debugging but don't leak stack traces to users
- [ ] External API calls have timeout and retry handling (or explicitly don't need it)
- [ ] File/DB/network operations handle partial failure

## Compatibility
- [ ] No breaking changes to public API without version bump or deprecation notice
- [ ] Database migrations are backward-compatible (no drop column without a transition period)
- [ ] Environment variable additions are documented (README, .env.example, etc.)
- [ ] New dependencies are justified — not adding a 200KB package for a 3-line utility

## Testing
- [ ] New behaviour has at least one test
- [ ] Tests cover the unhappy path, not just the happy path
- [ ] Test names describe what they test, not how
- [ ] No `sleep` or arbitrary timeouts in tests — use proper async primitives
- [ ] Test data is isolated — tests don't rely on order of execution