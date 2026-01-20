# R21 Release Zip Rebuild Contract

**Concept-Tag:** RH-R21-CONTRACT

## Preconditions

1. Tag exists in git repository
2. Git worktree support available
3. zip command available with -X flag support

## Invariants

1. Same tag produces byte-identical zip on repeated runs
2. No timestamps embedded in zip (uses zip -X)
3. Stable file ordering (LC_ALL=C sort)
4. No network access required
5. No dependency on untracked local files

## Postconditions

1. Output zip contains README_VERIFY.md and repo/ directory
2. sha256 of zip is deterministic for a given tag
3. Worktree and temp files are cleaned up

## Acceptance Criteria

A) Determinism test:
   - Build zip twice from same tag
   - sha256 must match
   - cmp must pass (byte-identical)

B) Optional release comparison:
   - Downloaded release zip may differ in metadata
   - Content comparison is informational only

## Non-Claims

- No proof reproduction
- No RH claim
- This is release tooling only
