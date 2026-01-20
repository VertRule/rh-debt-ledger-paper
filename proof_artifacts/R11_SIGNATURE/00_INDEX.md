# R11: Signature Layer

**Concept-Tag:** RH-R11-INDEX

## Purpose

R11 provides an optional signature layer for the R10 assembly root. This allows operators with GPG keys to cryptographically sign the assembly state, while verification still passes without signatures.

## Principle

> "Signatures are additive; absence is not failure."

## Contents

| File | Description |
|------|-------------|
| [R11_CONTRACT.md](R11_CONTRACT.md) | Signature layer policy |
| [R11_SIGNATURE_POLICY.md](R11_SIGNATURE_POLICY.md) | Detailed signing policy |
| [R10_ASSEMBLY_ROOT.txt](R10_ASSEMBLY_ROOT.txt) | Signable assembly root text |
| R10_ASSEMBLY_ROOT.sig | Detached signature (optional) |
| [R11_WORKLIST.md](R11_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R11_SIGNATURE.sh
```

## Non-Claims

- No RH claim
- No required keys
- Signatures are optional and additive
