# R11 Multi-Signer Policy

**Concept-Tag:** RH-R12-MULTISIGN-POLICY

## Overview

This document describes the multi-signer envelope for the R10 assembly root.

## Signature Directory

Signatures live in:

```
proof_artifacts/R11_SIGNATURE/sigs/
```

## Naming Convention

Each signature file is named:

```
<signer_id>.asc
```

Examples:
- `dave.asc`
- `uma.asc`
- `reviewer1.asc`

The `.asc` extension indicates GPG armored detached signature format.

## Signed Payload

All signatures are over the same payload:

```
proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt
```

## Verification Behavior

The verifier (`VERIFY_R11_SIGNATURE.sh`) follows "verify all present":

1. If `sigs/` contains any `*.asc` files:
   - Verify each signature with `gpg --verify`
   - If any fails: FAIL and name the failing file
   - If all succeed: PASS with count of signatures verified

2. If no signature files exist:
   - PASS with "no signatures present (ok)"

## Adding a Signature

To add your signature:

```bash
gpg --armor --detach-sign \
  -o proof_artifacts/R11_SIGNATURE/sigs/<your_id>.asc \
  proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt
```

## Trust Model

- No specific keys are required or endorsed
- Signatures provide attribution, not mathematical validation
- The assembly root digest provides content integrity; signatures add operator identity
