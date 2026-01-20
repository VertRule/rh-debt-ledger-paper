#!/bin/sh
# VERIFY_R14_KEY_CAPTURE.sh - Verify key capture receipts for signer fingerprints
# If fingerprint != TBD in SIGNERS.md, require matching capture file
set -e

SIGNERS_FILE="proof_artifacts/R11_SIGNATURE/SIGNERS.md"
CAPTURES_DIR="proof_artifacts/R14_KEY_CAPTURE/captures"
ERRORS=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

# Check SIGNERS.md exists
if [ ! -f "$SIGNERS_FILE" ]; then
    echo "SKIP: SIGNERS.md not found"
    exit 0
fi

# Check captures directory exists
if [ ! -d "$CAPTURES_DIR" ]; then
    error "Captures directory missing: $CAPTURES_DIR"
    exit 1
fi

# Parse ledger entries (skip header rows)
# Format: | signer_id | display_name | role | key_fingerprint | key_provenance | notes |
# Use temp file to avoid subshell issues with pipe
TEMP_ENTRIES=$(mktemp)
trap 'rm -f "$TEMP_ENTRIES"' EXIT
grep '^|' "$SIGNERS_FILE" | grep -v '^| signer_id' | grep -v '^|[-]' > "$TEMP_ENTRIES" || true

while IFS='|' read -r _ signer_id _ _ key_fingerprint _ _; do
    # Trim whitespace
    signer_id=$(echo "$signer_id" | tr -d ' ')
    key_fingerprint=$(echo "$key_fingerprint" | tr -d ' ')

    # Skip empty rows
    if [ -z "$signer_id" ]; then
        continue
    fi

    # If fingerprint is TBD, no capture required
    if [ "$key_fingerprint" = "TBD" ]; then
        echo "  $signer_id: fingerprint=TBD (no capture required)"
        continue
    fi

    # Fingerprint is non-TBD, require capture file
    CAPTURE_FILE="$CAPTURES_DIR/$signer_id.fingerprint.txt"
    if [ ! -f "$CAPTURE_FILE" ]; then
        error "Missing capture file for $signer_id: $CAPTURE_FILE"
        continue
    fi

    # Verify fingerprint appears in capture file
    if ! grep -q "$key_fingerprint" "$CAPTURE_FILE"; then
        error "Fingerprint $key_fingerprint not found in $CAPTURE_FILE"
        continue
    fi

    echo "  $signer_id: fingerprint verified via capture"
done < "$TEMP_ENTRIES"

# Check for orphaned captures (capture files without ledger entries)
for capture in "$CAPTURES_DIR"/*.fingerprint.txt; do
    # Handle case where glob doesn't match anything
    if [ ! -f "$capture" ]; then
        continue
    fi
    signer_basename=$(basename "$capture" .fingerprint.txt)
    if ! grep -q "^| *$signer_basename *|" "$SIGNERS_FILE"; then
        error "Orphaned capture file (no ledger entry): $capture"
    fi
done

if [ "$ERRORS" -gt 0 ]; then
    echo "R14 key capture verification failed: $ERRORS error(s)"
    exit 1
fi

echo "R14 key capture verification passed"
exit 0
