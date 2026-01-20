# Fork Decision Receipt

**Concept-Tag:** RH-R4-FORK-DECISION

## Claim

For R4 transfer reproduction, proceed via ψ as the primary lane; treat θ as an optional cross-check lane.

## Context

The transfer step from Chebyshev-type bounds to π(x)−Li(x) can be phrased via either:
- **ψ(x)**: the second Chebyshev function (sum over prime powers)
- **θ(x)**: the first Chebyshev function (sum over primes only)

Both are related by ψ(x) = θ(x) + θ(x^{1/2}) + θ(x^{1/3}) + ..., but introduce different seams in the transfer derivation. The ψ-lane requires explicit handling of prime-power corrections; the θ-lane avoids them but may obscure the structure.

## Construction

**Lane A (primary):** ψ → π−Li using partial summation/Stieltjes with explicit Δ_pp(x) term.
- Derivation files 01_PARTIAL_SUMMATION.md and 02_PSI_TO_PI_MINUS_LI_BOUND.md follow this lane.
- Prime-power correction Δ_pp(x) is named and tracked as explicit debt.

**Lane B (shadow):** θ-based transfer noted for cross-check; not expanded in this packet.
- May be added as a parallel derivation in future if needed for verification.

## Evidence

- Partial summation identity: see [evidence/EVIDENCE.md#id-r43](evidence/EVIDENCE.md#id-r43)
- Prime-power correction definition: see [evidence/EVIDENCE.md#id-r41](evidence/EVIDENCE.md#id-r41)

No new citations added by this receipt.

## Policy

- No hidden conversion: prime-power correction is named Δ_pp(x) and stays explicit until paid.
- No constants. No "sufficiently large". No RH claim.

## Result

R4 derivation files should use ψ-lane notation by default.

## NA0 Debt Ledger

| Item | Status |
|------|--------|
| Δ_pp(x) bound | Named but not bounded (R4.1 CITED) |
| Boundary O(1) terms | TODO (R4.4) |
| Threshold requirements | TODO (R4.5) |
