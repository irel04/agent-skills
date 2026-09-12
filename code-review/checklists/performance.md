# Performance review checklist

Activate this checklist when the PR touches: database queries, ORM usage,
loops over collections, caching layers, API handlers, serialization/deserialization,
background jobs, or any code that runs per-request at scale.

## Database queries
- [ ] BLOCKING — No query inside a loop (N+1). Use batch fetch, eager loading, or a JOIN instead.
- [ ] SUGGESTION — New queries on large tables have a supporting index (check WHERE, JOIN, ORDER BY columns)
- [ ] SUGGESTION — No unbounded SELECT without LIMIT/pagination in list endpoints
- [ ] SUGGESTION — COUNT(*) on large tables where approximate count would suffice
- [ ] SUGGESTION — Transactions scoped as tightly as possible — no long-held locks
- [ ] NIT — SELECT * where only a subset of columns is used

## Memory and allocations
- [ ] SUGGESTION — Large in-memory collections that should be streamed or paginated instead
- [ ] SUGGESTION — Objects allocated in a tight loop that could be pre-allocated or pooled
- [ ] SUGGESTION — Unnecessary deep cloning of large data structures

## Async and concurrency
- [ ] BLOCKING — Blocking synchronous I/O (file read, HTTP call, DB query) on an async thread/event loop
- [ ] SUGGESTION — Missing concurrency for independent async operations (sequential awaits that could be Promise.all)
- [ ] SUGGESTION — Unbounded concurrency — spawning goroutines/promises in a loop without a semaphore or pool
- [ ] SUGGESTION — Mutex held across an I/O operation (should release before I/O, reacquire after)

## Caching
- [ ] SUGGESTION — Cache key includes all dimensions that affect the result (user, locale, version, etc.)
- [ ] SUGGESTION — Cache invalidation strategy is explicit — no stale data risk
- [ ] SUGGESTION — Cache stampede risk on cold start or expiry of hot keys

## Serialization and payloads
- [ ] SUGGESTION — Large payloads returned when a projection/sparse fieldset would suffice
- [ ] SUGGESTION — JSON serialization of deeply nested objects in hot paths (consider binary format)
- [ ] NIT — Dates serialized as strings where epoch integers are sufficient

## Frontend / rendering (if applicable)
- [ ] SUGGESTION — Re-renders triggered by reference equality issues (new object/array on every render)
- [ ] SUGGESTION — Expensive computations in render path without memoization
- [ ] SUGGESTION — Large bundle imports where tree-shaking or dynamic import would help
- [ ] NIT — Images without explicit dimensions (causes layout shift)