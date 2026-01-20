# Verify Quickstart

**Concept-Tag:** RH-VERIFY-QUICKSTART

## What This Repo Is / Is Not

| Is | Is Not |
|----|--------|
| Deterministic ledger + verification surface | A proof of RH |
| Framework to localize "tail debt" and keep claims from being promoted | Claim that RH is true or false |
| Mechanically verifiable artifact chain | Substitute for peer review |

## A) Baseline Verification (No Keys, No PQ Tooling)

**Requirements:** bash, coreutils, sha256sum (or shasum on macOS)

```bash
git clone https://github.com/VertRule/rh-debt-ledger-paper.git
cd rh-debt-ledger-paper
VR_STRICT=1 ./VERIFY.sh
```

**Expected:** `=== VERIFICATION PASSED ===`

All 22 steps should PASS or SKIP. Expected skips:
- R11: `SKIP: Public key not in keyring` (GPG signature exists but key not imported)
- R15: `SKIP: tool missing` (PQ signature exists but oqsprovider not installed)
- R16: `OK` or `SKIP` depending on PQ tooling presence

Skips are acceptable for baseline verification. The artifact chain is intact.

## B) Full Classical Verification (GPG)

To verify GPG signatures, import the signer's public key and confirm the fingerprint.

**Step 1: Obtain the public key**

Fetch Dave's public key from a keyserver or request it directly. Do NOT trust any key blindly.

**Step 2: Import and verify fingerprint**

```bash
gpg --import dave-pubkey.asc
gpg --list-keys --fingerprint dave@vertrule.com
```

**Expected fingerprint** (from `proof_artifacts/R14_KEY_CAPTURE/captures/dave.fingerprint.txt`):

```
4AD8DC2E333085334398EDD81872DFF540882A6B
```

If the fingerprint does not match, do NOT proceed. The key is not authentic.

**Step 3: Re-run verification**

```bash
VR_STRICT=1 ./VERIFY.sh
```

R11 should now report `R11: 1 signature(s) verified` instead of SKIP.

## C) Full PQ Verification (oqsprovider)

PQ signatures use hybrid algorithms (e.g., `p384_mldsa65`) which require OpenSSL 3 with oqsprovider.

**Requirements:**
- OpenSSL 3.x
- oqsprovider module installed
- `OPENSSL_MODULES` environment variable pointing to the module directory

**Step 1: Verify oqsprovider is available**

```bash
OPENSSL_MODULES=/path/to/ossl-modules openssl list -providers -provider oqsprovider
```

Should list `oqsprovider` among providers.

**Step 2: (Optional) Generate tooling receipt**

```bash
./scripts/capture_pq_tooling.sh
```

This creates `proof_artifacts/R16_PQ_TOOLING/R16_TOOLING_RECEIPT.json`.

**Step 3: Re-run verification**

```bash
VR_STRICT=1 ./VERIFY.sh
```

R15 should now report signature verification for `dave.p384_mldsa65` instead of SKIP.

## D) Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| R11: `SKIP: Public key not in keyring` | GPG key not imported | Import pubkey, confirm fingerprint matches R14 capture |
| R15: `SKIP: tool missing` | oqsprovider not installed | Install oqsprovider, set `OPENSSL_MODULES` |
| R15: `ERROR: Unknown scheme` | Signature filename uses unsupported scheme | Verify naming: `<signer>.<scheme>.sig` where scheme is in allowlist |
| R16: `SKIP: no tooling receipt` | PQ tooling receipt not generated | Run `./scripts/capture_pq_tooling.sh` |

## E) Verify from Release Asset

Download the verify-surface bundle for offline verification:

```bash
gh release download r18-gpg-signature-ink -p '*verify-surface.zip'
unzip r18-gpg-signature-ink-verify-surface.zip
cd r18-gpg-signature-ink/repo
VR_STRICT=1 ./VERIFY.sh
```

Expected: `=== VERIFICATION PASSED ===`
