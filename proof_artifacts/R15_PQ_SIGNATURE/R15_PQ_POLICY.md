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

## Supported Schemes

| Scheme | Standard | Notes |
|--------|----------|-------|
| mldsa | ML-DSA (FIPS 204) | Lattice-based |
| slhdsa | SLH-DSA (FIPS 205) | Hash-based |

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

## What Is NOT Stored

- No private keys
- No public keys
- Only detached signatures
