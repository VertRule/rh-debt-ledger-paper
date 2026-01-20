# Status Ledger

**Concept-Tag:** RH-STATUS-LEDGER

## Current Rung

**R32** — Tighten no-token-leak verifier

## Paper Draft

Location: `paper/` (R23)

The paper skeleton documents the verification ladder and debt framing without claiming RH.

## Paid Obligations

| Lane | Status | Rung | Notes |
|------|--------|------|-------|
| Classical signature (GPG) | PAID | R18 | Dave's detached signature over R10_ASSEMBLY_ROOT.txt |
| PQ hybrid signature | PAID | R17 | p384_mldsa65 signature (P-384 + ML-DSA-65) |
| Assembly root rebuild | PAID | R20 | Deterministic regeneration from verify surface |
| Release reproducibility | PAID | R21 | Deterministic zip rebuild from git tag |
| Key fingerprint capture | PAID | R14 | GPG fingerprint recorded |
| PQ tooling receipt | PAID | R16 | Backend + version captured |
| Zenodo DOI | PAID | R28 | Concept DOI: 10.5281/zenodo.18318663 |

## Distribution

| Platform | Status | Notes |
|----------|--------|-------|
| Zenodo | LIVE | DOI: 10.5281/zenodo.18318663 |
| arXiv | PENDING | Pending endorsement (tokens handled privately; no public links) |

## Remaining Obligations

| Item | Status | Notes |
|------|--------|-------|
| Tail bound proof | UNPAID | The dragon is boxed, not slain |
| RH claim | NOT MADE | This repo makes no claim regarding RH |
| Proof reproduction | NOT DONE | No proofs are reproduced |
| External audit | NOT DONE | Third-party review pending |

## Verification Commands

**Baseline verification (25 steps):**
```bash
VR_STRICT=1 ./VERIFY.sh
```

**Rebuild release zip from tag:**
```bash
./scripts/rebuild_release_zip.sh <tag> /tmp/rebuilt.zip
```

**Verify rebuild determinism:**
```bash
./VERIFY_R21_RELEASE_ZIP_REBUILD.sh <tag>
```

**Full GPG verification (requires pubkey import):**
```bash
gpg --import <pubkey>
gpg --verify proof_artifacts/R11_SIGNATURE/sigs/dave.asc proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt
```

**Full PQ verification (requires oqsprovider):**
```bash
OPENSSL_MODULES=/path/to/ossl-modules ./scripts/verify_pq_sig.sh p384_mldsa65 \
  proof_artifacts/R15_PQ_SIGNATURE/sigs_pq/dave.p384_mldsa65.sig \
  proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt \
  proof_artifacts/R15_PQ_SIGNATURE/pubkeys/dave.p384_mldsa65.pub
```

## What This Repo Is

- Deterministic ledger + verification surface
- Framework to localize "tail debt"
- Mechanically verifiable artifact chain

## What This Repo Is NOT

- A proof of RH
- A claim that RH is true or false
- A substitute for peer review
