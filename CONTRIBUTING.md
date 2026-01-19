# Contributing

## Pull Request Requirements

All pull requests must pass the `verify` workflow before merging:

- `VR_STRICT=1 ./VERIFY.sh` - strict verification (no dirty tree allowed)
- `./VERIFY_ALL_EXHIBITS.sh` - all exhibits must pass (no failures, no skips)
- `./VERIFY_FRESH_CLONE.sh` - fresh clone verification must pass

## Running Verification Locally

Before submitting a PR, run locally:

```bash
./VERIFY_ALL_EXHIBITS.sh
./VERIFY_EXHIBIT.sh
VR_STRICT=1 ./VERIFY.sh
VR_FRESH_CLONE_LOCAL=1 ./VERIFY_FRESH_CLONE.sh
```

All must pass with zero failures and zero skips.

## Recommended Branch Protection Settings

For repository administrators, recommended settings for the `main` branch:

- **Require status checks to pass before merging**
  - Required check: `verify`
- **Require branches to be up to date before merging**
- **Do not allow bypassing the above settings**
- **Block force pushes**
- **Require linear history** (optional, recommended)

## Authorship Policy

See [AUTHORSHIP.md](AUTHORSHIP.md) for authorship and attribution policy.
No `Co-Authored-By` trailers should be added to commits.
