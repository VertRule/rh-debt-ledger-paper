#!/usr/bin/env bash
set -euo pipefail

# Verify all exhibit pointers in exhibits/*.json
# Kind-aware verification:
#   - kind="run": verify manifest_snapshot digest, and receipt_snapshot if receipt_required=true
#   - kind="contracts": verify contract digests are properly formatted
#   - kind="fresh_clone": verify each file's sha256 matches

# Portable sha256 hash function (works on macOS and Linux)
sha256_hash() {
    if command -v sha256sum &> /dev/null; then
        sha256sum "$1" | cut -d' ' -f1
    else
        shasum -a 256 "$1" | cut -d' ' -f1
    fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXHIBITS_DIR="${SCRIPT_DIR}/exhibits"

echo "=== Verify All Exhibits ==="
echo ""

passed=0
failed=0
skipped=0

for exhibit in "${EXHIBITS_DIR}"/*.json; do
    name=$(basename "$exhibit" .json)

    # Extract fields from JSON using jq
    if ! command -v jq &> /dev/null; then
        echo "[$name] SKIP (jq not available)"
        ((skipped++))
        continue
    fi

    kind=$(jq -r '.kind // "run"' "$exhibit" 2>/dev/null || echo "run")
    inactive=$(jq -r '.inactive // false' "$exhibit" 2>/dev/null || echo "false")

    # Skip inactive exhibits
    if [[ "$inactive" == "true" ]]; then
        echo "[$name] SKIP (inactive exhibit)"
        ((skipped++))
        continue
    fi

    # Handle different exhibit kinds
    case "$kind" in
        run)
            # Run exhibits require manifest verification
            manifest_digest=$(jq -r '.manifest_digest // empty' "$exhibit" 2>/dev/null || echo "")
            manifest_snapshot=$(jq -r '.manifest_snapshot // empty' "$exhibit" 2>/dev/null || echo "")
            receipt_required=$(jq -r '.receipt_required // false' "$exhibit" 2>/dev/null || echo "false")
            receipt_snapshot=$(jq -r '.receipt_snapshot // empty' "$exhibit" 2>/dev/null || echo "")
            receipt_digest=$(jq -r '.receipt_digest // empty' "$exhibit" 2>/dev/null || echo "")

            if [[ -z "$manifest_digest" ]]; then
                echo "[$name] FAIL: run exhibit missing manifest_digest"
                ((failed++))
                continue
            fi

            if [[ -z "$manifest_snapshot" ]]; then
                echo "[$name] FAIL: run exhibit missing manifest_snapshot"
                ((failed++))
                continue
            fi

            snapshot_path="${SCRIPT_DIR}/${manifest_snapshot}"
            if [[ ! -f "$snapshot_path" ]]; then
                echo "[$name] FAIL: manifest_snapshot file not found: $manifest_snapshot"
                ((failed++))
                continue
            fi

            # Verify manifest digest
            expected_hash="${manifest_digest#sha256:}"
            actual_hash=$(sha256_hash "$snapshot_path")

            if [[ "$expected_hash" != "$actual_hash" ]]; then
                echo "[$name] FAIL: manifest_digest mismatch"
                echo "  expected: sha256:$expected_hash"
                echo "  actual:   sha256:$actual_hash"
                ((failed++))
                continue
            fi

            # Verify receipt if required
            if [[ "$receipt_required" == "true" ]]; then
                if [[ -z "$receipt_snapshot" ]]; then
                    echo "[$name] FAIL: receipt_required but no receipt_snapshot"
                    ((failed++))
                    continue
                fi

                if [[ -z "$receipt_digest" ]]; then
                    echo "[$name] FAIL: receipt_required but no receipt_digest"
                    ((failed++))
                    continue
                fi

                receipt_path="${SCRIPT_DIR}/${receipt_snapshot}"
                if [[ ! -f "$receipt_path" ]]; then
                    echo "[$name] FAIL: receipt_snapshot file not found: $receipt_snapshot"
                    ((failed++))
                    continue
                fi

                expected_receipt_hash="${receipt_digest#sha256:}"
                actual_receipt_hash=$(sha256_hash "$receipt_path")

                if [[ "$expected_receipt_hash" != "$actual_receipt_hash" ]]; then
                    echo "[$name] FAIL: receipt_digest mismatch"
                    echo "  expected: sha256:$expected_receipt_hash"
                    echo "  actual:   sha256:$actual_receipt_hash"
                    ((failed++))
                    continue
                fi

                echo "[$name] PASS (manifest + receipt verified)"
                ((passed++))
            else
                echo "[$name] PASS (manifest verified)"
                ((passed++))
            fi
            ;;

        contracts)
            # Contracts exhibits verify contract digest format
            contracts_count=$(jq '.contracts | length' "$exhibit" 2>/dev/null || echo "0")

            if [[ "$contracts_count" -eq 0 ]]; then
                echo "[$name] FAIL: contracts exhibit has no contracts"
                ((failed++))
                continue
            fi

            all_valid=true
            for i in $(seq 0 $((contracts_count - 1))); do
                theorem_id=$(jq -r ".contracts[$i].theorem_id" "$exhibit" 2>/dev/null || echo "")
                contract_digest=$(jq -r ".contracts[$i].contract_digest" "$exhibit" 2>/dev/null || echo "")

                if [[ -z "$theorem_id" ]]; then
                    echo "[$name] FAIL: contract[$i] missing theorem_id"
                    all_valid=false
                    break
                fi

                if [[ -z "$contract_digest" || ! "$contract_digest" =~ ^sha256:[a-f0-9]{64}$ ]]; then
                    echo "[$name] FAIL: contract $theorem_id has invalid digest: $contract_digest"
                    all_valid=false
                    break
                fi
            done

            if [[ "$all_valid" == "true" ]]; then
                echo "[$name] PASS ($contracts_count contracts verified)"
                ((passed++))
            else
                ((failed++))
            fi
            ;;

        fresh_clone)
            # Fresh clone exhibits verify each file's sha256
            files_count=$(jq '.files | length' "$exhibit" 2>/dev/null || echo "0")

            if [[ "$files_count" -eq 0 ]]; then
                echo "[$name] FAIL: fresh_clone exhibit has no files"
                ((failed++))
                continue
            fi

            all_valid=true
            for i in $(seq 0 $((files_count - 1))); do
                file_path=$(jq -r ".files[$i].path" "$exhibit" 2>/dev/null || echo "")
                expected_sha=$(jq -r ".files[$i].sha256" "$exhibit" 2>/dev/null || echo "")

                if [[ -z "$file_path" ]]; then
                    echo "[$name] FAIL: files[$i] missing path"
                    all_valid=false
                    break
                fi

                full_path="${SCRIPT_DIR}/${file_path}"
                if [[ ! -f "$full_path" ]]; then
                    echo "[$name] FAIL: file not found: $file_path"
                    all_valid=false
                    break
                fi

                actual_sha=$(sha256_hash "$full_path")
                if [[ "$expected_sha" != "$actual_sha" ]]; then
                    echo "[$name] FAIL: sha256 mismatch for $file_path"
                    echo "  expected: $expected_sha"
                    echo "  actual:   $actual_sha"
                    all_valid=false
                    break
                fi
            done

            if [[ "$all_valid" == "true" ]]; then
                echo "[$name] PASS ($files_count files verified)"
                ((passed++))
            else
                ((failed++))
            fi
            ;;

        *)
            echo "[$name] SKIP (unknown kind: $kind)"
            ((skipped++))
            ;;
    esac
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
