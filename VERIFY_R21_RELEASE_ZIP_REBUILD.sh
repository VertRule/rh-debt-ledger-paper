#!/bin/sh
# VERIFY_R21_RELEASE_ZIP_REBUILD.sh - Verify release zip rebuild determinism
# Usage: ./VERIFY_R21_RELEASE_ZIP_REBUILD.sh <tag>
#
# This is a LOCAL verification script, not wired into CI.
# It verifies that the rebuild script produces identical output on repeated runs.
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <tag>" >&2
    exit 1
fi

TAG="$1"
REBUILD_SCRIPT="scripts/rebuild_release_zip.sh"

# Check rebuild script exists
if [ ! -x "$REBUILD_SCRIPT" ]; then
    echo "ERROR: Rebuild script not found or not executable: $REBUILD_SCRIPT" >&2
    exit 1
fi

# Create temp directory for test
TESTDIR="$(mktemp -d /tmp/r21_verify_XXXXXX)"
trap 'rm -rf "$TESTDIR"' EXIT

echo "Testing determinism for tag: $TAG"
echo ""

# Build first zip
echo "Building first zip..."
"$REBUILD_SCRIPT" "$TAG" "$TESTDIR/first.zip" > "$TESTDIR/first.log" 2>&1
FIRST_SHA=$(grep '^SHA256:' "$TESTDIR/first.log" | awk '{print $2}')
echo "First:  $FIRST_SHA"

# Build second zip
echo "Building second zip..."
"$REBUILD_SCRIPT" "$TAG" "$TESTDIR/second.zip" > "$TESTDIR/second.log" 2>&1
SECOND_SHA=$(grep '^SHA256:' "$TESTDIR/second.log" | awk '{print $2}')
echo "Second: $SECOND_SHA"

echo ""

# Compare
if [ "$FIRST_SHA" != "$SECOND_SHA" ]; then
    echo "FAIL: SHA256 mismatch"
    exit 1
fi

if ! cmp -s "$TESTDIR/first.zip" "$TESTDIR/second.zip"; then
    echo "FAIL: Byte comparison failed"
    exit 1
fi

echo "PASS: Deterministic rebuild verified"
echo "  - SHA256 matches"
echo "  - Byte-identical zips"
exit 0
