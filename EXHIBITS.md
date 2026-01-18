# Exhibits

## Canonical Run

| Field | Value |
|-------|-------|
| **Name** | `2026-01-17_dragon_boop_v1_x1000_step100_T50` |
| **Manifest Digest** | `8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729` |
| **Promotion Tier** | `PROMOTED_FINITE` |
| **Dragon Status** | `UNPAID` |
| **max_r_total** | 0.0296141010568821 |
| **worst_ratio_x** | 200 |
| **min_slack** | 206.8393759864528 |
| **worst_slack_x** | 100 |
| **a_max_allowed** | 33.76769728985602 |
| **paid_checkable** | 7 |
| **unpaid_theorem** | 2 |

## Artifact Locations

| Artifact | Path |
|----------|------|
| Canonical run | `experiments/rh_debt_ledger/paper_runs/2026-01-17_dragon_boop_v1_x1000_step100_T50/run/` |
| Paper runs index | `experiments/rh_debt_ledger/paper_runs/paper_runs_index.json` |
| Pointer file | `exhibits/canonical_run.json` |

## Verification

To verify the canonical run manifest:

```bash
cd experiments/rh_debt_ledger/paper_runs/2026-01-17_dragon_boop_v1_x1000_step100_T50/run
sha256sum sha256_manifest.txt
# Expected: 8b53653351f1625d3d2a59fae00b9c9b41a37ab9df3e9ad7a27de974945ef729
```
