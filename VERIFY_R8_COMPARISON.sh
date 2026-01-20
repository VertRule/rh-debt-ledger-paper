#!/usr/bin/env bash
# VERIFY_R8_COMPARISON.sh — Mechanical integrity checks for R8 comparison run
# Verifies that regenerated inventory matches original.

set -euo pipefail

R8_DIR="proof_artifacts/R8_COMPARISON_RUN"
R7_DIR="proof_artifacts/R7_BOUND_STATEMENT"
FAIL=0

echo "=== R8 Comparison Run Integrity Check ==="

# Check required files exist
REQUIRED_FILES=(
    "$R8_DIR/00_INDEX.md"
    "$R8_DIR/R8_CONTRACT.md"
    "$R8_DIR/R8_GENERATOR.sh"
    "$R8_DIR/R8_COMPARISON_RECEIPT.md"
    "$R8_DIR/R8_WORKLIST.md"
    "$R8_DIR/R8_REGENERATED_INVENTORY.md"
)

echo "[1/4] Checking required files..."
for f in "${REQUIRED_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
        echo "  FAIL: Missing $f"
        FAIL=1
    fi
done
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: All required files present"
fi

# Check Concept-Tags
echo "[2/4] Checking Concept-Tag markers..."
for f in "$R8_DIR/00_INDEX.md" "$R8_DIR/R8_CONTRACT.md" "$R8_DIR/R8_COMPARISON_RECEIPT.md" "$R8_DIR/R8_WORKLIST.md"; do
    if [[ -f "$f" ]]; then
        if ! grep -q "Concept-Tag:" "$f"; then
            echo "  FAIL: $f missing Concept-Tag"
            FAIL=1
        fi
    fi
done
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: All files have Concept-Tag"
fi

# Check receipt shows PASS
echo "[3/4] Checking comparison receipt..."
RECEIPT="$R8_DIR/R8_COMPARISON_RECEIPT.md"
if [[ -f "$RECEIPT" ]]; then
    if ! grep -q "PASS" "$RECEIPT"; then
        echo "  FAIL: Receipt does not show PASS"
        FAIL=1
    else
        echo "  OK: Receipt shows PASS"
    fi
fi

# Verify hash comparison still holds
echo "[4/4] Verifying hash comparison..."
ORIGINAL="$R7_DIR/R7_EQUATION_INVENTORY.md"
REGENERATED="$R8_DIR/R8_REGENERATED_INVENTORY.md"
if [[ -f "$ORIGINAL" ]] && [[ -f "$REGENERATED" ]]; then
    ORIGINAL_HASH=$(shasum -a 256 "$ORIGINAL" | awk '{print $1}')
    REGENERATED_HASH=$(shasum -a 256 "$REGENERATED" | awk '{print $1}')
    if [[ "$ORIGINAL_HASH" != "$REGENERATED_HASH" ]]; then
        echo "  FAIL: Hash mismatch"
        echo "  Original:    $ORIGINAL_HASH"
        echo "  Regenerated: $REGENERATED_HASH"
        FAIL=1
    else
        echo "  OK: Hashes match ($ORIGINAL_HASH)"
    fi
else
    echo "  SKIP: Missing files for hash comparison"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
    echo "=== R8 INTEGRITY CHECK PASSED ==="
    exit 0
else
    echo "=== R8 INTEGRITY CHECK FAILED ==="
    exit 1
fi
