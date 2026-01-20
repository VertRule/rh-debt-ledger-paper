#!/bin/sh
# capture_pq_tooling.sh - Capture PQ tooling backend and versions
# Usage: scripts/capture_pq_tooling.sh
# Produces: proof_artifacts/R16_PQ_TOOLING/R16_TOOLING_RECEIPT.json
set -e

OUTPUT_DIR="proof_artifacts/R16_PQ_TOOLING"
RECEIPT_FILE="$OUTPUT_DIR/R16_TOOLING_RECEIPT.json"
DIGEST_FILE="$OUTPUT_DIR/R16_TOOLING_RECEIPT.sha256"

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# Detect commands
OPENSSL_STATUS="absent"
OQS_TOOLBOX_STATUS="absent"

if command -v openssl >/dev/null 2>&1; then
    OPENSSL_STATUS="present"
fi

if command -v oqs-verify >/dev/null 2>&1; then
    OQS_TOOLBOX_STATUS="present"
fi

# Detect backend in priority order (same as verify_pq_sig.sh)
BACKEND="none"
BACKEND_VERSION="TBD"

# Check for oqsprovider module in known locations
OQS_MODULE_PATHS="${OPENSSL_MODULES:-} $HOME/.local/lib/ossl-modules /opt/homebrew/lib/ossl-modules /usr/local/lib/ossl-modules"

# Check openssl with oqsprovider first
if [ "$OPENSSL_STATUS" = "present" ]; then
    OQS_FOUND=""
    for modpath in $OQS_MODULE_PATHS; do
        if [ -d "$modpath" ] && { [ -f "$modpath/oqsprovider.dylib" ] || [ -f "$modpath/oqsprovider.so" ]; }; then
            # Try to load the provider using OPENSSL_MODULES env var
            if OPENSSL_MODULES="$modpath" openssl list -providers -provider oqsprovider 2>/dev/null | grep -q oqsprovider; then
                OQS_FOUND="$modpath"
                break
            fi
        fi
    done
    if [ -n "$OQS_FOUND" ]; then
        BACKEND="openssl-oqsprovider"
        # Get openssl version
        OPENSSL_VER=$(openssl version 2>/dev/null | head -1 || echo "unknown")
        # Get oqsprovider version
        PROVIDER_VER=$(OPENSSL_MODULES="$OQS_FOUND" openssl list -providers -provider oqsprovider 2>/dev/null | grep -A2 oqsprovider | grep version | sed 's/.*version: //' | tr -d ' ' || echo "unknown")
        if [ -n "$PROVIDER_VER" ] && [ "$PROVIDER_VER" != "unknown" ]; then
            BACKEND_VERSION="openssl:${OPENSSL_VER};oqsprovider:${PROVIDER_VER}"
        else
            BACKEND_VERSION="openssl:${OPENSSL_VER}"
        fi
    fi
fi

# Check oqs-toolbox if no openssl+oqsprovider
if [ "$BACKEND" = "none" ] && [ "$OQS_TOOLBOX_STATUS" = "present" ]; then
    BACKEND="oqs-toolbox"
    OQS_VER=$(oqs-verify --version 2>/dev/null | head -1 || echo "unknown")
    BACKEND_VERSION="$OQS_VER"
fi

# Write receipt (deterministic JSON, 2-space indent)
cat > "$RECEIPT_FILE" <<EOF
{
  "concept_tag": "RH-R16-PQ-TOOLING-RECEIPT",
  "backend": "$BACKEND",
  "backend_version": "$BACKEND_VERSION",
  "commands": {
    "openssl": "$OPENSSL_STATUS",
    "oqs-toolbox": "$OQS_TOOLBOX_STATUS"
  },
  "notes": "Optional. Present only when operator wants PQ verification to be auditable."
}
EOF

# Compute sha256
shasum -a 256 "$RECEIPT_FILE" | awk '{print $1}' > "$DIGEST_FILE"

echo "PQ tooling receipt captured:"
echo "  Backend: $BACKEND"
echo "  Version: $BACKEND_VERSION"
echo "  Receipt: $RECEIPT_FILE"
echo "  Digest:  $DIGEST_FILE"
