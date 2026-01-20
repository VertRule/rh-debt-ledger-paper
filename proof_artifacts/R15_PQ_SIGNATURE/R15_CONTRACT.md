# R15 Post-Quantum Signature Contract

**Concept-Tag:** RH-R15-PQ-SIGNATURE-ENVELOPE

## Claim

Optionally attach PQ signatures over R10_ASSEMBLY_ROOT.txt. Verification checks all present PQ sigs when tooling exists.

## Policy

Hybrid: classical signatures remain; PQ signatures are additive; no claims if absent.

## Construction

PQ signatures are stored in:

```
proof_artifacts/R15_PQ_SIGNATURE/sigs_pq/<signer_id>.<scheme>.sig
```

Supported schemes:
- `mldsa` (ML-DSA, FIPS 204)
- `slhdsa` (SLH-DSA, FIPS 205)

## Public Key Placement

Public keys for offline verification are stored in:

```
proof_artifacts/R15_PQ_SIGNATURE/pubkeys/<signer_id>.<scheme>.pub
```

## Verification Rules

1. If no sig files exist in `sigs_pq/`: PASS (no PQ sigs present)
2. If sig files exist:
   - Each signer_id must have a ledger entry in SIGNERS.md
   - Each sig file must have a corresponding public key (missing pubkey = FAIL)
   - Verification uses local PQ tooling if available
   - If no verifier tool found: PASS with skip message (environment dependency)
   - If verifier exists and any sig fails: FAIL
   - If verifier exists and all pass: PASS with count

## What This Does Not Do

- No private keys stored
- Does not require PQ signatures
- Does not replace classical GPG signatures
- Does not make RH claims

Public keys may be stored under `pubkeys/` to enable offline verification.
