<p align="center">
  <a href="https://endure.digital/" title="ENDURE — Built to last">
    <img src="assets/ENDURE__logo__dark_Built_to_last.svg" alt="ENDURE — Built to last" title="ENDURE — Built to last" width="300">
  </a>
</p>

# Changelog

Format: [Keep a Changelog](https://keepachangelog.com/).
Versioning: [SemVer](https://semver.org/).

Maintained by **ENDURE · Built to last** — https://endure.digital/

## [2.2.0] — 2026-10-09

### Added
- Strict validation of `--word-len` / `--hash-chars` (integers 1-64).
- `TWOCLIP_DEBUG=1` for verbose tracing to stderr.
- `version` subcommand (in addition to `--version`).
- `--license` flag to print the MIT license.
- `Makefile`: `release` (tarball + sha256), `check` (alias of `lint`),
  `DESTDIR` for packaging.
- Consistent error/warning messages (`2Clipboard: error: ...`).

### Fixed
- `render_template`: removed spurious escapes of `&` and `/` that injected
  literal characters into substituted values.
- `--clip-cmd`: no longer uses `eval`; goes through `bash -c` with the
  payload on stdin.
- `--dry-run --stdout` no longer prints twice.
- `slot load --dry-run` does not touch the clipboard.

## [2.1.0] — 2026-10-09

### Added
- `header` action to emit only the header.
- `id` action to get just the identifier (name-hash).
- `--dry-run`, `--clip-cmd`, `--quiet`.
- `slot save` reads from stdin if data is available.
- `history grep PAT` and `history clear`.
- `TWOCLIP_PROFILE`, `TWOCLIP_TAGS`, `TWOCLIP_TITLE`.
- Real backend detection (Wayland only if the socket exists).

### Fixed
- `--body @file` loads the content.
- `GIT_BRANCH` / `GIT_COMMIT` initialized.
- Duplicated `paste_from_clipboard` removed.
- Status messages to stderr; `--stdout` pipeable to jq/yq/curl.
- `xclip` / `xsel` no longer inherit stdout (no more hanging pipe).
- `--help` and `--version` do not read stdin.
- `history grep PAT` accepts multiple positionals.

### Changed
- `-H` (uppercase) for `--hash-chars`; `-h` is now `--help`.
- `action_file` no longer auto-fills TITLE with the basename.

## [2.0.0] — 2026-10-08

### Added
- Subcommands: gen, text, file, run, check, git, env, slot, paste, history.
- Automatic stdin detection.
- `{{VAR}}` templates, inline or from `~/.config/2Clipboard/templates/`.
- Output formats: markdown, plain, json, yaml.
- History (`history.log`).
- Named slots (`slots/`).
- `--append` / `--prepend`.
- Self-install into PATH.

## [1.0.0] — 2026-10-07

### Added
- `[YYYY-MM-DD]-name-hash` code generation.
- Pronounceable names + cryptographic hash.
- Clipboard copy (Wayland / X11).
- Desktop notifications.

---

<p align="center">
  <a href="https://endure.digital/">Web</a> ·
  <a href="https://github.com/iendure">GitHub</a> ·
  <a href="https://c.endure.digital/">Contact</a> ·
  <a href="https://w.endure.digital/">WhatsApp</a>
</p>
