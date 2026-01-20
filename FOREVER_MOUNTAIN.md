# Forever Mountain

**Concept-Tag:** RH-FOREVER-MOUNTAIN

## Dragon (the hard obligation)

Unconditional tail bound equivalent in difficulty to RH.

This repo cannot pay this debt computationally. It requires an external proof artifact.

## What the repo currently proves (mechanically)

- Verification passes (`VR_STRICT=1 ./VERIFY.sh`)
- Exhibits are indexed and digest-verified (`EXHIBITS.md`)
- Honesty ledger enforced (`CONTRIBUTION_LEDGER.md`)
- Governance drill recorded (block-on-fail, unblock-on-revert)

## Ladder (R0 → R5)

| Rung | Definition | Status |
|------|------------|--------|
| R0 | Mechanical verification only | Done |
| R1 | Reproducible debt measurements + envelope checks | Done |
| R2 | Conditional tail bound under explicit assumptions | Done (see exhibits) |
| R3 | Unconditional analytic bound weaker than RH | Target |
| R4 | Transfer derivation (ψ → π−Li) | Done (scaffold) |
| R5 | Error-bound source contract (external obligation) | Done |

### R3 target: classical zero-free region bound

Goal: prove an unconditional error term bound via classical zero-free region methods (PNT-style).

**Deliverable structure:**
- Theorem contract (statement + assumptions)
- Proof sketch outline
- Dependencies (cited, not linked)
- No constants claimed without derivation
- R3 worklist: [proof_artifacts/R3_ZERO_FREE_REGION/R3_WORKLIST.md](proof_artifacts/R3_ZERO_FREE_REGION/R3_WORKLIST.md)

**Citations placeholder:**
- de la Vallée Poussin (1896)
- Korobov-Vinogradov zero-free region
- Standard analytic number theory references

### R4: Transfer Reproduction Slice

An in-repo reproduction of the ψ(x) → π(x)−Li(x) transfer step with explicit assumptions and explicit debt.

**Index:** [proof_artifacts/R4_TRANSFER_REPRO/00_INDEX.md](proof_artifacts/R4_TRANSFER_REPRO/00_INDEX.md)

**Non-claims:**
- No RH claim
- No zero-free region claim
- No numeric constants asserted
- Debt (prime-power correction, thresholds) remains explicit

**Verification:** R4 packet integrity is checked by `VERIFY_R4_TRANSFER.sh`.

### R5: Error-Bound Source Contract

R5 is where the tail-bound source becomes an explicit external obligation.

**Index:** [proof_artifacts/R5_ERROR_BOUND_SOURCE/00_INDEX.md](proof_artifacts/R5_ERROR_BOUND_SOURCE/00_INDEX.md)

**Purpose:**
- Defines admissibility predicates A1–A4 for an E(t) source
- Catalogs available sources (unconditional vs RH-conditional)
- Declares Dragon obligation (RH-level bound) as EXTERNAL

**Non-claims:**
- No RH claim
- No zero-free region reproduction
- Sources are cited, not derived

**Verification:** R5 packet integrity is checked by `VERIFY_R5_ERROR_BOUND.sh`.

## We do not claim

- Unknowns remain debt
- Absence has meaning
- Review is governance, not omniscience
- Computational verification cannot substitute for analytic proof
