# Admin Checklist: Branch Protection for `main`

Go to: Settings > Branches > Add branch protection rule

**Branch name pattern:** `main`

## Required Settings

- [x] **Require a pull request before merging**
  - [x] Require approvals: 1
  - [x] Dismiss stale pull request approvals when new commits are pushed
  - [x] Require review from Code Owners

- [x] **Require status checks to pass before merging**
  - [x] Require branches to be up to date before merging
  - [x] Status checks that are required:
    - `verify`

- [x] **Block force pushes**

- [x] **Block deletions**

## Optional Settings

- [ ] Restrict who can push to matching branches
- [ ] Require linear history
- [ ] Require signed commits
- [ ] Do not allow bypassing the above settings (recommended for strict governance)

## Verification

After enabling, test by:
1. Create a branch with a change that breaks `./VERIFY.sh`
2. Open a PR
3. Confirm the `verify` check fails and merge is blocked
