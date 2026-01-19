#!/usr/bin/env bash
set -euo pipefail

# VERIFY_FRESH_CLONE.sh - Fresh clone verification for rh-debt-ledger-paper
# Two-phase verification:
#   Phase 1: Clone and verify (no files written inside clone)
#   Phase 2: Capture outputs outside clone, optionally vendor into exhibits
#
# Usage:
#   ./VERIFY_FRESH_CLONE.sh           # Verify only, no repo modifications
#   ./VERIFY_FRESH_CLONE.sh --vendor  # Verify and update exhibits/fresh_clone_verify/
#
# Environment variables:
#   VR_FRESH_CLONE_LOCAL=1  - Clone from current directory instead of remote (for CI)

# Portable sha256 functions (works on macOS and Linux)
sha256_hash() {
    if command -v sha256sum &> /dev/null; then
        sha256sum "$1" | cut -d' ' -f1
    else
        shasum -a 256 "$1" | cut -d' ' -f1
    fi
}

sha256_files() {
    if command -v sha256sum &> /dev/null; then
        sha256sum "$@"
    else
        shasum -a 256 "$@"
    fi
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="/tmp/vr_paper_fresh_clone_verify"
CLONE_DIR="$BASE_DIR/clone"
OUT_DIR="$BASE_DIR/out"

# Use local clone for CI (avoids SSH auth requirements)
if [[ "${VR_FRESH_CLONE_LOCAL:-0}" == "1" ]]; then
    REPO_URL="$SCRIPT_DIR"
else
    REPO_URL="git@github.com:VertRule/rh-debt-ledger-paper.git"
fi

VENDOR_MODE=false
if [[ "${1:-}" == "--vendor" ]]; then
    VENDOR_MODE=true
fi

echo "=== Fresh Clone Verification ==="
echo ""

# Clean up any previous run
if [[ -d "$BASE_DIR" ]]; then
    echo "Removing previous temp directory..."
    rm -rf "$BASE_DIR"
fi

mkdir -p "$CLONE_DIR" "$OUT_DIR"

# Phase 1: Clone and verify
echo "Cloning $REPO_URL..."
git clone --quiet "$REPO_URL" "$CLONE_DIR/repo"

REPO_DIR="$CLONE_DIR/repo"

# If cloned locally, set origin to the canonical remote URL for VERIFY.sh checks
if [[ "${VR_FRESH_CLONE_LOCAL:-0}" == "1" ]]; then
    (cd "$REPO_DIR" && git remote set-url origin "git@github.com:VertRule/rh-debt-ledger-paper.git")
fi

echo "HEAD: $(cd "$REPO_DIR" && git rev-parse --short HEAD)"
echo ""

# Run verifiers with output captured OUTSIDE the clone
echo "Running VERIFY.sh..."
if ! (cd "$REPO_DIR" && ./VERIFY.sh) > "$OUT_DIR/verify.out" 2>&1; then
    cat "$OUT_DIR/verify.out"
    echo "VERIFY.sh FAILED"
    exit 1
fi

echo "Running VERIFY_EXHIBIT.sh..."
if ! (cd "$REPO_DIR" && ./VERIFY_EXHIBIT.sh) > "$OUT_DIR/verify_exhibit.out" 2>&1; then
    cat "$OUT_DIR/verify_exhibit.out"
    echo "VERIFY_EXHIBIT.sh FAILED"
    exit 1
fi

echo "Running VERIFY_ALL_EXHIBITS.sh..."
if ! (cd "$REPO_DIR" && ./VERIFY_ALL_EXHIBITS.sh) > "$OUT_DIR/verify_all_exhibits.out" 2>&1; then
    cat "$OUT_DIR/verify_all_exhibits.out"
    echo "VERIFY_ALL_EXHIBITS.sh FAILED"
    exit 1
fi

# Assert clone is still clean
echo "Checking clone is clean..."
DIRTY=$(cd "$REPO_DIR" && git status --porcelain)
if [[ -n "$DIRTY" ]]; then
    echo "FAIL: Clone has uncommitted changes after verification:"
    echo "$DIRTY"
    exit 1
fi
echo "  OK: Clone is clean"
echo ""

# Phase 2: Scrub outputs and compute hashes
echo "Scrubbing machine-specific paths..."
for f in "$OUT_DIR"/*.out; do
    # Remove /tmp/... paths and normalize /Users/<name> to /Users/REDACTED
    sed -i.bak -e 's|/tmp/[^ ]*||g' -e 's|/Users/[^/]*/|/Users/REDACTED/|g' "$f"
    rm -f "$f.bak"
done

# Compute sha256 bundle
echo "Computing sha256 checksums..."
(cd "$OUT_DIR" && sha256_files verify_all_exhibits.out verify_exhibit.out verify.out > verify_outputs.sha256)

echo ""
echo "=== Verification Outputs ==="
cat "$OUT_DIR/verify_outputs.sha256"
echo ""

# Show summary
echo "=== Summary ==="
grep -A4 "^=== Summary ===" "$OUT_DIR/verify_all_exhibits.out" || true
echo ""

# Phase 2b: Vendor if requested
if [[ "$VENDOR_MODE" == "true" ]]; then
    echo "=== Vendoring outputs to exhibits/fresh_clone_verify/ ==="
    EXHIBIT_DIR="$SCRIPT_DIR/exhibits/fresh_clone_verify"
    mkdir -p "$EXHIBIT_DIR"

    cp "$OUT_DIR/verify_all_exhibits.out" "$EXHIBIT_DIR/"
    cp "$OUT_DIR/verify_exhibit.out" "$EXHIBIT_DIR/"
    cp "$OUT_DIR/verify.out" "$EXHIBIT_DIR/"
    cp "$OUT_DIR/verify_outputs.sha256" "$EXHIBIT_DIR/"

    # Update exhibit pointer JSON with new hashes
    SHA_ALL=$(sha256_hash "$EXHIBIT_DIR/verify_all_exhibits.out")
    SHA_EXHIBIT=$(sha256_hash "$EXHIBIT_DIR/verify_exhibit.out")
    SHA_VERIFY=$(sha256_hash "$EXHIBIT_DIR/verify.out")

    cat > "$SCRIPT_DIR/exhibits/fresh_clone_verify.json" << EOF
{
  "schema": "paper_exhibit_pointer.v1",
  "kind": "fresh_clone",
  "name": "fresh_clone_verify_$(date +%Y-%m-%d)",
  "description": "Fresh clone verification outputs from clean temp directory",
  "files": [
    {
      "path": "exhibits/fresh_clone_verify/verify_all_exhibits.out",
      "sha256": "$SHA_ALL"
    },
    {
      "path": "exhibits/fresh_clone_verify/verify_exhibit.out",
      "sha256": "$SHA_EXHIBIT"
    },
    {
      "path": "exhibits/fresh_clone_verify/verify.out",
      "sha256": "$SHA_VERIFY"
    }
  ],
  "bundle_sha256_file": "exhibits/fresh_clone_verify/verify_outputs.sha256"
}
EOF

    echo "  Updated: exhibits/fresh_clone_verify/"
    echo "  Updated: exhibits/fresh_clone_verify.json"
    echo ""
fi

echo "=== FRESH CLONE VERIFICATION PASSED ==="
echo "Outputs saved to: $OUT_DIR/"
