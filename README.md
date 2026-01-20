# RH Debt Ledger

**VERIFY: 25/25 PASS**

## What This Is

A deterministic debt-ledger framework and verification ladder for Riemann Hypothesis computations. The paper and all proof artifacts are receipted, reproducible, and mechanically verifiable. This repository makes **no claim** of proving or verifying RH.

## Verify

**Quickstart:** See [VERIFY_QUICKSTART.md](VERIFY_QUICKSTART.md)

**Full verification:**
```bash
git clone https://github.com/VertRule/rh-debt-ledger-paper
cd rh-debt-ledger-paper
VR_STRICT=1 ./VERIFY.sh
```

Expected output: `=== VERIFICATION PASSED ===` with 25/25 checks.

## Read the Paper

- **PDF:** [`paper/main.pdf`](paper/main.pdf)
- **SHA256:** `a7286cdf77443c006e833f634c4ccc1e5ec447f280199a7648a8131eccf7e41e`
- **Digest file:** [`paper/main.pdf.sha256`](paper/main.pdf.sha256)

The digest is verified by `VERIFY.sh` step 24/25 (R25).

## Cite

**Zenodo Concept DOI** (recommended — always resolves to latest):
```
https://doi.org/10.5281/zenodo.18318663
```

**Zenodo Version DOI** (r28-zenodo-doi):
```
https://doi.org/10.5281/zenodo.18318664
```

**BibTeX:**
```bibtex
@software{ingle_2026_18318663,
  author       = {Ingle, David},
  title        = {{A Deterministic Debt-Ledger Framework for RH Verification}},
  month        = jan,
  year         = 2026,
  publisher    = {Zenodo},
  doi          = {10.5281/zenodo.18318663},
  url          = {https://doi.org/10.5281/zenodo.18318663}
}
```

**arXiv:** Pending endorsement.

## Non-Claims

- **Not a proof of RH** — this paper makes no such claim
- **Not a new bound** — no extension of known zero-verification bounds
- **Not RH verification** — no claim beyond known computational checks
- **Tail-bound obligation remains UNPAID** — the "dragon" is boxed, not slain

## Ladder Map

- **Rung index:** [RUNG_INDEX.md](RUNG_INDEX.md) — R4 through R29
- **Status ledger:** [STATUS.md](STATUS.md) — paid/unpaid obligations
- **Citation file:** [CITATION.cff](CITATION.cff) — machine-readable citation
