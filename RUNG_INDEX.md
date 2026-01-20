# Rung Index

**Concept-Tag:** RH-RUNG-INDEX

Map of the verification ladder (R4–R28).

| Rung | Name | Establishes | Does NOT Claim | Directory | Verifier | Release Tag |
|------|------|-------------|----------------|-----------|----------|-------------|
| R4 | Transfer Repro | Equation inventory for partial summation transfer | Proof correctness | `proof_artifacts/R4_TRANSFER_REPRO/` | `VERIFY_R4_TRANSFER.sh` | r4-transfer-repro |
| R5 | Error Bound Source | Menu of error bound components | Bound validity | `proof_artifacts/R5_ERROR_BOUND_SOURCE/` | `VERIFY_R5_ERROR_BOUND.sh` | r5-error-bound |
| R6 | Instantiation | Record of parameter choices | Optimality | `proof_artifacts/R6_INSTANTIATION/` | `VERIFY_R6_INSTANTIATION.sh` | r6-instantiation |
| R7 | Bound Statement | Explicit bound statement | RH | `proof_artifacts/R7_BOUND_STATEMENT/` | `VERIFY_R7_BOUND_STATEMENT.sh` | r7-bound-statement |
| R8 | Comparison Run | Regenerated equation inventory match | Correctness | `proof_artifacts/R8_COMPARISON_RUN/` | `VERIFY_R8_COMPARISON.sh` | r8-comparison |
| R9 | No-Surprise Assembly | Input manifest + digests frozen | Completeness | `proof_artifacts/R9_NO_SURPRISE_ASSEMBLY/` | `VERIFY_R9_NO_SURPRISE.sh` | r9-no-surprise |
| R10 | Assembly Receipt | Canonical assembly root hash | Proof | `proof_artifacts/R10_ASSEMBLY_RECEIPT/` | `VERIFY_R10_ASSEMBLY_RECEIPT.sh` | r10-assembly |
| R11 | Signature Envelope | Optional GPG signature layer | Key authenticity | `proof_artifacts/R11_SIGNATURE/` | `VERIFY_R11_SIGNATURE.sh` | r11-signature |
| R14 | Key Capture | GPG fingerprint receipts | Key validity | `proof_artifacts/R14_KEY_CAPTURE/` | `VERIFY_R14_KEY_CAPTURE.sh` | r14-key-capture |
| R15 | PQ Signature | Optional PQ signature envelope | PQ security | `proof_artifacts/R15_PQ_SIGNATURE/` | `VERIFY_R15_PQ_SIGNATURE.sh` | r15-pq-signature |
| R16 | PQ Tooling | PQ backend version receipt | Tool correctness | `proof_artifacts/R16_PQ_TOOLING/` | `VERIFY_R16_PQ_TOOLING.sh` | r16-pq-tooling |
| R17 | First PQ Ink | Real hybrid PQ signature | — | (uses R15) | (uses R15) | r17-first-hybrid-pq-signature |
| R18 | GPG Ink | Real GPG signature | — | (uses R11, R14) | (uses R11) | r18-gpg-signature-ink |
| R19 | Front Door | Quickstart documentation | — | `VERIFY_QUICKSTART.md` | — | r19-front-door-quickstart |
| R20 | Rebuild Assembly | Deterministic R10 root rebuild | Proof | `proof_artifacts/R20_REBUILD_ASSEMBLY_ROOT/` | `VERIFY_R20_REBUILD_ASSEMBLY_ROOT.sh` | r20-rebuild-r10-assembly-root |
| R21 | Release Zip Rebuild | Deterministic release zip from tag | — | `proof_artifacts/R21_RELEASE_ZIP_REBUILD/` | `VERIFY_R21_RELEASE_ZIP_REBUILD.sh` (local) | r21-release-zip-rebuild |
| R22 | Rung Index | Canonical ladder map + status ledger | — | `RUNG_INDEX.md`, `STATUS.md` | — | r22-rung-index-status |
| R23 | Paper Skeleton | LaTeX paper citing rungs | RH | `paper/` | — | r23-paper-skeleton |
| R24 | Paper Build | Deterministic PDF build | — | `proof_artifacts/R24_PAPER_BUILD/` | — | r24-paper-build |
| R25 | Paper Publish | Published PDF + sha256 digest | — | `paper/main.pdf` | VERIFY.sh step 24 | r25-publish-pdf |
| R26 | arXiv Kit | Deterministic arXiv source bundle | — | `proof_artifacts/R26_ARXIV_SUBMISSION/` | — | r26-arxiv-submission-kit |
| R27 | Endorsement Path | arXiv endorsement + alternate preprint docs | — | `proof_artifacts/R27_ENDORSEMENT_PATH/` | — | r27-endorsement-path |
| R28 | Zenodo DOI | Citable DOI via Zenodo | Peer review | `proof_artifacts/R28_ZENODO_DOI/` | — | r28-zenodo-doi |

## Verification Steps (23 total)

Steps 1–11: Git status, remote, required files, forbidden artifacts, redaction, exhibits, proof artifacts, contribution ledger
Steps 12–23: R4, R5, R6, R7, R8, R9, R10, R11, R14, R15, R16, R20

## Notes

- R12, R13 were internal policy rungs folded into R11/R14
- R17, R18, R19 are "ink" rungs that use existing infrastructure
- R21 verifier is local-only (not wired into CI)
