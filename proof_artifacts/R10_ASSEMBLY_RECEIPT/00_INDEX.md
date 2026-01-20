# R10: Assembly Receipt

**Concept-Tag:** RH-R10-INDEX

## Purpose

R10 provides a canonical JSON receipt capturing the assembly state: git commit, R9 manifest digest, input digests, and output artifact digests. This makes the no-surprise assembly receipt-bound.

## Principle

> "A receipt binds the assembly to a specific commit and verified input/output surface."

## Contents

| File | Description |
|------|-------------|
| [R10_CONTRACT.md](R10_CONTRACT.md) | Assembly receipt policy |
| [R10_RECEIPT.schema.json](R10_RECEIPT.schema.json) | Minimal JSON schema |
| [R10_RECEIPT.json](R10_RECEIPT.json) | Canonical receipt |
| [R10_RECEIPT.sha256](R10_RECEIPT.sha256) | Digest of the receipt file |
| [R10_WORKLIST.md](R10_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R10_ASSEMBLY_RECEIPT.sh
```

## Non-Claims

- No RH claim
- No new analytic bounds
- This is a receipt for structural integrity, not a proof
