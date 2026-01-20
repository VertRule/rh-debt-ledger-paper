# R5 Evidence Ledger

**Concept-Tag:** RH-R5-EVIDENCE-LEDGER

## Purpose

This ledger records citations supporting the E(t) sources in R5_MENU.md.

---

### ID R5.1

**Task:** Add citations for unconditional zero-free-region-based ψ bound

**Status:** CITED

**Citations:**

1. **de la Vallée Poussin (1896)** — Original zero-free region and PNT
   - de la Vallée Poussin, C.-J. (1896). "Recherches analytiques sur la théorie des nombres premiers." *Annales de la Société scientifique de Bruxelles* 20: 183–256.
   - Establishes ζ(s) ≠ 0 for Re(s) = 1, yielding |ψ(x) − x| = o(x).

2. **Korobov (1958)** — Improved zero-free region
   - Korobov, N. M. (1958). "Estimates of trigonometric sums and their applications." *Uspekhi Mat. Nauk* 13(4): 185–192.
   - Zero-free region: σ > 1 − c/(log|t|)^{2/3}(log log|t|)^{1/3}.

3. **Vinogradov (1958)** — Independent discovery of improved region
   - Vinogradov, I. M. (1958). "A new estimate of the function ζ(1+it)." *Izv. Akad. Nauk SSSR Ser. Mat.* 22: 161–164.
   - Same zero-free region as Korobov, independently derived.

4. **Ivić (1985)** — Modern source stating ψ error term explicitly
   - Ivić, A. (1985). *The Riemann Zeta-Function*. Wiley, New York. Chapter 12.
   - Theorem 12.2: States the PNT error term derived from Korobov–Vinogradov region:
     |ψ(x) − x| = O(x · exp(−c(log x)^{3/5}(log log x)^{−1/5})) for some c > 0.

**What these citations support:**
- Zero-free region: Korobov (1958), Vinogradov (1958)
- Error term shape for ψ(x): Ivić (1985) Theorem 12.2 (explicitly stated)
- Unconditional nature (no hypothesis assumed)
- Constants c not reproduced; full derivation EXTERNAL-CITED

---

### ID R5.2

**Task:** Add citations for RH-conditional ψ bound shape

**Status:** CITED

**Citations:**

1. **von Koch (1901)** — First proof that RH implies |ψ(x) − x| = O(√x log²x)
   - von Koch, H. (1901). "Sur la distribution des nombres premiers." *Acta Mathematica* 24: 159–182.
   - Establishes the conditional error term shape under RH.

2. **Schoenfeld (1976)** — Explicit constants for RH-conditional bounds
   - Schoenfeld, L. (1976). "Sharper bounds for the Chebyshev functions θ(x) and ψ(x). II." *Mathematics of Computation* 30(134): 337–360.
   - Theorem 10: Under RH, |ψ(x) − x| < (1/8π)√x log²x for x ≥ 73.2.

**What these citations support:**
- Menu item C1 (RH-conditional source) shape: E_RH(t) = O(√t log²t)
- The conditional nature (assumes RH)
- Explicit constant form available (Schoenfeld)
