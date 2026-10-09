# Contributing to 2Clipboard

**ENDURE · Built to last** — https://endure.digital/

Thanks for your interest. This is a small, focused tool. Patches are
welcome, but please keep them scoped and tested.

## Ground rules

- Bash 4+ only. No external runtime dependencies beyond what
  `README.md` already lists.
- Every change to `2Clipboard` must keep `make test` passing (17/17).
- Add a smoke test to `tests/smoke.sh` for any new user-visible flag
  or subcommand.
- Update `CHANGELOG.md` under an `Unreleased` or versioned section.
- Keep the public CLI surface backward compatible within the same
  major version. Deprecations go through `CHANGELOG.md` first.

## Workflow

    git clone <repo>
    cd 2Clipboard
    make lint
    make test
    # edit
    make test

## Commit style

Short imperative subject (<= 72 chars), blank line, body if needed.
Examples:

    fix: --body @file now reads the file
    feat: add `history grep PAT`
    docs: clarify X11 vs Wayland backend detection

## Releasing

    # 1. Bump VERSION in 2Clipboard
    # 2. Update CHANGELOG.md with the new section
    # 3. Run:
    make test
    make release
    # 4. Commit, tag, push:
    git commit -am "release: vX.Y.Z"
    git tag -a vX.Y.Z -m "2Clipboard X.Y.Z"
    git push --follow-tags

---

## ENDURE

**Built to last.**

- Web:      https://endure.digital/
- GitHub:   https://github.com/iendure
- Contact:  https://c.endure.digital/
- WhatsApp: https://w.endure.digital/
