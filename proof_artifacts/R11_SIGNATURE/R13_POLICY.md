# R13 Signer Identity Policy

**Concept-Tag:** RH-R13-SIGNER-POLICY

## Policy

Signatures are optional; if present, they must correspond to a signer_id in SIGNERS.md.

## Rationale

This policy prevents anonymous signatures from being treated as meaningful. Every signature file must have a corresponding identity entry in the signer ledger, allowing human auditors to:

1. Identify who signed
2. Verify the key fingerprint
3. Fetch the public key from a trusted source

## Verification Rules

1. If `sigs/` contains no `*.asc` files: PASS
2. If signatures exist:
   - Each `<signer_id>.asc` must have a matching entry in `SIGNERS.md`
   - Missing entries cause verification to FAIL
   - All present signatures must verify with GPG

## What This Does Not Do

- Does not require any specific signer
- Does not validate key trust chains
- Does not store public keys in this repository
