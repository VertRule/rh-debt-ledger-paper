# R9: No-Surprise Assembly

**Concept-Tag:** RH-R9-INDEX

## Purpose

R9 binds R8 regeneration to a declared input manifest with sha256 digests. This ensures no silent changes to the input surface can invalidate the comparison receipt without detection.

## Principle

> "Regeneration is valid only relative to a declared input manifest."

## Contents

| File | Description |
|------|-------------|
| [R9_CONTRACT.md](R9_CONTRACT.md) | No-surprise assembly policy |
| [R9_INPUT_MANIFEST.txt](R9_INPUT_MANIFEST.txt) | Ordered list of input file paths |
| [R9_INPUT_MANIFEST.sha256](R9_INPUT_MANIFEST.sha256) | Digest of the manifest file |
| [R9_INPUT_DIGESTS.sha256](R9_INPUT_DIGESTS.sha256) | Per-file sha256 digests |
| [R9_WORKLIST.md](R9_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R9_NO_SURPRISE.sh
```

## Non-Claims

- No RH claim
- No new analytic bounds
- This is input-surface integrity checking, not a proof
