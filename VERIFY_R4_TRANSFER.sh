#!/usr/bin/env bash
# VERIFY_R4_TRANSFER.sh — Mechanical integrity checks for R4 packet
# Does NOT validate math. Only validates packet structure.

set -euo pipefail

R4_DIR="proof_artifacts/R4_TRANSFER_REPRO"
FAIL=0

echo "=== R4 Transfer Packet Integrity Check ==="

# Check required files exist
REQUIRED_FILES=(
    "$R4_DIR/00_INDEX.md"
    "$R4_DIR/R4_CONTRACT.md"
    "$R4_DIR/01_PARTIAL_SUMMATION.md"
    "$R4_DIR/02_PSI_TO_PI_MINUS_LI_BOUND.md"
    "$R4_DIR/R4_WORKLIST.md"
    "$R4_DIR/evidence/EVIDENCE.md"
)

echo "[1/5] Checking required files..."
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
echo "[2/5] Checking Concept-Tag markers..."
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

# Check 01 and 02 contain math blocks
echo "[3/5] Checking math blocks in derivation files..."
for f in "$R4_DIR/01_PARTIAL_SUMMATION.md" "$R4_DIR/02_PSI_TO_PI_MINUS_LI_BOUND.md"; do
    if [[ -f "$f" ]]; then
        if ! grep -qE '```math|^\$\$|\$[^$]+\$' "$f"; then
            echo "  FAIL: $f missing math block"
            FAIL=1
        fi
    fi
done
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: Derivation files contain math blocks"
fi

# Check worklist structure
echo "[4/5] Checking worklist structure..."
WORKLIST="$R4_DIR/R4_WORKLIST.md"
if [[ -f "$WORKLIST" ]]; then
    if ! grep -q "| ID |" "$WORKLIST"; then
        echo "  FAIL: $WORKLIST missing table header"
        FAIL=1
    fi
    if ! grep -qE "DONE|CITED|TODO" "$WORKLIST"; then
        echo "  FAIL: $WORKLIST has no status entries"
        FAIL=1
    fi
fi
if [[ $FAIL -eq 0 ]]; then
    echo "  OK: Worklist has proper structure"
fi

# Check equation inventory hash
echo "[5/5] Checking equation inventory hash..."
INVENTORY="$R4_DIR/07_EQUATION_INVENTORY.md"
EXPECTED_HASH="$R4_DIR/07_EQUATION_INVENTORY.sha256"
if [[ -f "$INVENTORY" ]] && [[ -f "$EXPECTED_HASH" ]]; then
    EXPECTED=$(cat "$EXPECTED_HASH" | tr -d ' \n')
    ACTUAL=$(shasum -a 256 "$INVENTORY" | awk '{print $1}')
    if [[ "$EXPECTED" != "$ACTUAL" ]]; then
        echo "  FAIL: R4 equation inventory hash mismatch (math changed without updating inventory)"
        echo "  Expected: $EXPECTED"
        echo "  Actual:   $ACTUAL"
        FAIL=1
    else
        echo "  OK: Equation inventory hash verified"
    fi
else
    echo "  SKIP: Equation inventory or hash file not found"
fi

echo ""
if [[ $FAIL -eq 0 ]]; then
    echo "=== R4 INTEGRITY CHECK PASSED ==="
    exit 0
else
    echo "=== R4 INTEGRITY CHECK FAILED ==="
    exit 1
fi
