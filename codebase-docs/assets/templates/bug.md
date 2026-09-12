# Bug: <Short Title>

**ID / Issue:** <!-- ticket or GitHub issue link -->  
**Date Reported:** YYYY-MM-DD  
**Date Fixed:** YYYY-MM-DD (or leave blank if still open)  
**Severity:** Critical | High | Medium | Low  
**Status:** Open | In Progress | Fixed | Closed  
**Reporter:** <!-- name or @handle -->  
**Assignee:** <!-- name or @handle -->

---

## Summary

<!-- One sentence: what is broken and where. -->

## Steps to Reproduce

1. ...
2. ...
3. ...

**Expected:** <!-- what should happen -->  
**Actual:** <!-- what actually happens -->

## Root Cause

<!-- Technical explanation of why this bug exists. Be specific: file, function, line range if known. -->

## Impact

<!-- Who/what is affected? Frequency, data integrity risk, user-facing vs internal. -->

## Fix

<!-- Describe the fix. Include code snippet or diff if helpful. -->

```ts
// Before
const value = data[key]; // could be undefined

// After
const value = data[key] ?? defaultValue;
```

**PR / Commit:** <!-- link -->

## Prevention

<!-- What can prevent this class of bug in the future? New test, lint rule, type guard, review checklist item. -->

## Related Issues

<!-- Links to related bugs, feature requests, or post-mortems. -->
