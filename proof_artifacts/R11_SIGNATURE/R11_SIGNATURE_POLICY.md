# R11 Signature Policy

**Concept-Tag:** RH-R11-SIGNATURE-POLICY

## Overview

This document describes the optional signature mechanism for the R10 assembly root.

## Signing (Optional)

If you have a GPG key and wish to sign:

```bash
gpg --armor --detach-sign \
  -o proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.sig \
  proof_artifacts/R11_SIGNATURE/R10_ASSEMBLY_ROOT.txt
```

## Verification

The verifier (`VERIFY_R11_SIGNATURE.sh`):

1. Checks `R10_ASSEMBLY_ROOT.txt` matches `R10_RECEIPT.json`
2. If `.sig` exists: runs `gpg --verify`
3. If `.sig` absent: passes (no signature required)

## Key Management

- No specific key is required or endorsed
- Operators may use any GPG key they control
- Key trust is out of scope for this verification layer

## Trust Model

Signatures provide attribution, not mathematical validation. The assembly root digest provides content integrity; signatures add operator identity.
