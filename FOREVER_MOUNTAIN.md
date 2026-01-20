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

## Ladder (R0 → R8)

| Rung | Definition | Status |
|------|------------|--------|
| R0 | Mechanical verification only | Done |
| R1 | Reproducible debt measurements + envelope checks | Done |
| R2 | Conditional tail bound under explicit assumptions | Done (see exhibits) |
| R3 | Unconditional analytic bound weaker than RH | Target |
| R4 | Transfer derivation (ψ → π−Li) | Done (scaffold) |
| R5 | Error-bound source contract (external obligation) | Done |
| R6 | Instantiation record (bind R5 source into R4) | Done |
| R7 | Instantiated bound statement (tamper-evident) | Done |
| R8 | Comparison run (two-path consistency check) | Done |

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

### R6: Instantiation Record

R6 binds a specific R5 source into the R4 transfer template.

**Index:** [proof_artifacts/R6_INSTANTIATION/00_INDEX.md](proof_artifacts/R6_INSTANTIATION/00_INDEX.md)

**Selected source:** U1 (R5.1) — Unconditional ZFR-based ψ bound

**Purpose:**
- Records which E(t) source is used
- Threads the bound into R4's transfer template
- Keeps constants/thresholds as explicit debt

**Non-claims:**
- No RH claim
- No new analytic bounds
- Binding is a ledger artifact, not a proof

**Verification:** R6 packet integrity is checked by `VERIFY_R6_INSTANTIATION.sh`.

### R7: Instantiated Bound Statement

R7 provides the fully instantiated bound for |π(x) − Li(x)| with all terms explicit.

**Index:** [proof_artifacts/R7_BOUND_STATEMENT/00_INDEX.md](proof_artifacts/R7_BOUND_STATEMENT/00_INDEX.md)

**Structure:**
- Main bound with E(t), Δ_pp(x), C_boundary, R_{t₀}(x) all explicit
- Equation inventory (6 canonical equations)
- Hash check for tamper detection

**Non-claims:**
- No RH claim
- No new analytic bounds
- Constants/thresholds remain explicit debt

**Verification:** R7 packet integrity is checked by `VERIFY_R7_BOUND_STATEMENT.sh`.

### R8: Comparison Run

R8 provides a second construction path for the R7 bound statement and verifies byte-identical output.

**Index:** [proof_artifacts/R8_COMPARISON_RUN/00_INDEX.md](proof_artifacts/R8_COMPARISON_RUN/00_INDEX.md)

**Purpose:**
- Generator script regenerates R7 equations from R4+R6 inputs
- Comparison receipt proves byte-identical hash
- Guards against hallucinated extensions

**Non-claims:**
- No RH claim
- No new analytic bounds
- This is a mechanical consistency check

**Verification:** R8 packet integrity is checked by `VERIFY_R8_COMPARISON.sh`.

## We do not claim

- Unknowns remain debt
- Absence has meaning
- Review is governance, not omniscience
- Computational verification cannot substitute for analytic proof
