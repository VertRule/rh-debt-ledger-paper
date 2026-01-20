# R14: Key Capture Receipts

**Concept-Tag:** RH-R14-INDEX

## Purpose

R14 provides a deterministic mechanism for capturing and verifying GPG key fingerprints without storing keys in the repository. Fingerprints in SIGNERS.md are payable via capture artifacts.

## Principle

> "No fingerprints may be asserted without a capture file; no keys stored."

## Contents

| File | Description |
|------|-------------|
| [R14_CONTRACT.md](R14_CONTRACT.md) | Key capture policy |
| [CAPTURE_POLICY.md](CAPTURE_POLICY.md) | Capture format and process |
| [captures/](captures/) | Capture artifacts (*.fingerprint.txt) |
| [R14_WORKLIST.md](R14_WORKLIST.md) | Task tracking |

## Verification

```
./VERIFY_R14_KEY_CAPTURE.sh
```

## Non-Claims

- No RH claim
- No key material stored (fingerprints only)
- Capture is operator-initiated, not automatic
