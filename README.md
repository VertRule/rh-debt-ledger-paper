# RH Debt Ledger Paper

Receipted NA0 Debt Ledgers for Riemann-Style Error Bounds.

## Scope

This paper describes a computational verification framework for evaluating the explicit formula error term in prime counting. The system produces deterministic, receipted artifacts that track all sources of debt and block false promotion to global claims.

**This framework does NOT prove the Riemann Hypothesis.**

## Key Claims

| ID | Statement | Support |
|----|-----------|---------|
| C1 | Debt is defined as D(x;T) = psi(x) - x - M_T(x) | Definitional |
| C5 | Repeated runs produce identical SHA-256 manifests | `tests/determinism.rs` |
| C11 | Canonical run tier is `PROMOTED_FINITE` with status `PAID_CONDITIONAL` | `run_metrics.json` |
| C12 | Global promotion blocked: dragon obligation `UNPAID` | `PO_TAIL_*.json` |

See the full claim ledger in `na0_rh_debt_ledger_draft.md`.

## Exhibits

See [EXHIBITS.md](EXHIBITS.md) for the canonical run table with manifest digests.

The `exhibits/` directory contains pointer files referencing reproducible artifacts in the experiment directory.

## Source Implementation

The implementation lives at `experiments/rh_debt_ledger/` in the main VertRule repository.

## Non-Claims

This paper explicitly does NOT claim:
- Any progress toward proving RH
- Any new analytic number theory results
- That the tail bounds used are unconditionally valid

All empirical results are conditioned on the assumptions declared in the tail-constants file.
