#!/bin/sh
# VERIFY_R31_NO_TOKEN_LEAK.sh - Verify no arXiv endorsement tokens in repo
#
# Scans tracked files for:
#   - arxiv.org/auth/endorse URLs
#   - endorse?x= query parameters
#
# Exit 0 if clean, exit 1 if tokens found
set -e

ERRORS=0

# Get list of tracked files (excluding verifier, gitignored, and endorsement documentation)
# R27 and R31 documentation explain token format but contain no actual tokens (uses <CODE> placeholder)
TRACKED_FILES=$(git ls-files 2>/dev/null | grep -v 'VERIFY_R31_NO_TOKEN_LEAK.sh' | grep -v 'operator_private/' | grep -v 'R27_ENDORSEMENT_PATH/' | grep -v 'R31_ENDORSEMENT_OUTREACH/' || true)

if [ -z "$TRACKED_FILES" ]; then
    echo "No tracked files to scan"
    exit 0
fi

# Pattern 1: arxiv.org/auth/endorse (endorsement URL path)
# Split pattern to avoid self-match
PATTERN1="arxiv.org/auth/end""orse"
MATCHES1=$(echo "$TRACKED_FILES" | xargs grep -l "$PATTERN1" 2>/dev/null || true)
if [ -n "$MATCHES1" ]; then
    echo "ERROR: Found arxiv endorsement URL in tracked files:"
    echo "$MATCHES1"
    ERRORS=$((ERRORS + 1))
fi

# Pattern 2: endorse?x= (token query parameter)
# Split pattern to avoid self-match
PATTERN2="end""orse?x="
MATCHES2=$(echo "$TRACKED_FILES" | xargs grep -l "$PATTERN2" 2>/dev/null || true)
if [ -n "$MATCHES2" ]; then
    echo "ERROR: Found endorsement token parameter in tracked files:"
    echo "$MATCHES2"
    ERRORS=$((ERRORS + 1))
fi

if [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "Token leak detected! Remove endorsement URLs/codes from tracked files."
    echo "Store tokens in operator_private/ (gitignored)."
    exit 1
fi

exit 0
