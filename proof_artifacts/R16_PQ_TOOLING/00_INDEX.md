# R16: PQ Tooling Receipt

**Concept-Tag:** RH-R16-INDEX

## Purpose

R16 provides an OPTIONAL tooling receipt that captures the PQ verification backend and versions. This makes "skipped due to missing tooling" explicit and auditable.

## Principle

> "If present, the receipt must match the current environment; otherwise verification passes."

## Contents

| File | Description |
|------|-------------|
| [R16_CONTRACT.md](R16_CONTRACT.md) | Tooling receipt policy |
| [R16_TOOLING_RECEIPT.json](R16_TOOLING_RECEIPT.json) | Receipt artifact (optional) |
| [R16_TOOLING_RECEIPT.sha256](R16_TOOLING_RECEIPT.sha256) | Receipt digest |
| [R16_TOOLING_RECEIPT.schema.json](R16_TOOLING_RECEIPT.schema.json) | JSON schema |
| [R16_WORKLIST.md](R16_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R16_PQ_TOOLING.sh
```

## Non-Claims

- No RH claim
- Receipt is optional; absence does not affect verification
- Captures environment state, not proof correctness
