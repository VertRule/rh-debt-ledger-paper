# R15: Post-Quantum Signature Envelope

**Concept-Tag:** RH-R15-INDEX

## Purpose

R15 provides an OPTIONAL post-quantum signature track for R10_ASSEMBLY_ROOT.txt, running hybrid alongside the existing GPG signatures. No keys are stored; only signatures.

## Principle

> "Hybrid: classical signatures remain; PQ signatures are additive; no claims if absent."

## Contents

| File | Description |
|------|-------------|
| [R15_CONTRACT.md](R15_CONTRACT.md) | PQ signature policy |
| [R15_PQ_POLICY.md](R15_PQ_POLICY.md) | Scheme and format details |
| [sigs_pq/](sigs_pq/) | PQ signature files (*.sig) |
| [R15_WORKLIST.md](R15_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R15_PQ_SIGNATURE.sh
```

## Non-Claims

- No RH claim
- No key material stored (signatures only)
- PQ signatures are optional; absence does not affect verification
- Verification requires local PQ tooling; skipped if unavailable
