# R14 Capture Policy

**Concept-Tag:** RH-R14-CAPTURE-POLICY

## Capture File Format

Each capture file follows this deterministic format (no timestamps):

```
Concept-Tag: RH-R14-GPG-FINGERPRINT-CAPTURE
signer_id=<signer_id>
method=gpg --list-keys --fingerprint
fingerprints:
  - <40-hex fingerprint>
  - <40-hex fingerprint>
end
```

## Capture Process

1. Run the capture script:
   ```bash
   scripts/capture_gpg_fingerprint.sh <signer_id> "<gpg_query>"
   ```

2. The script produces:
   ```
   proof_artifacts/R14_KEY_CAPTURE/captures/<signer_id>.fingerprint.txt
   ```

3. Manually update SIGNERS.md to replace TBD with the captured fingerprint

4. Commit both files together

## GPG Query Examples

- By email: `"user@example.com"`
- By name: `"John Doe"`
- By key ID: `"0x1234ABCD"`

## What Is NOT Stored

- No public key blocks
- No private keys
- No key material beyond the fingerprint
