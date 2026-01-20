# R15 PQ Signature Policy

**Concept-Tag:** RH-R15-PQ-POLICY

## Signature Format

Each PQ signature file follows this naming convention:

```
<signer_id>.<scheme>.sig
```

Examples:
- `dave.mldsa.sig`
- `dave.slhdsa.sig`
- `dave.p384_mldsa65.sig`

## Supported Schemes

| Scheme | Standard | Notes |
|--------|----------|-------|
| mldsa | ML-DSA (FIPS 204) | Lattice-based (pure PQ) |
| slhdsa | SLH-DSA (FIPS 205) | Hash-based (pure PQ) |
| p384_mldsa65 | P-384 + ML-DSA-65 | Hybrid (classical + PQ) |
| p521_mldsa87 | P-521 + ML-DSA-87 | Hybrid (classical + PQ) |
| p256_mldsa44 | P-256 + ML-DSA-44 | Hybrid (classical + PQ) |
| rsa3072_mldsa44 | RSA-3072 + ML-DSA-44 | Hybrid (classical + PQ) |

Note: Hybrid schemes combine a classical algorithm with a post-quantum algorithm. The scheme identifier in filenames matches the oqsprovider algorithm name exactly (e.g., `p384_mldsa65`).

## Payload

All PQ signatures are computed over:

```
proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt
```

This is the same payload signed by classical GPG signatures.

## Tooling Requirements

Verification requires one of:
1. oqs-toolbox / liboqs sign/verify CLI
2. openssl with oqsprovider

If no tool is available, verification skips with success.

## Creating a PQ Signature

```bash
# Example with liboqs (if installed)
oqs-sign -a mldsa65 -k private.key -i R10_ASSEMBLY_ROOT.txt -o dave.mldsa.sig

# Example with openssl+oqsprovider (if installed)
openssl pkeyutl -sign -inkey private.pem -in R10_ASSEMBLY_ROOT.txt -out dave.mldsa.sig
```

## Public Key Placement

Public keys for offline verification are stored in:

```
pubkeys/<signer_id>.<scheme>.pub
```

Examples:
- `pubkeys/dave.mldsa.pub`
- `pubkeys/dave.slhdsa.pub`
- `pubkeys/dave.p384_mldsa65.pub`

Each PQ signature file MUST have a corresponding public key. Missing pubkey = verification failure.

## What Is NOT Stored

- No private keys

Public keys may be stored under `pubkeys/` to enable offline verification.
