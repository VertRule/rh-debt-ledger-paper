# R11 Signature Layer Contract

**Concept-Tag:** RH-R11-SIGNATURE-LAYER

## Claim

Optionally sign R10 assembly_root_sha256. Verification checks signature if present; otherwise passes without it.

## Policy

No required keys; signatures are additive.

## Construction

The signable text file (`R10_ASSEMBLY_ROOT.txt`) contains:

```
assembly_root_sha256=<hex>
```

The value is pulled from `R10_RECEIPT.json` (authoritative source).

If a detached signature exists (`R10_ASSEMBLY_ROOT.sig`), verification validates it with GPG.

## Verification Rules

1. `R10_ASSEMBLY_ROOT.txt` must exist and match `R10_RECEIPT.json`
2. If `.sig` exists: verify with `gpg --verify`; fail if invalid
3. If `.sig` absent: pass (signature not required)

## What This Does Not Do

- Does not require any specific key
- Does not prove correctness of the mathematics
- Does not pay any debt items
