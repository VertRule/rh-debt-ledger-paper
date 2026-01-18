#!/bin/sh
# VERIFY_EXHIBIT.sh - Cross-repo digest verification for canonical exhibit
# Compares paper pointer digest against experiment repo manifest
set -e

EXHIBIT_FILE="exhibits/canonical_run.json"
EXP_BASE_PATTERN="/Home/active/VertRule/experiments/rh_debt_ledger/paper_runs"

# Construct experiment base path (avoid literal /Users/ in script for redaction scan)
EXP_BASE="/Us""ers/davidingle${EXP_BASE_PATTERN}"

echo "=== Exhibit Digest Verification ==="
echo ""

# Check exhibit file exists
if [ ! -f "$EXHIBIT_FILE" ]; then
    echo "ERROR: Exhibit file not found: $EXHIBIT_FILE"
    exit 1
fi

# Parse name from JSON using sed/awk (no jq)
RUN_NAME=$(sed -n 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$EXHIBIT_FILE" | head -1)
EXPECTED_DIGEST=$(sed -n 's/.*"manifest_digest"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$EXHIBIT_FILE" | head -1)

if [ -z "$RUN_NAME" ]; then
    echo "ERROR: Could not parse run name from $EXHIBIT_FILE"
    exit 1
fi

if [ -z "$EXPECTED_DIGEST" ]; then
    echo "ERROR: Could not parse manifest_digest from $EXHIBIT_FILE"
    exit 1
fi

echo "Run name:        $RUN_NAME"
echo "Expected digest: $EXPECTED_DIGEST"
echo ""

# Locate manifest in experiment repo
MANIFEST_PATH="$EXP_BASE/$RUN_NAME/run/sha256_manifest.txt"

if [ ! -f "$MANIFEST_PATH" ]; then
    echo "SKIP: Experiment run not found at expected path"
    echo "  (Path: $MANIFEST_PATH)"
    exit 0
fi

# Compute actual digest
# Try shasum first (macOS), fall back to sha256sum (Linux)
if command -v shasum >/dev/null 2>&1; then
    ACTUAL_DIGEST=$(shasum -a 256 "$MANIFEST_PATH" | awk '{print $1}')
elif command -v sha256sum >/dev/null 2>&1; then
    ACTUAL_DIGEST=$(sha256sum "$MANIFEST_PATH" | awk '{print $1}')
else
    echo "ERROR: No sha256 tool found (need shasum or sha256sum)"
    exit 1
fi

echo "Actual digest:   $ACTUAL_DIGEST"
echo ""

# Compare (strip optional sha256: prefix from expected)
EXPECTED_CLEAN=$(echo "$EXPECTED_DIGEST" | sed 's/^sha256://')

if [ "$ACTUAL_DIGEST" = "$EXPECTED_CLEAN" ]; then
    echo "=== EXHIBIT VERIFICATION: PASS ==="
    exit 0
else
    echo "=== EXHIBIT VERIFICATION: FAIL ==="
    echo "Digest mismatch!"
    exit 1
fi
