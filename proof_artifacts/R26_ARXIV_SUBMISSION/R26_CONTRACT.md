# R26 Contract

**Concept-Tag:** RH-R26-CONTRACT

## Establishes

1. A deterministic build script for arXiv source bundles.
2. Two runs of the script produce byte-identical zips.
3. The bundle contains only paper sources (no absolute paths, no binaries).
4. A submission checklist with moderator-risk awareness.

## Does NOT Claim

1. Proof of RH or any mathematical conjecture.
2. New bounds on π(x) or ψ(x).
3. Verification of RH beyond known computational checks.
4. Any "evidence suggesting" RH is true.

## Acceptance Criteria

- [ ] `scripts/build_arxiv_source_bundle.sh` produces deterministic zip
- [ ] Two consecutive runs produce identical SHA-256
- [ ] Bundle contains only: main.tex, sections/*.tex, bib.bib, any required .sty
- [ ] No absolute paths in any source file
- [ ] `VR_STRICT=1 ./VERIFY.sh` remains 24/24 PASS
- [ ] No new mathematical claims introduced

## Dependencies

- R25 (paper PDF published)
- R23 (paper skeleton)
