#!/bin/sh
# VERIFY_R9_NO_SURPRISE.sh - Verify R9 input manifest and digests
# Ensures no silent changes to R8 regeneration inputs
set -e

R9_DIR="proof_artifacts/R9_NO_SURPRISE_ASSEMBLY"
ERRORS=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

# 1) Check all required R9 files exist
REQUIRED_FILES="
$R9_DIR/00_INDEX.md
$R9_DIR/R9_CONTRACT.md
$R9_DIR/R9_WORKLIST.md
$R9_DIR/R9_INPUT_MANIFEST.txt
$R9_DIR/R9_INPUT_MANIFEST.sha256
$R9_DIR/R9_INPUT_DIGESTS.sha256
"

for f in $REQUIRED_FILES; do
    if [ ! -f "$f" ]; then
        error "Required file missing: $f"
    fi
done

if [ "$ERRORS" -gt 0 ]; then
    echo "R9 verification failed: missing files"
    exit 1
fi

# 2) Verify manifest hash matches committed R9_INPUT_MANIFEST.sha256
EXPECTED_MANIFEST_HASH=$(cat "$R9_DIR/R9_INPUT_MANIFEST.sha256")
ACTUAL_MANIFEST_HASH=$(shasum -a 256 "$R9_DIR/R9_INPUT_MANIFEST.txt" | awk '{print $1}')

if [ "$EXPECTED_MANIFEST_HASH" != "$ACTUAL_MANIFEST_HASH" ]; then
    error "Manifest hash mismatch: expected $EXPECTED_MANIFEST_HASH, got $ACTUAL_MANIFEST_HASH"
fi

# 3) Verify each line in R9_INPUT_DIGESTS.sha256 matches current sha256 of its file
while IFS= read -r line; do
    EXPECTED_HASH=$(echo "$line" | awk '{print $1}')
    FILE_PATH=$(echo "$line" | awk '{print $2}')

    if [ ! -f "$FILE_PATH" ]; then
        error "Input file missing: $FILE_PATH"
        continue
    fi

    ACTUAL_HASH=$(shasum -a 256 "$FILE_PATH" | awk '{print $1}')

    if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
        error "Digest mismatch for $FILE_PATH: expected $EXPECTED_HASH, got $ACTUAL_HASH"
    fi
done < "$R9_DIR/R9_INPUT_DIGESTS.sha256"

# 4) Report result
if [ "$ERRORS" -gt 0 ]; then
    echo "R9 verification failed: $ERRORS error(s)"
    exit 1
fi

echo "R9 no-surprise assembly verified"
exit 0
