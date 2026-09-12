# Code review skill

This skill defines the standards, dimensions, comment format, and decision rules
the pr-reviewer sub-agent applies to every pull request.

---

## Review dimensions (in priority order)

Work through these in order. Higher dimensions override lower ones — a BLOCKING
correctness issue matters more than 10 nit-level style comments.

### 1. Correctness
The code does what it claims to do, safely, in all cases.

Check for:
- Logic errors, wrong operator precedence, incorrect conditionals
- Off-by-one errors in loops, slice indices, pagination
- Null/undefined/nil dereference without guard
- Integer overflow or underflow (especially in financial or size calculations)
- Race conditions in concurrent code (shared mutable state, missing locks)
- Incorrect error handling — errors swallowed, wrong error type returned
- Wrong HTTP status codes returned
- Missing edge cases: empty input, single element, max value, zero

Severity guide:
- Data loss or silent corruption → BLOCKING
- Wrong output in common cases → BLOCKING
- Wrong output in edge cases → SUGGESTION
- Theoretical but unlikely corner case → NIT

### 2. Security
The code does not introduce vulnerabilities or weaken existing protections.

Trigger the security checklist (`checklists/security.md`) automatically when
changed files include any of: auth/, middleware/, session, token, password,
crypto, sql, query, migration, .env, secrets, permissions, roles, admin.

Common patterns to always check regardless:
- User-controlled input used in file paths, shell commands, or eval → BLOCKING
- Sensitive data (tokens, passwords, PII) logged or included in error messages → BLOCKING
- Direct string interpolation into SQL queries → BLOCKING
- Missing authorization checks on new endpoints → BLOCKING
- Secrets or credentials hardcoded in source → BLOCKING
- Unsafe deserialization of untrusted input → BLOCKING

### 3. Performance
The code does not introduce regressions in hot paths or under load.

Trigger the performance checklist (`checklists/performance.md`) when changed
files touch: database queries, loops over large collections, caching layers,
API handlers, background jobs, or serialization.

Common patterns to always check:
- N+1 query pattern (query inside a loop without batching) → BLOCKING in production code
- Unbounded queries without LIMIT → SUGGESTION
- Synchronous I/O in async context (blocking event loop) → BLOCKING
- Missing database indexes for new query patterns → SUGGESTION
- Large payload returned when only a subset is needed → SUGGESTION

### 4. Maintainability
The code is readable, well-named, and does not increase complexity debt.

Check for:
- Function or method longer than ~50 lines doing multiple things → SUGGESTION to split
- Variable/function names that require context to understand (e.g. `d`, `tmp2`, `flag`) → NIT
- Magic numbers or strings without named constants → NIT unless in a hot path
- Deep nesting (> 3 levels) that could be flattened with early returns → SUGGESTION
- Duplicated logic that should be extracted → SUGGESTION
- Dead code (unreachable branches, unused imports, commented-out blocks) → NIT
- TODOs left without a ticket reference → NIT

### 5. Test coverage
New behaviour is tested; existing tests are not regressed.

Check for:
- New public functions or API endpoints with no corresponding test → SUGGESTION
- Happy path tested but no error/edge case tests → SUGGESTION
- Tests that always pass (assertion on wrong variable, missing await, etc.) → BLOCKING
- Mocks that are so broad they don't test the actual behaviour → SUGGESTION
- Missing test for the specific bug this PR claims to fix → SUGGESTION

### 6. Conventions and style
The code follows the project's established patterns.

Check for:
- Inconsistency with patterns already in the file or module
- Missing or incorrect docstrings/JSDoc where the project uses them
- Import ordering or grouping that doesn't match surrounding code
- Formatting inconsistencies that would fail the project's linter

All style comments are NIT unless the project has a strict enforced standard.

---

## Comment format

Every comment you write must follow this structure internally before you post it:

```
FILE: <relative path>
LINE: <line number or range>
SEVERITY: [BLOCKING] | [SUGGESTION] | [NIT] | [PRAISE]
ISSUE: <one sentence stating what is wrong or noteworthy>
FIX: <concrete recommendation — code snippet preferred>
```

When posting to GitHub via `add_pull_request_review_comment_to_pending_review`,
format the `body` as:

```
**[BLOCKING]** Password compared with `==` instead of constant-time comparison.

Vulnerable to timing attacks — an attacker can measure response time to infer
whether a guess was partially correct.

**Fix:** Use `crypto.timingSafeEqual()` or your auth library's built-in compare:
\```ts
const match = crypto.timingSafeEqual(
  Buffer.from(inputHash),
  Buffer.from(storedHash)
);
\```
```

Rules:
- First line: severity badge + one-sentence problem statement.
- Second paragraph: why it matters (impact).
- Third paragraph: the fix, with a code snippet when possible.
- Keep total comment length under 300 words. If the explanation needs more, link
  to a doc or suggest opening a separate issue.

---

## Diff reading rules

When reading a unified diff:
- Lines starting with `+` are additions (side=RIGHT in GitHub review API)
- Lines starting with `-` are deletions (side=LEFT)
- Lines with no prefix are context lines
- Your inline comment line number refers to the position in the NEW file for
  additions, or the OLD file for deletions

For multi-line comments (e.g. a whole function body):
- Set `startLine` to the first line of the range
- Set `line` to the last line of the range
- Set `startSide` and `side` accordingly

---

## Language-specific quick checks

### TypeScript / JavaScript
- `any` type used → NIT (suggest proper type or `unknown`)
- `!` non-null assertion on user input → SUGGESTION (add runtime guard)
- `console.log` left in production code → NIT
- Promise not awaited and not caught → BLOCKING
- `var` instead of `const`/`let` → NIT

### Python
- Bare `except:` or `except Exception:` swallowing all errors → SUGGESTION
- Mutable default argument (`def f(items=[])`) → BLOCKING
- `print()` left in production code → NIT
- `subprocess` with `shell=True` and user input → BLOCKING
- Missing type hints on public functions (if project uses them) → NIT

### Go
- Error return ignored with `_` → SUGGESTION (BLOCKING if in critical path)
- `defer` inside a loop → SUGGESTION
- Goroutine without a way to be stopped or awaited → SUGGESTION
- `panic` in library code → BLOCKING

### SQL / ORM
- `SELECT *` in production query → SUGGESTION
- No index on foreign key used in JOIN or WHERE → SUGGESTION
- Raw string interpolation into query → BLOCKING
- Migration with no rollback plan → SUGGESTION

---

## Scope limits

If you encounter these situations, state them explicitly in the summary comment
rather than silently skipping:

- **Diff too large**: > 30 files or > 1500 lines changed. Review highest-risk
  files only and list skipped files.
- **Generated code**: files with `generated`, `vendor`, `node_modules`, `dist`,
  `.pb.go`, `_pb2.py` in the path. Skip unless the PR claims to modify them.
- **Binary files**: skip.
- **Lock files** (`package-lock.json`, `poetry.lock`, `go.sum`): skip content
  review, but flag if the package added has a known security advisory.
- **Insufficient context**: if you cannot determine whether something is a bug
  without understanding runtime behaviour, say so and ask a specific question
  rather than guessing.