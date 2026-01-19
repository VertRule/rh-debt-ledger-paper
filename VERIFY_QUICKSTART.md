# Verify Quickstart

**Concept-Tag:** RH-VERIFY-QUICKSTART

## A) Verify latest release (recommended)

```
gh release view r3-cited-complete
```

Download the asset `r3-cited-complete-verify-surface.zip`, then:

```
unzip r3-cited-complete-verify-surface.zip
cd repo
VR_STRICT=1 ./VERIFY.sh
```

Expected output: `=== VERIFICATION PASSED ===`

## B) Verify from git checkout

```
git clone git@github.com:VertRule/rh-debt-ledger-paper.git
cd rh-debt-ledger-paper
git checkout r3-cited-complete
VR_STRICT=1 ./VERIFY.sh
```

Expected output: `=== VERIFICATION PASSED ===`

## C) What "PASS" means

Verification confirms mechanical integrity only: file structure, digest checks, and governance compliance for the R3 packet (17/17 tasks CITED with citation-only evidence). It does not reproduce any proofs and makes no claim regarding the Riemann Hypothesis.
