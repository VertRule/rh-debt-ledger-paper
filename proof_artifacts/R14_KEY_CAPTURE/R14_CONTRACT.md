# R14 Key Capture Contract

**Concept-Tag:** RH-R14-KEY-CAPTURE

## Claim

Signer fingerprints in SIGNERS.md are payable via deterministic capture artifacts produced by the operator.

## Policy

No fingerprints may be asserted without a capture file; no keys stored.

## Construction

Each signer with a non-TBD fingerprint in SIGNERS.md must have a corresponding capture file:

```
proof_artifacts/R14_KEY_CAPTURE/captures/<signer_id>.fingerprint.txt
```

The capture file contains:
- Concept tag
- Signer ID
- Capture method
- One or more 40-hex fingerprints

## Verification Rules

1. If `key_fingerprint == TBD` in SIGNERS.md: PASS (no capture required)
2. If fingerprint is 40-hex: require matching capture file with that fingerprint
3. Missing captures or mismatches: FAIL

## What This Does Not Do

- Does not store public keys
- Does not validate key trust chains
- Does not automatically update SIGNERS.md
