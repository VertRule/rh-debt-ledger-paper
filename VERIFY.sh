#!/bin/sh
# VERIFY.sh - Deterministic verification script for rh-debt-ledger-paper
# Checks: clean state, remote alignment, required files, forbidden artifacts, redaction, exhibit digest
set -e

EXPECTED_REMOTE="git@github.com:VertRule/rh-debt-ledger-paper.git"
ERRORS=0

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
echo "[1/7] Checking git status..."
if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
    warn "Working tree is dirty (uncommitted changes present)"
fi
if [ -n "$(git status --porcelain 2>/dev/null)" ]; then
    warn "Untracked or modified files present"
fi
echo "  OK (or warnings above)"

# 2) Verify remote URL
echo "[2/7] Checking remote URL..."
ACTUAL_REMOTE=$(git remote get-url origin 2>/dev/null || echo "")
if [ "$ACTUAL_REMOTE" != "$EXPECTED_REMOTE" ]; then
    error "Remote mismatch: expected '$EXPECTED_REMOTE', got '$ACTUAL_REMOTE'"
else
    echo "  OK: $ACTUAL_REMOTE"
fi

# 3) Verify local HEAD equals origin/main
echo "[3/7] Fetching and comparing with origin/main..."
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

# 4) Verify required tracked files exist
echo "[4/7] Checking required files..."
REQUIRED_FILES="README.md SUBMISSION.md EXHIBITS.md exhibits/canonical_run.json na0_rh_debt_ledger_draft.md .gitignore"
for f in $REQUIRED_FILES; do
    if [ ! -f "$f" ]; then
        error "Required file missing: $f"
    fi
done
echo "  OK: All required files present"

# 5) Verify forbidden artifacts are NOT tracked
echo "[5/7] Checking forbidden artifacts are not tracked..."
FORBIDDEN_PATTERNS="paper_runs/ runs/ analysis/ proofs/ series.csv zeros_used.csv"
TRACKED_FILES=$(git ls-files 2>/dev/null)
for pattern in $FORBIDDEN_PATTERNS; do
    if echo "$TRACKED_FILES" | grep -q "$pattern"; then
        error "Forbidden artifact is tracked: $pattern"
    fi
done
echo "  OK: No forbidden artifacts tracked"

# 6) Paranoia grep for machine-specific paths
# Note: patterns are split to avoid self-matching
echo "[6/7] Running redaction scan..."
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

# 7) Run exhibit digest verification (soft dependency)
echo "[7/7] Running exhibit digest verification..."
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

echo ""
if [ "$ERRORS" -gt 0 ]; then
    echo "=== VERIFICATION FAILED: $ERRORS error(s) ==="
    exit 1
else
    echo "=== VERIFICATION PASSED ==="
    exit 0
fi
