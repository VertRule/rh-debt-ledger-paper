#!/bin/sh
# build_paper_deterministic_local.sh - Deterministic local paper build
# Usage: scripts/build_paper_deterministic_local.sh
#
# Outputs:
#   proof_artifacts/R24_PAPER_BUILD/outputs/main.pdf
#   proof_artifacts/R24_PAPER_BUILD/outputs/main.pdf.sha256
#   proof_artifacts/R24_PAPER_BUILD/outputs/build.log
#
# Guarantees:
#   - Same source + toolchain produces identical PDF on repeated runs
#   - Uses SOURCE_DATE_EPOCH for reproducible timestamps
#   - Runs build twice and verifies determinism
#
# Requirements:
#   - latexmk (preferred) or pdflatex
#   - Standard TeX Live packages used by paper/main.tex
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$REPO_ROOT/proof_artifacts/R24_PAPER_BUILD/outputs"
PAPER_DIR="$REPO_ROOT/paper"

# Set deterministic environment
export TZ=UTC
export LC_ALL=C
export LANG=C
# SOURCE_DATE_EPOCH: 2025-01-01 00:00:00 UTC
export SOURCE_DATE_EPOCH=1735689600
export FORCE_SOURCE_DATE=1

# Check for TeX toolchain
HAS_LATEXMK=0
HAS_PDFLATEX=0

if command -v latexmk >/dev/null 2>&1; then
    HAS_LATEXMK=1
fi
if command -v pdflatex >/dev/null 2>&1; then
    HAS_PDFLATEX=1
fi

if [ "$HAS_LATEXMK" -eq 0 ] && [ "$HAS_PDFLATEX" -eq 0 ]; then
    echo "ERROR: No TeX toolchain found." >&2
    echo "Install latexmk (preferred) or pdflatex to build the paper." >&2
    exit 1
fi

# Ensure output directory exists
mkdir -p "$OUTPUT_DIR"

# Create temp work directory
WORKDIR="$(mktemp -d /tmp/r24_build_XXXXXX)"
trap 'rm -rf "$WORKDIR"' EXIT

# Capture toolchain versions
echo "=== Toolchain Versions ===" > "$WORKDIR/versions.log"
echo "Date: $(date -u '+%Y-%m-%d %H:%M:%S UTC')" >> "$WORKDIR/versions.log"
echo "SOURCE_DATE_EPOCH: $SOURCE_DATE_EPOCH" >> "$WORKDIR/versions.log"
echo "" >> "$WORKDIR/versions.log"

if [ "$HAS_LATEXMK" -eq 1 ]; then
    echo "latexmk:" >> "$WORKDIR/versions.log"
    latexmk -v 2>&1 | head -5 >> "$WORKDIR/versions.log"
    echo "" >> "$WORKDIR/versions.log"
fi

if [ "$HAS_PDFLATEX" -eq 1 ]; then
    echo "pdflatex:" >> "$WORKDIR/versions.log"
    pdflatex --version 2>&1 | head -5 >> "$WORKDIR/versions.log"
    echo "" >> "$WORKDIR/versions.log"
fi

if command -v kpsewhich >/dev/null 2>&1; then
    echo "kpsewhich:" >> "$WORKDIR/versions.log"
    kpsewhich --version 2>&1 | head -3 >> "$WORKDIR/versions.log"
    echo "" >> "$WORKDIR/versions.log"
fi

# Function to run build
run_build() {
    local run_name="$1"
    local out_dir="$WORKDIR/$run_name"
    mkdir -p "$out_dir"

    echo "Running build ($run_name)..."

    if [ "$HAS_LATEXMK" -eq 1 ]; then
        # latexmk handles multiple passes automatically
        (cd "$PAPER_DIR" && latexmk -pdf -interaction=nonstopmode -halt-on-error \
            -output-directory="$out_dir" main.tex) > "$out_dir/build.log" 2>&1 || true
    else
        # Manual pdflatex: run twice for references
        (cd "$PAPER_DIR" && pdflatex -interaction=nonstopmode -halt-on-error \
            -output-directory="$out_dir" main.tex) > "$out_dir/build.log" 2>&1 || true
        (cd "$PAPER_DIR" && pdflatex -interaction=nonstopmode -halt-on-error \
            -output-directory="$out_dir" main.tex) >> "$out_dir/build.log" 2>&1 || true
    fi

    # Check if PDF was created
    if [ ! -f "$out_dir/main.pdf" ]; then
        echo "ERROR: Build failed ($run_name). See log:" >&2
        cat "$out_dir/build.log" >&2
        exit 1
    fi

    echo "$out_dir"
}

# Compute SHA256
compute_sha256() {
    local file="$1"
    if command -v sha256sum >/dev/null 2>&1; then
        sha256sum "$file" | awk '{print $1}'
    elif command -v shasum >/dev/null 2>&1; then
        shasum -a 256 "$file" | awk '{print $1}'
    else
        echo "ERROR: No sha256 tool found" >&2
        exit 1
    fi
}

# Run build twice
BUILD1=$(run_build "run1")
BUILD2=$(run_build "run2")

# Compute SHA256 for both runs
SHA1=$(compute_sha256 "$BUILD1/main.pdf")
SHA2=$(compute_sha256 "$BUILD2/main.pdf")

echo ""
echo "Run 1 SHA256: $SHA1"
echo "Run 2 SHA256: $SHA2"

# Verify determinism
if [ "$SHA1" != "$SHA2" ]; then
    echo ""
    echo "ERROR: Non-deterministic build detected!" >&2
    echo "Run 1: $SHA1" >&2
    echo "Run 2: $SHA2" >&2
    echo "" >&2
    echo "PDFs differ. Possible causes:" >&2
    echo "  - Timestamp leaks in TeX packages" >&2
    echo "  - Random/unstable ordering" >&2
    echo "  - SOURCE_DATE_EPOCH not honored" >&2
    exit 1
fi

echo ""
echo "PASS: Builds are deterministic"

# Copy final outputs
cp "$BUILD1/main.pdf" "$OUTPUT_DIR/main.pdf"
cat "$WORKDIR/versions.log" "$BUILD1/build.log" > "$OUTPUT_DIR/build.log"
echo "$SHA1" > "$OUTPUT_DIR/main.pdf.sha256"

echo ""
echo "=== Build Complete ==="
echo "PDF:    $OUTPUT_DIR/main.pdf"
echo "SHA256: $SHA1"
echo "Log:    $OUTPUT_DIR/build.log"
