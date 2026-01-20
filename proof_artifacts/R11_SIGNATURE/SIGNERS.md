# Signer Identity Ledger

**Concept-Tag:** RH-R13-SIGNER-LEDGER

## Purpose

This ledger maps signature file identifiers to human-auditable identity information. Any signature in `sigs/*.asc` must have a corresponding entry here.

## Ledger

| signer_id | display_name | role | key_fingerprint | key_provenance | notes |
|-----------|--------------|------|-----------------|----------------|-------|
| dave | David Ingle | maintainer | TBD | TBD | optional signature |

## Adding a Signer

To add yourself as a signer:

1. Add a row to the table above with your `signer_id` (matching your `.asc` filename)
2. Include your key fingerprint and where to fetch your public key
3. Submit a PR with your signature in `sigs/<signer_id>.asc`

## Notes

- Fingerprints should be the full 40-character GPG fingerprint
- Key provenance should specify where the public key can be verified (keyserver, GitHub profile, personal website, etc.)
- Do not commit private keys or full public key blocks to this repository
