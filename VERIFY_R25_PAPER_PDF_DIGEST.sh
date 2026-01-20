#!/bin/sh
# VERIFY_R25_PAPER_PDF_DIGEST.sh - Verify paper PDF matches recorded digest
# Concept-Tag: RH-R25-PDF-DIGEST-VERIFIER
#
# This verifier checks that paper/main.pdf matches paper/main.pdf.sha256.
# No external dependencies required (just sha256sum or shasum).
#
# Usage: ./VERIFY_R25_PAPER_PDF_DIGEST.sh
#
# Exit codes:
#   0 - PASS (digest matches)
#   1 - FAIL (digest mismatch or missing files)
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PDF_FILE="$SCRIPT_DIR/paper/main.pdf"
SHA_FILE="$SCRIPT_DIR/paper/main.pdf.sha256"

# Check required files exist
if [ ! -f "$PDF_FILE" ]; then
    echo "ERROR: $PDF_FILE not found" >&2
    exit 1
fi

if [ ! -f "$SHA_FILE" ]; then
    echo "ERROR: $SHA_FILE not found" >&2
    exit 1
fi

# Read expected digest
EXPECTED=$(cat "$SHA_FILE" | tr -d '[:space:]')

# Compute actual digest
if command -v sha256sum >/dev/null 2>&1; then
    ACTUAL=$(sha256sum "$PDF_FILE" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    ACTUAL=$(shasum -a 256 "$PDF_FILE" | awk '{print $1}')
else
    echo "ERROR: No sha256 tool found" >&2
    exit 1
fi

# Compare
if [ "$EXPECTED" = "$ACTUAL" ]; then
    echo "OK: PDF digest verified ($ACTUAL)"
    exit 0
else
    echo "FAIL: PDF digest mismatch" >&2
    echo "  Expected: $EXPECTED" >&2
    echo "  Actual:   $ACTUAL" >&2
    exit 1
fi
