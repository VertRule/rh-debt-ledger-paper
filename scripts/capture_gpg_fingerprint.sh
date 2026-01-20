#!/bin/sh
# capture_gpg_fingerprint.sh - Capture GPG fingerprints for a signer
# Usage: scripts/capture_gpg_fingerprint.sh <signer_id> <gpg_query>
# Produces: proof_artifacts/R14_KEY_CAPTURE/captures/<signer_id>.fingerprint.txt
set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 <signer_id> <gpg_query>" >&2
    echo "Example: $0 dave 'david@example.com'" >&2
    exit 1
fi

SIGNER_ID="$1"
GPG_QUERY="$2"
OUTPUT_DIR="proof_artifacts/R14_KEY_CAPTURE/captures"
OUTPUT_FILE="$OUTPUT_DIR/$SIGNER_ID.fingerprint.txt"

# Check GPG is available
if ! command -v gpg >/dev/null 2>&1; then
    echo "ERROR: gpg not found" >&2
    exit 1
fi

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# Extract fingerprints (40-hex, spaces stripped, stable order)
FINGERPRINTS=$(gpg --list-keys --fingerprint "$GPG_QUERY" 2>/dev/null \
    | grep -E '^\s+[A-F0-9]{4}' \
    | tr -d ' ' \
    | sort -u)

if [ -z "$FINGERPRINTS" ]; then
    echo "ERROR: No fingerprints found for query: $GPG_QUERY" >&2
    exit 1
fi

# Write capture file (deterministic format, no timestamps)
{
    echo "Concept-Tag: RH-R14-GPG-FINGERPRINT-CAPTURE"
    echo "signer_id=$SIGNER_ID"
    echo "method=gpg --list-keys --fingerprint"
    echo "fingerprints:"
    echo "$FINGERPRINTS" | while IFS= read -r fp; do
        echo "  - $fp"
    done
    echo "end"
} > "$OUTPUT_FILE"

echo "Captured fingerprints for '$SIGNER_ID' -> $OUTPUT_FILE"
echo "Fingerprints found:"
echo "$FINGERPRINTS" | while IFS= read -r fp; do
    echo "  $fp"
done
