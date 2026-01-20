# R24 Build Policy

**Concept-Tag:** RH-R24-POLICY

## Determinism Scope

This rung provides **local determinism**: given the same source files and
the same TeX toolchain on the same machine, the build produces byte-identical
PDFs.

### What IS Controlled

- `SOURCE_DATE_EPOCH` set to fixed value (1735689600 = 2025-01-01 UTC)
- `FORCE_SOURCE_DATE=1` to propagate epoch to PDF metadata
- `TZ=UTC`, `LC_ALL=C`, `LANG=C` for locale stability
- No `\today` in LaTeX source (fixed date string)
- Two-pass verification on each build

### What IS NOT Controlled

- TeX Live version (captured in build.log for audit)
- System fonts or libraries
- Cross-platform reproducibility

## Future Enhancements

If cross-machine reproducibility is required, consider:

1. Pinned Docker/Podman container with specific TeX Live version
2. Nix flake with locked dependencies
3. Recording toolchain hash in receipt

These would be separate rungs (R25+) if implemented.

## Toolchain Capture

The build script records in `outputs/build.log`:

- latexmk version (if present)
- pdflatex version (if present)
- kpsewhich version (if present)
- Build timestamp and SOURCE_DATE_EPOCH value

This allows auditing which toolchain produced a given PDF.
