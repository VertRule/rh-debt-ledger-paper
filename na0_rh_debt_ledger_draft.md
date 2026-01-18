# Receipted NA0 Debt Ledgers for Riemann-Style Error Bounds: Deterministic Experiments with Conditional Tail Budgets

**Status:** DRAFT
**Date:** 2026-01-17
**Canonical Run:** `2026-01-17_dragon_boop_v1_x1000_step100_T50`
**Manifest Digest:** `8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729`

---

## Abstract

We describe a computational verification framework for evaluating the explicit formula error term in prime counting. The system produces deterministic, receipted artifacts that track all sources of debt (truncation, arithmetic, numeric, model) and blocks false promotion to global claims. The central output is a **TailBoundReceipt** that certifies whether computed residuals fit within a target envelope over a finite domain, conditional on user-supplied tail bounds.

This framework does **not** prove the Riemann Hypothesis. It does **not** provide new theorems. It provides an auditable ledger of what has been computed, what assumptions were made, and what obligations remain unresolved. The key engineering contribution is a deterministic pipeline with canonical tie-breaking (scaled-int quantization with banker's rounding), drift-detection via policy digests, and monotonicity-preserving stability invariants.

**Promotion to global proof remains blocked without an independent tail theorem.**

The system produces runs with status `PAID_CONDITIONAL` when tail bounds are supplied with declared assumptions (e.g., RH true). These runs achieve tier `PROMOTED_FINITE` over the declared domain but cannot advance to `PROMOTED_GLOBAL` without unconditional resolution of the tail debt.

---

## 1. Introduction

The prime counting function $\psi(x) = \sum_{p^k \le x} \log p$ admits an explicit formula involving the non-trivial zeros of the Riemann zeta function. When truncated at height $T$, the formula leaves a tail contribution that cannot be computed exactly. This tail is the primary source of debt in any finite verification.

### 1.1 Motivation

Explicit formula computations are well-studied, but verification artifacts are often ad-hoc: output files without checksums, undeclared smoothing, implicit assumptions about zero locations. This creates governance problems:

1. **Reproducibility:** Can the same inputs produce the same outputs on different machines?
2. **Assumption tracking:** Which results depend on RH being true?
3. **Promotion blocking:** What prevents a finite-domain success from being misrepresented as a global proof?

The NA0 debt ledger addresses these by making every debt category explicit and blocking promotion until obligations are resolved.

### 1.2 Non-Claims

This paper explicitly does **not** claim:

- Any progress toward proving RH
- Any new analytic number theory results
- That the tail bounds used are unconditionally valid

All empirical results are conditioned on the assumptions declared in the tail-constants file.

### 1.3 Claim Taxonomy

The framework enforces a strict taxonomy of claims:

| Class | Description | Promotion Allowed |
|-------|-------------|-------------------|
| **Definition** | Mathematical definitions and schema semantics (e.g., "debt is $D(x;T) = \psi(x) - x - M_T(x)$") | Always |
| **Finite-domain certified** | Empirical results verified over a sampled grid with conditional tail bounds | `PROMOTED_FINITE` |
| **Global** | Statements about all $x$ without conditionality on unproven theorems | `PROMOTED_GLOBAL` |

**Rule:** No empirical result is promoted beyond its tier. A finite-domain certified claim cannot be cited as evidence for global behavior without explicitly stating the conditionality and the unresolved obligations.

---

## 2. Definitions

### 2.1 The Explicit Formula and Debt

Let $\psi(x)$ be computed exactly via prime sieve. The truncated model is:

$$
M_T(x) = -\sum_{|\gamma| \le T} \frac{x^{1/2 + i\gamma}}{1/2 + i\gamma} - \log(2\pi) - \frac{1}{2}\log(1 - x^{-2})
$$

where $\gamma$ are the imaginary parts of non-trivial zeros $\rho = 1/2 + i\gamma$ (assuming RH).

The **debt** is:

$$
D(x; T) = \psi(x) - x - M_T(x)
$$

### 2.2 Envelope and Ratio

The target envelope for RH-style bounds is:

$$
E(x) = C \sqrt{x} \log^2 x
$$

with default $C = 1$. The **ratio** is:

$$
r(x) = \frac{|D(x; T)|}{E(x)}
$$

When tail bounds are included, the **total ratio** is:

$$
r_{\text{total}}(x) = \frac{|D(x; T)| + R_{\text{tail}}(x)}{E(x)}
$$

### 2.3 Tail Bound and R_tail

Given user constants $(A, p, f(T))$ from a theorem reference, the tail remainder is bounded as:

$$
R_{\text{tail}}(x) = A \cdot \sqrt{x} \cdot (\log x)^p \cdot f(T)
$$

where $f(T)$ is one of: $1/T$ (`inv_T`), $1/\sqrt{T}$ (`inv_sqrtT`), or $e^{-\sigma^2 T^2}$ (`exp_minus_sigma2T2`).

### 2.4 TailBoundReceipt Semantics

| Status | Meaning |
|--------|---------|
| `UNPAID` | No tail bound provided; tail debt remains open |
| `PAID_CONDITIONAL` | Tail bound provided with declared assumptions; conditionally paid |
| `PAID` | Tail bound provided with unconditional theorem (currently unreachable) |

### 2.5 Promotion Tiers

| Tier | Meaning |
|------|---------|
| `UNPROMOTED` | Either `UNPAID` or `PAID_CONDITIONAL` but failed domain check |
| `PROMOTED_FINITE` | `PAID_CONDITIONAL` and $r_{\text{total}}(x) < 1$ for all $x$ in domain |
| `PROMOTED_GLOBAL` | Requires unconditional tail theorem (currently unreachable) |

---

## 3. System Design

### 3.1 Deterministic Pipeline

The pipeline is implemented in Rust with the following invariants:

1. **No nondeterminism:** No `HashMap` iteration, no time-based values, no floating-point comparison ties resolved by platform-specific behavior.
2. **Canonical JSON:** All output uses deterministic field ordering via `serde_json`.
3. **Fixed-precision formatting:** All floats formatted to 16 decimal places.

### 3.2 Artifact Set

Each run produces:

| File | Purpose |
|------|---------|
| `run_config.json` | Canonical configuration with all parameters |
| `zeros_used.csv` | Zeros filtered by $|\gamma| \le T$ |
| `series.csv` | Per-$x$ computed values including debt, ratio, R_tail |
| `summary.json` | Argmax locations and extreme values |
| `TailBoundReceipt.json` | Promotion status, tail budget, allowlist validation |
| `RECEIPT.md` | Human-readable summary |
| `sha256_manifest.txt` | SHA-256 hashes of all artifacts |
| `run_metrics.json` | Machine-readable metrics for dashboards |

### 3.3 Arg Selection Policy

Tie-breaking for argmax/argmin uses scaled integer quantization:

- **Policy kind:** `scaled_int_round_to_even`
- **Scale for r_total:** $10^{18}$
- **Scale for slack:** $10^{12}$
- **Tie-breaking:** Smallest $x$ wins when quantized values are equal

The policy is serialized and hashed. The canonical digest is:

```
b11f169c44abf3aed15e80f43aba17dc2586d06ff434fcbc32d63f26d057b846
```

This digest is embedded in every `TailBoundReceipt.json` under `tail_budget.arg_policy_digest`.

---

## 4. Dragon Obligation Formalism

The tail debt is partitioned into two assumption classes:

1. **CHECKABLE assumptions** (C1–C7): Mechanically verifiable conditions paid by code execution. These include allowlist membership, policy digest matching, schema bounds validation, domain compatibility, artifact integrity, deterministic arg selection, and finite-domain certification.

2. **THEOREM assumptions** (T1–T2): Claims requiring external mathematical proof that cannot be verified computationally. These include the validity of the tail bound formula (`TailBoundTheoremValidity`) and analytic preconditions on zero distribution (`AnalyticPreconditions`).

The canonical run pays all 7 CHECKABLE assumptions. The only remaining blocker for `PROMOTED_GLOBAL` is the **dragon obligation**:

> **TailBoundTheoremValidity:** "The tail bound form and constants are valid for all x and T in the declared domain under the THEOREM assumptions."

This obligation depends on assumptions T1 and T2 and has status `UNPAID`. It is recorded in the proof obligation file `PO_TAIL_c0bc0a5ca0518f9f.json` under `dragon_obligation`. The promotion gate specifies:

- `tier_max_without_dragon`: `PROMOTED_FINITE`
- `tier_requires_dragon`: `PROMOTED_GLOBAL`

No computational verification can pay this obligation. It requires an external proof artifact that establishes the tail bound unconditionally. The top rung remains RH-hard; we therefore track a ladder of weaker global targets with explicit obligations (see `vr-rh-debt-ledger scan-ladder`). External proofs can be bound to specific rungs via `--bind-proof`, with acceptance gated by policy (default: reject).

External proofs are stored, digested, and review-gated. Acceptance requires: (1) the accept gate enabled in the allowlist, (2) the proof digest explicitly allowlisted, (3) a quorum of approving reviews from allowlisted reviewers, and (4) zero rejections. Even when all gates pass and `accepted=true`, global promotion remains disabled by default (`allow_global_promotion_with_external_proof: false`). The tier cannot exceed `PROMOTED_FINITE` without explicitly enabling that final gate.

---

## 5. Experiments (Finite Domain)

### 5.1 Reproducibility Contract

To reproduce the canonical run:

```bash
cd experiments/rh_debt_ledger

cargo build --release

./target/release/vr-rh-debt-ledger run \
  --x-max 1000 \
  --x-step 100 \
  --t-max 50.0 \
  --zeros fixtures/zeros_small.csv \
  --tail-bound-policy user-constants \
  --tail-constants fixtures/tail_constants_pass.json \
  --global-claim envelope-rh-style \
  --out /tmp/repro_run
```

**Expected artifacts in output directory:**

- `run_config.json`
- `zeros_used.csv`
- `series.csv`
- `summary.json`
- `TailBoundReceipt.json`
- `RECEIPT.md`
- `sha256_manifest.txt`
- `run_metrics.json`
- `proof_obligations/PO_TAIL_*.json`
- `analysis/assumption_check_report.json`

**Integrity verification:**

1. Compute `sha256sum sha256_manifest.txt`
2. Compare to recorded manifest digest: `8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729`

The `paper_runs_index.json` at `experiments/rh_debt_ledger/paper_runs/` provides a convenience index of all frozen runs with their manifest digests.

### 5.2 Canonical Run Evidence

> **Run:** `2026-01-17_dragon_boop_v1_x1000_step100_T50`
>
> | Metric | Value | Source |
> |--------|-------|--------|
> | **manifest_digest** | `8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729` | `paper_runs_index.json` |
> | **promotion_tier** | `PROMOTED_FINITE` | `run_metrics.json` |
> | **max_r_total** | 0.0296141010568821 | `run_metrics.json` |
> | **worst_ratio_x** | 200 | `run_metrics.json` |
> | **min_slack** | 206.8393759864528 | `run_metrics.json` |
> | **worst_slack_x** | 100 | `run_metrics.json` |
> | **a_max_allowed** | 33.76769728985602 | `run_metrics.json` |
> | **paid_checkable** | 7 | `run_metrics.json` |
> | **unpaid_theorem** | 2 | `run_metrics.json` |
> | **dragon_status** | `UNPAID` | `run_metrics.json` |
>
> **Artifact path:** `experiments/rh_debt_ledger/paper_runs/2026-01-17_dragon_boop_v1_x1000_step100_T50/run/`

### 5.3 Determinism Evidence

The `sha256_manifest.txt` from the canonical run:

```
178a1790e7b5cb1e2ff614c8ef243707501a36aacec183e9a14c5e3ff993283f  run_config.json
2513d21c1db10d53aa2df0751467b2e500cd0b1701d3ec365311b7bb6ceba4ab  zeros_used.csv
6d61ce804c0c6fdd3a137ab1599c2139ca5a7d42dfdb2cd0d10fb8f091aedcfb  series.csv
eb51e8bcebc9fd5418c5ef5c7289b0653b0b5e4980cee0a40a42af48560064f3  summary.json
15cec9a113250890949c00c1c95fbfadabced51e72a11ac2024d12c36d11d3b9  TailBoundReceipt.json
18b5fd36565f6cb3413ca0772a5d5358ed70d3b9dcec68d8af978ab7476b672f  RECEIPT.md
```

Repeated runs with identical inputs produce identical manifests (enforced by `tests/determinism.rs`).

---

## 6. Stability Invariants

### 6.1 Monotonicity over T

The test suite (`tests/tail_budget_monotonicity.rs`) enforces:

| Invariant | Statement |
|-----------|-----------|
| M1 | $a_{\max}(T_2) \ge a_{\max}(T_1)$ for $T_2 > T_1$ |
| M2 | $\text{min\_slack}(T_2) \ge \text{min\_slack}(T_1)$ for $T_2 > T_1$ |
| M3 | $r_{\text{total,max}}(T_2) \le r_{\text{total,max}}(T_1)$ for $T_2 > T_1$ |
| M4 | Promotion tier never decreases with increasing $T$ |

**T-sweep results (x_max=2000, x_step=100):**

| T | a_max_allowed | min_slack | max_r_total | worst_ratio_x | worst_slack_x | tier |
|---|---------------|-----------|-------------|---------------|---------------|------|
| 30 | 20.2558957210 | 203.1387671006 | 0.0493683426 | 200 | 100 | PROMOTED_FINITE |
| 50 | 33.7676972899 | 206.8393759865 | 0.0296141011 | 200 | 100 | PROMOTED_FINITE |
| 77 | 49.0759268898 | 207.7545404360 | 0.0203765892 | 100 | 100 | PROMOTED_FINITE |

### 6.2 Tie-Breaking Determinism

The golden fixture `fixtures/arg_policy_v1.json`:

```json
{"kind":"scaled_int_round_to_even","scale_r":"1e18","scale_slack":"1e12"}
```

The test `test_arg_policy_digest_matches_golden` verifies the digest remains `b11f169c...`. Any change to the policy triggers drift detection.

---

## 7. Failure Modes and Anti-Laundering

The system prevents "tail laundering" (paying tail debt with arbitrary constants) through multiple gates:

1. **Allowlist required:** The `theorem_ref` must appear in `governance/allowlists/tail_theorems_v1.json`. Unrecognized theorem references cause C1 (AllowlistMembership) to fail.

2. **Policy digest match:** The arg selection policy digest must match the allowlist-mandated value. This prevents unauthorized parameter drift (C2).

3. **T_min validation:** The tail constants file specifies `T_min`. If the run's `t_max` is less than `T_min`, the run fails with "Tail bound validation failed: T_max < T_min from tail constants." This blocks use of tail bounds outside their declared validity range.

4. **Schema bounds:** Constants $(A, p, f_T)$ must satisfy schema constraints (C3).

5. **Proof artifacts gated:** External proof artifacts (PDFs, etc.) can be attached via `--proof-artifact`, but acceptance is controlled by `governance/allowlists/proof_artifacts_v1.json`. By default, `accept_external_proof_for_theorem_assumptions: false`—artifacts are recorded and digested but do not change obligation status.

These gates ensure that achieving `PROMOTED_FINITE` requires both passing all CHECKABLE assumptions and using governance-approved constants within their valid domain.

---

## 8. Prior Art Positioning

Explicit formula computations and RH-consistent numerics are standard in computational number theory. The framework described here does not introduce new analytic results.

The contribution is **governance infrastructure**: deterministic artifact generation, receipted debt tracking, promotion tier enforcement, and assumption splitting into CHECKABLE vs THEOREM classes. The goal is auditability—making explicit what is computed, what is assumed, and what remains unpaid—not mathematical novelty.

---

## 9. Limitations

### 9.1 This Does Not Prove RH

**This framework does not prove the Riemann Hypothesis.** The `PROMOTED_FINITE` tier certifies only that computed residuals fit within the envelope over the sampled grid, conditional on declared assumptions (including RH itself). The dragon obligation remains `UNPAID`.

### 9.2 Tail Theorem Not Provided

**Promotion to global proof remains blocked without an independent tail theorem.**

The `PAID_CONDITIONAL` status means the tail bound formula was supplied by the user with declared assumptions (typically "RH is true"). This is governance-paid (the framework accepts the obligation), not mathematically paid. The proof obligation file in `proof_obligations/` specifies what theorem would be required.

### 9.3 Conditionality

All results with status `PAID_CONDITIONAL` are conditional on:

1. RH is true
2. All zeros used lie on the critical line
3. The tail bound formula is valid for the stated domain

If any assumption is false, the certification is void.

### 9.4 Finite Grid vs All x

Certification applies only to the sampled grid points:

$$
x \in \{x_{\text{step}}, 2 \cdot x_{\text{step}}, \ldots, x_{\max}\}
$$

The statement "For all $x$ in domain" means "for all sampled $x$ in the grid," not "for all real $x$."

### 9.5 Numeric Precision

Computations use IEEE 754 double precision (f64). The debt category `Debt.Numeric` is marked `PAID` based on:

- Fixed formatting to 16 decimals
- Canonical tie-breaking via scaled i128 quantization
- No platform-dependent floating-point comparison

This does not guarantee arbitrary precision; it guarantees reproducibility within f64 limits.

---

## 10. Discussion

### 10.1 Reduction to Single Proof Obligation

The framework reduces the verification problem to a single file: the proof obligation `PO_TAIL_c0bc0a5ca0518f9f.json`. This file specifies:

- Required theorem family (e.g., "Tail bound with ft_kind=inv_T, p=2")
- Required assumptions to be proven unconditionally
- Bounds on constants $(A, p, T_{\min})$ that would suffice
- Domain over which the obligation applies

A successful resolution of this obligation (providing an unconditional tail theorem with compatible constants) would change status from `PAID_CONDITIONAL` to `PAID` and tier from `PROMOTED_FINITE` to `PROMOTED_GLOBAL`.

### 10.2 Audit-Grade Artifacts

The SHA-256 manifest provides tamper-evidence. The canonical arg selection policy digest provides drift detection. Together, they turn "proof attempts" into auditable obligations:

1. **Verifiable:** Anyone can re-run with the same inputs and get the same manifest.
2. **Attributable:** The assumptions are explicit in `TailBoundReceipt.json`.
3. **Blockable:** False promotion to `PROMOTED_GLOBAL` is structurally prevented.

---

## 11. Claim Ledger

| ID | Statement | Support | Scope | Promotion |
|----|-----------|---------|-------|-----------|
| C1 | Debt is defined as $D(x;T) = \psi(x) - x - M_T(x)$ | `src/lib.rs` | Definitional | — |
| C2 | The envelope ratio is $r(x) = |D|/(\sqrt{x}\log^2 x)$ | `src/lib.rs` | Definitional | — |
| C3 | Status `PAID_CONDITIONAL` means tail bound supplied with assumptions | `src/lib.rs` | Definitional | — |
| C4 | Tier `PROMOTED_FINITE` requires $r_{\text{total}} < 1$ for all sampled $x$ | `src/lib.rs` | Definitional | — |
| C5 | Repeated runs produce identical SHA-256 manifests | `tests/determinism.rs` | Engineering | — |
| C6 | Arg selection uses scaled-int quantization with banker's rounding | `src/analysis/arg_policy.rs` | Engineering | — |
| C7 | Policy digest `b11f169c...` is stable across runs | `tests/tail_budget_monotonicity.rs` | Engineering | — |
| C8 | Monotonicity invariants hold: $a_{\max}$ increases with $T$ | `tests/tail_budget_monotonicity.rs` | Engineering | — |
| C9 | Canonical run achieves $\max r_{\text{total}} = 0.0296$ at $x=200$ | `run_metrics.json` | Empirical | Finite |
| C10 | Canonical run achieves $\min\_slack = 206.84$ at $x=100$ | `run_metrics.json` | Empirical | Finite |
| C11 | Canonical run tier is `PROMOTED_FINITE` with status `PAID_CONDITIONAL` | `run_metrics.json` | Empirical | Finite |
| C12 | Global promotion blocked: dragon obligation `UNPAID` | `PO_TAIL_*.json` | Engineering | — |

---

## How to Cite This Run

When referencing the canonical run:

> Run `2026-01-17_dragon_boop_v1_x1000_step100_T50`, manifest digest `8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729`, tier `PROMOTED_FINITE`, dragon status `UNPAID`.

---

## Appendix A: CLI Commands

```bash
# Run the debt ledger
./target/release/vr-rh-debt-ledger run \
  --x-max 1000 \
  --x-step 100 \
  --t-max 50.0 \
  --zeros fixtures/zeros_small.csv \
  --tail-bound-policy user-constants \
  --tail-constants fixtures/tail_constants_pass.json \
  --global-claim envelope-rh-style \
  --out /tmp/my_run

# Freeze a run for paper citation
./target/release/vr-freeze-paper-run \
  --src /tmp/my_run \
  --name "YYYY-MM-DD_description" \
  --dest paper_runs

# Build paper runs index
./target/release/vr-metrics-index build \
  --paper-runs paper_runs \
  --out paper_runs/paper_runs_index.json

# Run tests
cargo test --release
```

## Appendix B: Schema Excerpts

### TailBudget (from TailBoundReceipt.json)

```json
{
  "arg_policy_digest": "b11f169c44abf3aed15e80f43aba17dc2586d06ff434fcbc32d63f26d057b846",
  "target_c": 1.0,
  "max_r_total": "0.0296141010568821",
  "worst_ratio_x": 200,
  "a_max_allowed": "33.7676972898560166",
  "min_slack": "206.8393759864528079",
  "worst_slack_x": 100,
  "headroom_factor": "33.7676972898560166"
}
```

### run_metrics.json (excerpt)

```json
{
  "schema": "rh_debt_ledger.run_metrics.v1",
  "promotion": {
    "tier": "PROMOTED_FINITE",
    "eligible_for_global_claim": true,
    "assumption_classes": {
      "paid_checkable": 7,
      "unpaid_theorem": 2
    },
    "dragon_obligation_status": "UNPAID"
  },
  "tail_budget": {
    "max_r_total": 0.0296141010568821,
    "worst_ratio_x": 200,
    "min_slack": 206.8393759864528,
    "a_max_allowed": 33.76769728985602
  }
}
```

---

## Acknowledgments

Drafting and repository scaffolding were assisted by large language model tools; all technical claims and final wording were reviewed and approved by the author.

---

## References

- Schoenfeld, L. (1976). Sharper bounds for the Chebyshev functions θ(x) and ψ(x). II. *Mathematics of Computation*, 30(134), 337-360.
- Implementation: `experiments/rh_debt_ledger/` in the VertRule repository
