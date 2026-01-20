#!/bin/sh
# VERIFY.sh - Deterministic verification script for rh-debt-ledger-paper
# Checks: clean state, remote alignment, required files, forbidden artifacts, redaction, exhibit digest
#
# Environment variables:
#   VR_STRICT=1  - Treat dirty working tree as error (default: warning only)
set -e

EXPECTED_REMOTE_SSH="git@github.com:VertRule/rh-debt-ledger-paper.git"
EXPECTED_REMOTE_HTTPS="https://github.com/VertRule/rh-debt-ledger-paper"
ERRORS=0
DIRTY_TREE=0

error() {
    echo "ERROR: $1" >&2
    ERRORS=$((ERRORS + 1))
}

warn() {
    echo "WARNING: $1" >&2
}

echo "=== RH Debt Ledger Paper Verification ==="
echo ""

# 1) Check git clean status
echo "[1/22] Checking git status..."
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    warn "Working tree is dirty (uncommitted changes present)"
    DIRTY_TREE=1
fi
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    warn "Untracked or modified files present"
    DIRTY_TREE=1
fi
if [ "$DIRTY_TREE" -eq 0 ]; then
    echo "  OK: Working tree is clean"
else
    echo "  OK (warnings above)"
fi

# 2) Reject Co-Authored-By trailers in commits after cutoff
echo "[2/22] Checking for Co-Authored-By trailers..."
COAUTHOR_CUTOFF="92cfc2d"
COAUTHOR_MATCHES=$(git log "${COAUTHOR_CUTOFF}..HEAD" --format=%B 2>/dev/null | grep -n "^Co-Authored-By:" || true)
if [ -n "$COAUTHOR_MATCHES" ]; then
    echo "$COAUTHOR_MATCHES"
    error "Co-Authored-By trailer found in commits after $COAUTHOR_CUTOFF (see AUTHORSHIP.md)"
else
    echo "  OK: No Co-Authored-By trailers in recent commits"
fi

# 3) Verify remote URL (accept SSH or HTTPS)
echo "[3/22] Checking remote URL..."
ACTUAL_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$ACTUAL_REMOTE" = "$EXPECTED_REMOTE_SSH" ] || [ "$ACTUAL_REMOTE" = "$EXPECTED_REMOTE_HTTPS" ]; then
    echo "  OK: $ACTUAL_REMOTE"
else
    error "Remote mismatch: got '$ACTUAL_REMOTE'"
fi

# 4) Verify local HEAD equals origin/main
echo "[4/22] Fetching and comparing with origin/main..."
git fetch origin main --quiet 2>/dev/null || warn "Could not fetch origin/main"
LOCAL_HEAD=$(git rev-parse HEAD 2>/dev/null || echo "")
REMOTE_HEAD=$(git rev-parse origin/main 2>/dev/null || echo "")
if [ -z "$LOCAL_HEAD" ] || [ -z "$REMOTE_HEAD" ]; then
    warn "Could not compare HEAD with origin/main"
elif [ "$LOCAL_HEAD" != "$REMOTE_HEAD" ]; then
    warn "HEAD ($LOCAL_HEAD) differs from origin/main ($REMOTE_HEAD)"
else
    echo "  OK: HEAD matches origin/main"
fi

# 5) Verify required tracked files exist
echo "[5/22] Checking required files..."
REQUIRED_FILES="README.md SUBMISSION.md EXHIBITS.md exhibits/canonical_run.json na0_rh_debt_ledger_draft.md .gitignore"
for f in $REQUIRED_FILES; do
    if [ ! -f "$f" ]; then
        error "Required file missing: $f"
    fi
done
echo "  OK: All required files present"

# 6) Verify forbidden artifacts are NOT tracked
echo "[6/22] Checking forbidden artifacts are not tracked..."
FORBIDDEN_PATTERNS="paper_runs/ runs/ analysis/ proofs/ series.csv zeros_used.csv"
TRACKED_FILES=$(git ls-files 2>/dev/null)
for pattern in $FORBIDDEN_PATTERNS; do
    if echo "$TRACKED_FILES" | grep -q "$pattern"; then
        error "Forbidden artifact is tracked: $pattern"
    fi
done
echo "  OK: No forbidden artifacts tracked"

# 7) Paranoia grep for machine-specific paths
# Note: patterns are split to avoid self-matching
echo "[7/22] Running redaction scan..."
USERS_PATTERN="/Us""ers/"
MACBOOK_PATTERN="Davids""-MacBook"
MATCHES=$(git ls-files | xargs grep -l -i "$USERS_PATTERN" 2>/dev/null | grep -v 'VERIFY' || true)
if [ -n "$MATCHES" ]; then
    echo "$MATCHES"
    error "Found '$USERS_PATTERN' path in tracked files (redaction failure)"
fi
MATCHES=$(git ls-files | xargs grep -l -i "$MACBOOK_PATTERN" 2>/dev/null | grep -v 'VERIFY' || true)
if [ -n "$MATCHES" ]; then
    echo "$MATCHES"
    error "Found '$MACBOOK_PATTERN' in tracked files (redaction failure)"
fi
echo "  OK: No machine-specific paths found"

# 8) Run exhibit digest verification (soft dependency)
echo "[8/22] Running exhibit digest verification..."
if [ -x "./VERIFY_EXHIBIT.sh" ]; then
    set +e
    EXHIBIT_OUTPUT=$(./VERIFY_EXHIBIT.sh 2>&1)
    EXHIBIT_EXIT=$?
    set -e
    if echo "$EXHIBIT_OUTPUT" | grep -q "^SKIP:"; then
        echo "  SKIP: Experiment repo not available"
    elif [ "$EXHIBIT_EXIT" -eq 0 ]; then
        echo "  OK: Exhibit digest verified"
    else
        echo "$EXHIBIT_OUTPUT"
        error "Exhibit digest verification failed"
    fi
else
    echo "  SKIP: VERIFY_EXHIBIT.sh not found or not executable"
fi

# 9) Run verify-all-exhibits (soft dependency)
echo "[9/22] Running verify-all-exhibits..."
if [ -x "./VERIFY_ALL_EXHIBITS.sh" ]; then
    set +e
    ALL_EXHIBITS_OUTPUT=$(./VERIFY_ALL_EXHIBITS.sh 2>&1)
    ALL_EXHIBITS_EXIT=$?
    set -e
    if echo "$ALL_EXHIBITS_OUTPUT" | grep -q "VERIFICATION PASSED"; then
        echo "  OK: All exhibits verified"
    elif echo "$ALL_EXHIBITS_OUTPUT" | grep -q "Skipped:"; then
        echo "  OK: All exhibits verified (some skipped)"
    else
        echo "$ALL_EXHIBITS_OUTPUT"
        if [ "$ALL_EXHIBITS_EXIT" -ne 0 ]; then
            error "Verify-all-exhibits failed"
        fi
    fi
else
    echo "  SKIP: VERIFY_ALL_EXHIBITS.sh not found or not executable"
fi

# 10) Verify proof artifact integrity (soft dependency)
echo "[10/22] Verifying proof artifacts..."
if [ -x "./VERIFY_ALL_PROOF_ARTIFACTS.sh" ]; then
    set +e
    PROOF_ARTIFACTS_OUTPUT=$(./VERIFY_ALL_PROOF_ARTIFACTS.sh 2>&1)
    PROOF_ARTIFACTS_EXIT=$?
    set -e
    if [ "$PROOF_ARTIFACTS_EXIT" -eq 0 ]; then
        echo "  OK: Proof artifact integrity verified"
    else
        echo "$PROOF_ARTIFACTS_OUTPUT"
        error "Proof artifact verification failed"
    fi
else
    echo "  SKIP: VERIFY_ALL_PROOF_ARTIFACTS.sh not found or not executable"
fi

# 11) Verify contribution ledger integrity
echo "[11/22] Checking contribution ledger..."
LEDGER_FILE=".github/CONTRIBUTION_LEDGER.md"
LEDGER_ERRORS=0
if [ ! -f "$LEDGER_FILE" ]; then
    error "Contribution ledger missing: $LEDGER_FILE"
    LEDGER_ERRORS=1
else
    if ! grep -qi "operator-led" "$LEDGER_FILE"; then
        error "Contribution ledger missing 'operator-led' declaration"
        LEDGER_ERRORS=1
    fi
    if ! grep -qi "do not claim" "$LEDGER_FILE"; then
        error "Contribution ledger missing epistemic boundary ('do not claim')"
        LEDGER_ERRORS=1
    fi
fi
if [ "$LEDGER_ERRORS" -eq 0 ]; then
    echo "  OK: Contribution ledger integrity verified"
fi

# 12) Verify R4 transfer packet integrity (soft dependency)
echo "[12/22] Verifying R4 transfer packet..."
if [ -x "./VERIFY_R4_TRANSFER.sh" ]; then
    set +e
    R4_OUTPUT=$(./VERIFY_R4_TRANSFER.sh 2>&1)
    R4_EXIT=$?
    set -e
    if [ "$R4_EXIT" -eq 0 ]; then
        echo "  OK: R4 transfer packet integrity verified"
    else
        echo "$R4_OUTPUT"
        error "R4 transfer packet verification failed"
    fi
else
    echo "  SKIP: VERIFY_R4_TRANSFER.sh not found or not executable"
fi

# 13) Verify R5 error-bound source integrity (soft dependency)
echo "[13/22] Verifying R5 error-bound source..."
if [ -x "./VERIFY_R5_ERROR_BOUND.sh" ]; then
    set +e
    R5_OUTPUT=$(./VERIFY_R5_ERROR_BOUND.sh 2>&1)
    R5_EXIT=$?
    set -e
    if [ "$R5_EXIT" -eq 0 ]; then
        echo "  OK: R5 error-bound source integrity verified"
    else
        echo "$R5_OUTPUT"
        error "R5 error-bound source verification failed"
    fi
else
    echo "  SKIP: VERIFY_R5_ERROR_BOUND.sh not found or not executable"
fi

# 14) Verify R6 instantiation record integrity (soft dependency)
echo "[14/22] Verifying R6 instantiation record..."
if [ -x "./VERIFY_R6_INSTANTIATION.sh" ]; then
    set +e
    R6_OUTPUT=$(./VERIFY_R6_INSTANTIATION.sh 2>&1)
    R6_EXIT=$?
    set -e
    if [ "$R6_EXIT" -eq 0 ]; then
        echo "  OK: R6 instantiation record integrity verified"
    else
        echo "$R6_OUTPUT"
        error "R6 instantiation record verification failed"
    fi
else
    echo "  SKIP: VERIFY_R6_INSTANTIATION.sh not found or not executable"
fi

# 15) Verify R7 bound statement integrity (soft dependency)
echo "[15/22] Verifying R7 bound statement..."
if [ -x "./VERIFY_R7_BOUND_STATEMENT.sh" ]; then
    set +e
    R7_OUTPUT=$(./VERIFY_R7_BOUND_STATEMENT.sh 2>&1)
    R7_EXIT=$?
    set -e
    if [ "$R7_EXIT" -eq 0 ]; then
        echo "  OK: R7 bound statement integrity verified"
    else
        echo "$R7_OUTPUT"
        error "R7 bound statement verification failed"
    fi
else
    echo "  SKIP: VERIFY_R7_BOUND_STATEMENT.sh not found or not executable"
fi

# 16) Verify R8 comparison run integrity (soft dependency)
echo "[16/22] Verifying R8 comparison run..."
if [ -x "./VERIFY_R8_COMPARISON.sh" ]; then
    set +e
    R8_OUTPUT=$(./VERIFY_R8_COMPARISON.sh 2>&1)
    R8_EXIT=$?
    set -e
    if [ "$R8_EXIT" -eq 0 ]; then
        echo "  OK: R8 comparison run integrity verified"
    else
        echo "$R8_OUTPUT"
        error "R8 comparison run verification failed"
    fi
else
    echo "  SKIP: VERIFY_R8_COMPARISON.sh not found or not executable"
fi

# 17) Verify R9 no-surprise assembly (soft dependency)
echo "[17/22] Verifying R9 no-surprise assembly..."
if [ -x "./VERIFY_R9_NO_SURPRISE.sh" ]; then
    set +e
    R9_OUTPUT=$(./VERIFY_R9_NO_SURPRISE.sh 2>&1)
    R9_EXIT=$?
    set -e
    if [ "$R9_EXIT" -eq 0 ]; then
        echo "  OK: R9 no-surprise assembly verified"
    else
        echo "$R9_OUTPUT"
        error "R9 no-surprise assembly verification failed"
    fi
else
    echo "  SKIP: VERIFY_R9_NO_SURPRISE.sh not found or not executable"
fi

# 18) Verify R10 assembly receipt (soft dependency)
echo "[18/22] Verifying R10 assembly receipt..."
if [ -x "./VERIFY_R10_ASSEMBLY_RECEIPT.sh" ]; then
    set +e
    R10_OUTPUT=$(./VERIFY_R10_ASSEMBLY_RECEIPT.sh 2>&1)
    R10_EXIT=$?
    set -e
    if [ "$R10_EXIT" -eq 0 ]; then
        echo "  OK: R10 assembly receipt verified"
    else
        echo "$R10_OUTPUT"
        error "R10 assembly receipt verification failed"
    fi
else
    echo "  SKIP: VERIFY_R10_ASSEMBLY_RECEIPT.sh not found or not executable"
fi

# 19) Verify R11 optional signature (soft dependency)
echo "[19/22] Verifying R11 optional signature..."
if [ -x "./VERIFY_R11_SIGNATURE.sh" ]; then
    set +e
    R11_OUTPUT=$(./VERIFY_R11_SIGNATURE.sh 2>&1)
    R11_EXIT=$?
    set -e
    if [ "$R11_EXIT" -eq 0 ]; then
        echo "  OK: R11 optional signature verified"
    else
        echo "$R11_OUTPUT"
        error "R11 optional signature verification failed"
    fi
else
    echo "  SKIP: VERIFY_R11_SIGNATURE.sh not found or not executable"
fi

# 20) Verify R14 key capture receipts (soft dependency)
echo "[20/22] Verifying R14 key capture receipts..."
if [ -x "./VERIFY_R14_KEY_CAPTURE.sh" ]; then
    set +e
    R14_OUTPUT=$(./VERIFY_R14_KEY_CAPTURE.sh 2>&1)
    R14_EXIT=$?
    set -e
    if [ "$R14_EXIT" -eq 0 ]; then
        echo "  OK: R14 key capture receipts verified"
    else
        echo "$R14_OUTPUT"
        error "R14 key capture verification failed"
    fi
else
    echo "  SKIP: VERIFY_R14_KEY_CAPTURE.sh not found or not executable"
fi

# 21) Verify R15 optional PQ signatures (soft dependency)
echo "[21/22] Verifying R15 optional PQ signatures..."
if [ -x "./VERIFY_R15_PQ_SIGNATURE.sh" ]; then
    set +e
    R15_OUTPUT=$(./VERIFY_R15_PQ_SIGNATURE.sh 2>&1)
    R15_EXIT=$?
    set -e
    if [ "$R15_EXIT" -eq 0 ]; then
        echo "  OK: R15 optional PQ signatures verified"
    else
        echo "$R15_OUTPUT"
        error "R15 PQ signature verification failed"
    fi
else
    echo "  SKIP: VERIFY_R15_PQ_SIGNATURE.sh not found or not executable"
fi

# 22) Verify R16 PQ tooling receipt (soft dependency)
echo "[22/22] Verifying R16 PQ tooling receipt..."
if [ -x "./VERIFY_R16_PQ_TOOLING.sh" ]; then
    set +e
    R16_OUTPUT=$(./VERIFY_R16_PQ_TOOLING.sh 2>&1)
    R16_EXIT=$?
    set -e
    if [ "$R16_EXIT" -eq 0 ]; then
        echo "  OK: R16 PQ tooling receipt verified"
    else
        echo "$R16_OUTPUT"
        error "R16 PQ tooling verification failed"
    fi
else
    echo "  SKIP: VERIFY_R16_PQ_TOOLING.sh not found or not executable"
fi

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "=== VERIFICATION FAILED: $ERRORS error(s) ==="
    exit 1
fi

# In strict mode, dirty tree is an error
if [ "${VR_STRICT:-0}" = "1" ] && [ "$DIRTY_TREE" -eq 1 ]; then
    echo "=== VERIFICATION FAILED: Dirty tree in strict mode ==="
    exit 1
fi

echo "=== VERIFICATION PASSED ==="
exit 0
