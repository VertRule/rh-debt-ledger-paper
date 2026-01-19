#!/usr/bin/env bash
set -euo pipefail

# Verify all exhibit pointers in exhibits/*.json
# Checks:
#   - manifest_digest matches sha256 of referenced sha256_manifest.txt
#   - receipt_digest (if present) matches sha256 of referenced receipt file

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXHIBITS_DIR="${SCRIPT_DIR}/exhibits"
EXPERIMENT_REPO="${SCRIPT_DIR}/../experiments/rh_debt_ledger"

echo "=== Verify All Exhibits ==="
echo ""

passed=0
failed=0
skipped=0

for exhibit in "${EXHIBITS_DIR}"/*.json; do
    name=$(basename "$exhibit" .json)

    # Extract fields from JSON using jq if available, otherwise use grep/sed
    if command -v jq &> /dev/null; then
        manifest_digest=$(jq -r '.manifest_digest // empty' "$exhibit" 2>/dev/null || echo "")
        source_path=$(jq -r '.source_path // empty' "$exhibit" 2>/dev/null || echo "")
        receipt_path=$(jq -r '.receipt_path // empty' "$exhibit" 2>/dev/null || echo "")
        receipt_digest=$(jq -r '.receipt_digest // empty' "$exhibit" 2>/dev/null || echo "")
    else
        manifest_digest=$(grep -o '"manifest_digest"[[:space:]]*:[[:space:]]*"[^"]*"' "$exhibit" | sed 's/.*: *"\([^"]*\)"/\1/' || echo "")
        source_path=$(grep -o '"source_path"[[:space:]]*:[[:space:]]*"[^"]*"' "$exhibit" | sed 's/.*: *"\([^"]*\)"/\1/' || echo "")
        receipt_path=$(grep -o '"receipt_path"[[:space:]]*:[[:space:]]*"[^"]*"' "$exhibit" | sed 's/.*: *"\([^"]*\)"/\1/' || echo "")
        receipt_digest=$(grep -o '"receipt_digest"[[:space:]]*:[[:space:]]*"[^"]*"' "$exhibit" | sed 's/.*: *"\([^"]*\)"/\1/' || echo "")
    fi

    # Skip exhibits without manifest_digest (not a run pointer)
    if [[ -z "$manifest_digest" ]]; then
        echo "[$name] SKIP (no manifest_digest)"
        ((skipped++))
        continue
    fi

    # Resolve source path relative to experiment repo
    if [[ "$source_path" == experiments/* ]]; then
        full_source_path="${SCRIPT_DIR}/../${source_path}"
    else
        full_source_path="${EXPERIMENT_REPO}/${source_path}"
    fi

    manifest_file="${full_source_path}/sha256_manifest.txt"

    # Check if manifest file exists
    if [[ ! -f "$manifest_file" ]]; then
        echo "[$name] SKIP (manifest file not found: $manifest_file)"
        ((skipped++))
        continue
    fi

    # Verify manifest digest
    expected_hash="${manifest_digest#sha256:}"
    actual_hash=$(shasum -a 256 "$manifest_file" | cut -d' ' -f1)

    if [[ "$expected_hash" != "$actual_hash" ]]; then
        echo "[$name] FAIL: manifest_digest mismatch"
        echo "  expected: sha256:$expected_hash"
        echo "  actual:   sha256:$actual_hash"
        ((failed++))
        continue
    fi

    # Verify receipt digest if present
    if [[ -n "$receipt_path" && -n "$receipt_digest" ]]; then
        if [[ "$receipt_path" == experiments/* ]]; then
            full_receipt_path="${SCRIPT_DIR}/../${receipt_path}"
        else
            full_receipt_path="${EXPERIMENT_REPO}/${receipt_path}"
        fi

        if [[ ! -f "$full_receipt_path" ]]; then
            echo "[$name] SKIP (receipt file not found: $full_receipt_path)"
            ((skipped++))
            continue
        fi

        expected_receipt_hash="${receipt_digest#sha256:}"
        actual_receipt_hash=$(shasum -a 256 "$full_receipt_path" | cut -d' ' -f1)

        if [[ "$expected_receipt_hash" != "$actual_receipt_hash" ]]; then
            echo "[$name] FAIL: receipt_digest mismatch"
            echo "  expected: sha256:$expected_receipt_hash"
            echo "  actual:   sha256:$actual_receipt_hash"
            ((failed++))
            continue
        fi
    fi

    echo "[$name] PASS"
    ((passed++))
done

echo ""
echo "=== Summary ==="
echo "  Passed:  $passed"
echo "  Failed:  $failed"
echo "  Skipped: $skipped"
echo ""

if [[ $failed -gt 0 ]]; then
    echo "=== VERIFICATION FAILED ==="
    exit 1
else
    echo "=== VERIFICATION PASSED ==="
    exit 0
fi
