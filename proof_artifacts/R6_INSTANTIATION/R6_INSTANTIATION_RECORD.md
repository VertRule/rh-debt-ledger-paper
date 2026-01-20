# R6 Instantiation Record

**Concept-Tag:** RH-R6-INSTANTIATION-RECORD

## Selected Source

| Field | Value |
|-------|-------|
| **R5 Menu ID** | U1 (R5.1) |
| **Status** | UNCONDITIONAL |
| **Evidence** | [R5 Evidence §R5.1](../R5_ERROR_BOUND_SOURCE/evidence/EVIDENCE.md#id-r51) |

## Assumed Bound

For all t ∈ [t₀, x]:

```math
|\psi(t) - t| \leq E(t)
```

where E(t) is the ZFR-based error term as stated in Ivić (1985) Theorem 12.2:

```math
E(t) = O\left(t \cdot \exp\left(-c(\log t)^{3/5}(\log \log t)^{-1/5}\right)\right)
```

for some c > 0.

## Threshold Handling

| Item | Status |
|------|--------|
| t₀ value | **UNPAID** — source does not give explicit threshold |
| Below-threshold term R_{t₀}(x) | Remains explicit per R4 |

## Constants Handling

| Item | Status |
|------|--------|
| Constant c in E(t) | **UNPAID** — source states existence, not value |
| Implied constants in big-O | **UNPAID** — not reproduced |

## Threading into R4

**Target:** [proof_artifacts/R4_TRANSFER_REPRO/02_PSI_TO_PI_MINUS_LI_BOUND.md](../R4_TRANSFER_REPRO/02_PSI_TO_PI_MINUS_LI_BOUND.md)

**Substitution:** The bound E(t) above substitutes into the R4 transfer template:

```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + |C_{\text{boundary}}| + R_{t_0}(x)
```

**Remaining terms (unchanged from R4):**
- Δ_pp(x): prime-power correction (definition PAID, bound UNPAID)
- C_boundary: boundary constant (PAID)
- R_{t₀}(x): threshold remainder (structure PAID, value UNPAID)

## Debt Ledger

| Obligation | Status |
|------------|--------|
| Constants in E(t) | **UNPAID** |
| Threshold t₀ | **UNPAID** |
| Bound on Δ_pp(x) | **UNPAID** |
| RH-equivalent tail | **NOT APPLICABLE** — using unconditional source |

## Non-Claims

This instantiation record:
- Does not claim RH
- Does not assert specific numeric constants
- Does not prove the bound; it binds a cited source into the template
- Keeps all unpaid debt explicit
