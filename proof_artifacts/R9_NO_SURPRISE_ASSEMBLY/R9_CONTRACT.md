# R9 No-Surprise Assembly Contract

**Concept-Tag:** RH-R9-NO-SURPRISE-ASSEMBLY

## Claim

R8 regeneration is valid only relative to a declared input manifest with sha256 digests.

## Construction

Define:

- **MANIFEST** = ordered list of required inputs (relative paths from repo root)
- **DIGESTS** = sha256 hash for each manifest entry, in manifest order

Rule:

- If any digest in `R9_INPUT_DIGESTS.sha256` mismatches the current sha256 of its file, regeneration is invalid and verification fails.

## Policy

No silent changes to input surfaces; any change must update manifest + digests together in a PR.

## Verification

1. Check manifest hash matches committed `R9_INPUT_MANIFEST.sha256`
2. Check each file digest matches its line in `R9_INPUT_DIGESTS.sha256`
3. Fail loudly with which file mismatched

## What This Does Not Do

- Does not prove correctness of the mathematics
- Does not validate the cited sources
- Does not pay any debt items
