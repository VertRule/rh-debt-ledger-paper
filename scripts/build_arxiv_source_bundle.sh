#!/bin/sh
# build_arxiv_source_bundle.sh - Build deterministic arXiv source bundle
# Usage: scripts/build_arxiv_source_bundle.sh /path/to/output.zip
#
# Produces a deterministic zip containing only LaTeX sources suitable for
# arXiv submission. arXiv compiles its own PDF from sources.
#
# Outputs:
#   - User-specified zip file
#   - proof_artifacts/R26_ARXIV_SUBMISSION/arxiv/SOURCE_BUNDLE_MANIFEST.txt
#   - proof_artifacts/R26_ARXIV_SUBMISSION/arxiv/arxiv_source_bundle.sha256
set -e

if [ $# -lt 1 ]; then
    echo "Usage: $0 <output_zip_path>" >&2
    exit 1
fi

OUT_ZIP="$(cd "$(dirname "$1")" 2>/dev/null && pwd)/$(basename "$1")" || {
    # Directory doesn't exist yet, use path as-is after creating parent
    mkdir -p "$(dirname "$1")"
    OUT_ZIP="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
ARXIV_DIR="$REPO_ROOT/proof_artifacts/R26_ARXIV_SUBMISSION/arxiv"

# Create temp staging directory
STAGE="$(mktemp -d /tmp/arxiv_bundle_XXXXXX)"
trap 'rm -rf "$STAGE"' EXIT

# Source files to include
mkdir -p "$STAGE/sections"

# Copy main.tex
cp "$REPO_ROOT/paper/main.tex" "$STAGE/main.tex"

# Copy all section files
for f in "$REPO_ROOT/paper/sections"/*.tex; do
    if [ -f "$f" ]; then
        cp "$f" "$STAGE/sections/"
    fi
done

# Copy bibliography
cp "$REPO_ROOT/paper/bib.bib" "$STAGE/bib.bib"

# Generate manifest (sorted list of files)
(cd "$STAGE" && find . -type f | sed 's|^\./||' | LC_ALL=C sort) > "$STAGE/MANIFEST.txt"

# Build deterministic zip
rm -f "$OUT_ZIP"
(cd "$STAGE" && find . -type f | sed 's|^\./||' | LC_ALL=C sort | zip -X "$OUT_ZIP" -@) >/dev/null

# Compute SHA-256
if command -v sha256sum >/dev/null 2>&1; then
    SHA256=$(sha256sum "$OUT_ZIP" | awk '{print $1}')
elif command -v shasum >/dev/null 2>&1; then
    SHA256=$(shasum -a 256 "$OUT_ZIP" | awk '{print $1}')
else
    echo "ERROR: No sha256 tool found" >&2
    exit 1
fi

# Write outputs to R26 directory
mkdir -p "$ARXIV_DIR"
cp "$STAGE/MANIFEST.txt" "$ARXIV_DIR/SOURCE_BUNDLE_MANIFEST.txt"
echo "$SHA256" > "$ARXIV_DIR/arxiv_source_bundle.sha256"

echo "Created: $OUT_ZIP"
echo "SHA256:  $SHA256"
echo "Manifest: $ARXIV_DIR/SOURCE_BUNDLE_MANIFEST.txt"
