# Exhibits

## Assumption Support Demo

| Field | Value |
|-------|-------|
| **Name** | `2026-01-19_assumption_support_v1_demo` |
| **Manifest Digest** | `sha256:6818f800cb783741ccbfb4db5cff797c8c62d87d66e297ad5c31cf44b2fa1183` |
| **Purpose** | Assumption support receipts (minimum support set) demo |
| **Method** | `deterministic_greedy_prune_v1` |

## Canonical Run

| Field | Value |
|-------|-------|
| **Name** | `2026-01-19_canonical_v2_x1000_step100_T50_governance_threaded` |
| **Manifest Digest** | `564663aa25fc3c8f3463a850fb97f5ea80afe2dc0a641db5dd52fdef3ca1dd73` |
| **Promotion Tier** | `PROMOTED_FINITE` |
| **Dragon Status** | `UNPAID` |
| **max_r_total** | 0.0296141010568821 |
| **worst_ratio_x** | 200 |
| **min_slack** | 206.8393759864528 |
| **worst_slack_x** | 100 |
| **a_max_allowed** | 33.76769728985602 |
| **paid_checkable** | 7 |
| **unpaid_theorem** | 2 |
| **theorem_registry_digest** | `sha256:a75b757e57d7e3423a6a469864184617c2a5f8ac753e0c05a100cee0a408c755` |
| **trusted_allowlist_digest** | `sha256:f9136164f930551623cb07ed48b86df2356d06930e7de83687a3b8782c83e4bb` |
| **trusted_global_enabled** | false |

## Artifact Locations

| Artifact | Path |
|----------|------|
| Assumption support demo | `experiments/rh_debt_ledger/paper_runs/2026-01-19_assumption_support_v1_demo/run/` |
| Canonical run | `experiments/rh_debt_ledger/paper_runs/2026-01-19_canonical_v2_x1000_step100_T50_governance_threaded/run/` |
| Paper runs index | `experiments/rh_debt_ledger/paper_runs/paper_runs_index.json` |
| Pointer file (assumption support) | `exhibits/assumption_support_demo.json` |
| Pointer file (canonical) | `exhibits/canonical_run.json` |

## Verification

To verify the canonical run manifest:

```bash
cd experiments/rh_debt_ledger/paper_runs/2026-01-19_canonical_v2_x1000_step100_T50_governance_threaded/run
sha256sum sha256_manifest.txt
# Expected: 564663aa25fc3c8f3463a850fb97f5ea80afe2dc0a641db5dd52fdef3ca1dd73
```
