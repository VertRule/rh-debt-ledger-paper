#!/bin/sh
# VERIFY_R10_ASSEMBLY_RECEIPT.sh - Verify R10 assembly receipt
# Ensures receipt matches current assembly state via content-root binding
set -e

R10_DIR="proof_artifacts/R10_ASSEMBLY_RECEIPT"
RECEIPT="$R10_DIR/R10_RECEIPT.json"
RECEIPT_SHA="$R10_DIR/R10_RECEIPT.sha256"
R9_DIR="proof_artifacts/R9_NO_SURPRISE_ASSEMBLY"
ERRORS=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

# 1) Check R10_RECEIPT.json exists and contains concept_tag
if [ ! -f "$RECEIPT" ]; then
    error "Receipt file missing: $RECEIPT"
    exit 1
fi

if ! grep -q '"concept_tag"' "$RECEIPT"; then
    error "Receipt missing concept_tag"
    exit 1
fi

# 2) Verify receipt file sha256 matches R10_RECEIPT.sha256
if [ ! -f "$RECEIPT_SHA" ]; then
    error "Receipt sha256 file missing: $RECEIPT_SHA"
else
    EXPECTED_SHA=$(cat "$RECEIPT_SHA")
    ACTUAL_SHA=$(shasum -a 256 "$RECEIPT" | awk '{print $1}')
    if [ "$EXPECTED_SHA" != "$ACTUAL_SHA" ]; then
        error "Receipt sha256 mismatch: expected $EXPECTED_SHA, got $ACTUAL_SHA"
    fi
fi

# 3) Recompute assembly_root_sha256 and compare
# Canonical text format: one hex digest per line, in fixed order:
#   - r9_manifest_sha256
#   - each input sha256 (manifest order)
#   - each output sha256 (fixed order)
#   - each verifier sha256 (fixed order)

CANONICAL_TEXT=$(mktemp)

# r9_manifest_sha256
cat "$R9_DIR/R9_INPUT_MANIFEST.sha256" >> "$CANONICAL_TEXT"

# input digests (manifest order)
while IFS= read -r line; do
    echo "$line" | awk '{print $1}' >> "$CANONICAL_TEXT"
done < "$R9_DIR/R9_INPUT_DIGESTS.sha256"

# output digests (fixed order)
shasum -a 256 "proof_artifacts/R7_BOUND_STATEMENT/R7_BOUND_STATEMENT.md" | awk '{print $1}' >> "$CANONICAL_TEXT"
shasum -a 256 "proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.md" | awk '{print $1}' >> "$CANONICAL_TEXT"
shasum -a 256 "proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.sha256" | awk '{print $1}' >> "$CANONICAL_TEXT"

# verifier digests (fixed order)
shasum -a 256 "VERIFY_R7_BOUND_STATEMENT.sh" | awk '{print $1}' >> "$CANONICAL_TEXT"
shasum -a 256 "VERIFY_R8_COMPARISON.sh" | awk '{print $1}' >> "$CANONICAL_TEXT"
shasum -a 256 "VERIFY_R9_NO_SURPRISE.sh" | awk '{print $1}' >> "$CANONICAL_TEXT"
shasum -a 256 "VERIFY_R10_ASSEMBLY_RECEIPT.sh" | awk '{print $1}' >> "$CANONICAL_TEXT"

COMPUTED_ROOT=$(shasum -a 256 "$CANONICAL_TEXT" | awk '{print $1}')
rm -f "$CANONICAL_TEXT"

RECEIPT_ROOT=$(grep '"assembly_root_sha256"' "$RECEIPT" | sed 's/.*: *"\([^"]*\)".*/\1/')

if [ "$COMPUTED_ROOT" != "$RECEIPT_ROOT" ]; then
    error "assembly_root_sha256 mismatch: computed $COMPUTED_ROOT, receipt $RECEIPT_ROOT"
fi

# 4) Verify each r9_input digest from receipt
while IFS= read -r line; do
    FILE_PATH=$(echo "$line" | awk '{print $2}')
    EXPECTED_HASH=$(echo "$line" | awk '{print $1}')

    if [ ! -f "$FILE_PATH" ]; then
        error "Input file missing: $FILE_PATH"
        continue
    fi

    ACTUAL_HASH=$(shasum -a 256 "$FILE_PATH" | awk '{print $1}')
    if [ "$EXPECTED_HASH" != "$ACTUAL_HASH" ]; then
        error "Input digest mismatch for $FILE_PATH: expected $EXPECTED_HASH, got $ACTUAL_HASH"
    fi
done < "$R9_DIR/R9_INPUT_DIGESTS.sha256"

# 5) Verify each output digest from receipt
OUTPUT_FILES="proof_artifacts/R7_BOUND_STATEMENT/R7_BOUND_STATEMENT.md proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.md proof_artifacts/R7_BOUND_STATEMENT/R7_EQUATION_INVENTORY.sha256"
for FILE_PATH in $OUTPUT_FILES; do
    if [ ! -f "$FILE_PATH" ]; then
        error "Output file missing: $FILE_PATH"
        continue
    fi

    ACTUAL_HASH=$(shasum -a 256 "$FILE_PATH" | awk '{print $1}')
    if ! grep -q "\"sha256\": \"$ACTUAL_HASH\"" "$RECEIPT"; then
        error "Output digest for $FILE_PATH ($ACTUAL_HASH) not found in receipt"
    fi
done

# 6) Report result
if [ "$ERRORS" -gt 0 ]; then
    echo "R10 assembly receipt verification failed: $ERRORS error(s)"
    exit 1
fi

echo "R10 assembly receipt verified"
exit 0
