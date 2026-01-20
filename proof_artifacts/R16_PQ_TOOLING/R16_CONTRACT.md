# R16 PQ Tooling Receipt Contract

**Concept-Tag:** RH-R16-PQ-TOOLING-RECEIPT

## Claim

Optionally capture the PQ verification backend and versions in a deterministic receipt. If present, verification checks the receipt matches the current environment.

## Policy

Receipt is optional. If absent, verification passes. If present, mismatch fails.

## Construction

The tooling receipt captures:
- Backend type (none, openssl-oqsprovider, oqs-toolbox)
- Backend version string
- Command availability

Receipt location:

```
proof_artifacts/R16_PQ_TOOLING/R16_TOOLING_RECEIPT.json
```

## Verification Rules

1. If receipt file does not exist: PASS (receipt absent, ok)
2. If receipt exists:
   - Verify sha256 matches R16_TOOLING_RECEIPT.sha256
   - Recompute current backend detection and versions
   - Compare to receipt fields exactly
   - FAIL on mismatch

## What This Does Not Do

- Does not require PQ tooling
- Does not affect R15 signature verification
- Does not make RH claims
