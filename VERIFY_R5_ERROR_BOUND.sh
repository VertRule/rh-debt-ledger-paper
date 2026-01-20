#!/usr/bin/env bash
# VERIFY_R5_ERROR_BOUND.sh — Mechanical integrity checks for R5 packet
# Does NOT validate math. Only validates packet structure.

set -euo pipefail

R5_DIR="proof_artifacts/R5_ERROR_BOUND_SOURCE"
FAIL=0

echo "=== R5 Error-Bound Source Integrity Check ==="

# Check required files exist
REQUIRED_FILES=(
    "$R5_DIR/00_INDEX.md"
    "$R5_DIR/R5_CONTRACT.md"
    "$R5_DIR/R5_MENU.md"
    "$R5_DIR/R5_WORKLIST.md"
    "$R5_DIR/evidence/EVIDENCE.md"
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

# Check R5_MENU.md contains both source buckets
echo "[3/4] Checking menu structure..."
MENU="$R5_DIR/R5_MENU.md"
if [[ -f "$MENU" ]]; then
    if ! grep -q "UNCONDITIONAL SOURCES" "$MENU"; then
        echo "  FAIL: $MENU missing UNCONDITIONAL SOURCES section"
        FAIL=1
    fi
    if ! grep -q "CONDITIONAL SOURCES" "$MENU"; then
        echo "  FAIL: $MENU missing CONDITIONAL SOURCES section"
        FAIL=1
    fi
fi
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: Menu has both source buckets"
fi

# Check R5_CONTRACT.md contains A1-A4
echo "[4/4] Checking admissibility predicates..."
CONTRACT="$R5_DIR/R5_CONTRACT.md"
if [[ -f "$CONTRACT" ]]; then
    for pred in A1 A2 A3 A4; do
        if ! grep -q "$pred" "$CONTRACT"; then
            echo "  FAIL: $CONTRACT missing predicate $pred"
            FAIL=1
        fi
    done
fi
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: Contract contains A1-A4 predicates"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
    echo "=== R5 INTEGRITY CHECK PASSED ==="
    exit 0
else
    echo "=== R5 INTEGRITY CHECK FAILED ==="
    exit 1
fi
