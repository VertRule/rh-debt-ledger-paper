# Release Checklist

**Concept-Tag:** RH-RELEASE-CHECKLIST

Before cutting any release, confirm all items:

## Pre-release

- [ ] `VR_STRICT=1 ./VERIFY.sh` passes on main
- [ ] Annotated tag created (`git tag -a <tag>`)
- [ ] Tag pushed to origin

## Asset build

- [ ] Release bundle built outside repo (e.g., `/tmp`)
- [ ] Bundle contains minimum verification surface
- [ ] No repo pollution from build artifacts

## GitHub release

- [ ] Release created from tag (`gh release create <tag>`)
- [ ] Asset uploaded (`gh release upload <tag> <asset>`)
- [ ] Release notes reference `VERIFY_QUICKSTART.md`
- [ ] Release notes state non-claims (no proof reproduction, no RH claim)

## Post-release

- [ ] `gh release view <tag>` confirms notes and asset
- [ ] Downloaded asset verifies: `VR_STRICT=1 ./VERIFY.sh`
