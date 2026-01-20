# R7: Instantiated Bound Statement

**Concept-Tag:** RH-R7-BOUND-STATEMENT

## Provenance

This bound is assembled from:
- **R4:** Transfer template ([02_PSI_TO_PI_MINUS_LI_BOUND.md](../R4_TRANSFER_REPRO/02_PSI_TO_PI_MINUS_LI_BOUND.md))
- **R5:** Error-bound source menu ([R5_MENU.md](../R5_ERROR_BOUND_SOURCE/R5_MENU.md))
- **R6:** Instantiation record ([R6_INSTANTIATION_RECORD.md](../R6_INSTANTIATION/R6_INSTANTIATION_RECORD.md))

## Selected Source

| Field | Value |
|-------|-------|
| **R5 Menu ID** | U1 (R5.1) |
| **Status** | UNCONDITIONAL |
| **Bound shape** | Ivić (1985) Theorem 12.2 |

---

## The Instantiated Bound

For x ≥ t₀:

<!-- BOUND-R7-MAIN -->
```math
|\pi(x) - \text{Li}(x)| \leq \frac{E(x)}{\log x} + \int_{t_0}^x \frac{E(t)}{t (\log t)^2} \, dt + |\Delta_{pp}(x)| + |C_{\text{boundary}}| + R_{t_0}(x)
```

where:

---

### Term 1: E(t) — The Error Bound

<!-- TERM-R7-E -->
```math
E(t) = O\left(t \cdot \exp\left(-c(\log t)^{3/5}(\log \log t)^{-1/5}\right)\right)
```

| Item | Status |
|------|--------|
| Source | Ivić (1985) Theorem 12.2 (Korobov–Vinogradov region) |
| Constant c | **UNPAID** — existence stated, value not reproduced |
| Conditionality | **UNCONDITIONAL** |

---

### Term 2: Δ_pp(x) — Prime-Power Correction

<!-- TERM-R7-DELTA-PP -->
```math
\Delta_{pp}(x) := \frac{R_{pp}(x)}{\log x} = \frac{\psi(x) - \theta(x)}{\log x}
```

where:

```math
R_{pp}(x) = \sum_{k \geq 2} \sum_{p^k \leq x} \log p
```

| Item | Status |
|------|--------|
| Definition | **PAID** — see [04_DELTA_PP_DEFINITION.md](../R4_TRANSFER_REPRO/04_DELTA_PP_DEFINITION.md) |
| Bound | **UNPAID** — magnitude depends on θ(x^{1/2}) + θ(x^{1/3}) + ... |

---

### Term 3: C_boundary — Boundary Constant

<!-- TERM-R7-C-BOUNDARY -->
```math
C_{\text{boundary}} := -\frac{\psi(2)}{\log 2} + \frac{2}{\log 2} = -1 + \frac{2}{\log 2}
```

| Item | Status |
|------|--------|
| Definition | **PAID** — see [05_BOUNDARY_TERMS_RECEIPT.md](../R4_TRANSFER_REPRO/05_BOUNDARY_TERMS_RECEIPT.md) |
| Numeric value | Approximately 1.885 (symbolic form retained) |

---

### Term 4: R_{t₀}(x) — Threshold Remainder

<!-- TERM-R7-R-T0 -->
```math
R_{t_0}(x) := \int_2^{t_0} \frac{|\psi(t) - t|}{t (\log t)^2} \, dt + \frac{|\psi(t_0) - t_0|}{\log t_0}
```

| Item | Status |
|------|--------|
| Structure | **PAID** — see [06_THRESHOLD_REQUIREMENTS_RECEIPT.md](../R4_TRANSFER_REPRO/06_THRESHOLD_REQUIREMENTS_RECEIPT.md) |
| Value of t₀ | **UNPAID** — depends on E(t) source threshold |
| Evaluation | **UNPAID** — requires fixing t₀ |

---

## Debt Ledger Summary

| Obligation | Status |
|------------|--------|
| E(t) existence | **CITED** (Ivić Thm 12.2) |
| E(t) constant c | **UNPAID** |
| Threshold t₀ | **UNPAID** |
| Δ_pp(x) bound | **UNPAID** |
| C_boundary | **PAID** (symbolic) |
| R_{t₀}(x) structure | **PAID** |
| R_{t₀}(x) value | **UNPAID** |
| RH-equivalent obligation | **NOT APPLICABLE** (unconditional source) |

---

## Non-Claims

This statement:
- Does not claim RH
- Does not assert specific numeric constants for c or t₀
- Does not bound Δ_pp(x)
- Is a ledger artifact recording what has been assembled, not a complete proof
