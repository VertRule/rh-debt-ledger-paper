#!/usr/bin/env bash
# VERIFY_R6_INSTANTIATION.sh — Mechanical integrity checks for R6 packet
# Does NOT validate math. Only validates packet structure.

set -euo pipefail

R6_DIR="proof_artifacts/R6_INSTANTIATION"
FAIL=0

echo "=== R6 Instantiation Record Integrity Check ==="

# Check required files exist
REQUIRED_FILES=(
    "$R6_DIR/00_INDEX.md"
    "$R6_DIR/R6_CONTRACT.md"
    "$R6_DIR/R6_INSTANTIATION_RECORD.md"
    "$R6_DIR/R6_WORKLIST.md"
    "$R6_DIR/evidence/EVIDENCE.md"
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

# Check each file contains Concept-Tag
echo "[2/4] Checking Concept-Tag markers..."
for f in "${REQUIRED_FILES[@]}"; do
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

# Check instantiation record structure
echo "[3/4] Checking instantiation record structure..."
RECORD="$R6_DIR/R6_INSTANTIATION_RECORD.md"
if [[ -f "$RECORD" ]]; then
    RECORD_FAIL=0
    if ! grep -q "Selected Source" "$RECORD"; then
        echo "  FAIL: $RECORD missing 'Selected Source' section"
        RECORD_FAIL=1
        FAIL=1
    fi
    if ! grep -q "R5.1\|U1" "$RECORD"; then
        echo "  FAIL: $RECORD missing R5.1/U1 reference"
        RECORD_FAIL=1
        FAIL=1
    fi
    if ! grep -q "UNCONDITIONAL" "$RECORD"; then
        echo "  FAIL: $RECORD missing UNCONDITIONAL status"
        RECORD_FAIL=1
        FAIL=1
    fi
    if ! grep -q "E(t)" "$RECORD"; then
        echo "  FAIL: $RECORD missing E(t) reference"
        RECORD_FAIL=1
        FAIL=1
    fi
    if ! grep -q "t₀\|t_0" "$RECORD"; then
        echo "  FAIL: $RECORD missing t0 reference"
        RECORD_FAIL=1
        FAIL=1
    fi
    if ! grep -q "02_PSI_TO_PI_MINUS_LI_BOUND" "$RECORD"; then
        echo "  FAIL: $RECORD missing R4 threading reference"
        RECORD_FAIL=1
        FAIL=1
    fi
    if [[ $RECORD_FAIL -eq 0 ]]; then
        echo "  OK: Instantiation record has required structure"
    fi
else
    echo "  FAIL: Instantiation record not found"
    FAIL=1
fi

# Check worklist has expected statuses
echo "[4/4] Checking worklist status..."
WORKLIST="$R6_DIR/R6_WORKLIST.md"
if [[ -f "$WORKLIST" ]]; then
    if ! grep -qE "DONE|TODO" "$WORKLIST"; then
        echo "  FAIL: $WORKLIST has no status entries"
        FAIL=1
    else
        echo "  OK: Worklist has status entries"
    fi
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
    echo "=== R6 INTEGRITY CHECK PASSED ==="
    exit 0
else
    echo "=== R6 INTEGRITY CHECK FAILED ==="
    exit 1
fi
