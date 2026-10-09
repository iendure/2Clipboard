<p align="center">
  <img src="assets/ENDURE__logo__dark_Built_to_last.svg" alt="ENDURE — Built to last" width="360">
</p>

# 2Clipboard

> Notify and copy: a single binary that sends everything you produce to the
> clipboard, with traceable metadata ready to paste.

[![Version](https://img.shields.io/badge/version-2.2.0-blue.svg)](#)
[![Bash](https://img.shields.io/badge/bash-4%2B-4EAA25.svg)](#)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#license)
[![Platform](https://img.shields.io/badge/platform-X11%20%7C%20Wayland-lightgrey.svg)](#clipboard-backends)
[![CI](https://github.com/iendure/2Clipboard/actions/workflows/ci.yml/badge.svg)](https://github.com/iendure/2Clipboard/actions/workflows/ci.yml)

A Bash CLI that **generates, formats and copies to the clipboard**: project
codes, file attachments with metadata headers, command output, boolean
validations, or any text. Supports profiles, templates, structured output
(Markdown, YAML, JSON, plain), named slots and history.

Built for developers, LLM prompting workflows, engineering logs,
zettelkasten and shortcut daemons (`sxhkd`, `xbindkeys`,
`xfce4-keyboard-settings`, `i3`, `sway`, `hyprland`, `dwm`).

---

## Table of contents

1. [Features](#features)
2. [Install](#install)
3. [Quick start](#quick-start)
4. [Actions](#actions)
5. [Options](#options)
6. [Profiles and templates](#profiles-and-templates)
7. [Structured output](#structured-output)
8. [Environment variables](#environment-variables)
9. [Clipboard backends](#clipboard-backends)
10. [Slots and history](#slots-and-history)
11. [Recipes](#recipes)
12. [Keybinding daemons](#keybinding-daemons)
13. [Embedding in other scripts](#embedding-in-other-scripts)
14. [Troubleshooting](#troubleshooting)
15. [Documentation](#documentation)
16. [Roadmap](#roadmap)
17. [License](#license)

---

## Features

- **Unique, readable identifiers.** Combines date, brand-like pronounceable
  name (`kamishin`, `valeri`, `rafinton`) and a short cryptographic hash
  (`openssl rand -hex`).
- **Attachments with metadata header.** Copy file contents preceded by a
  traceable header: date, unique ID, tags, source path.
- **Command runner.** Run any command, capture `stdout+stderr`, include the
  exit code and copy the whole thing — propagating the exit code so you can
  chain it in pipelines.
- **Boolean validator.** `check PATH` copies `true` or `false` (file,
  directory, or command on `PATH`).
- **Git snapshot.** `git` copies branch, commit, dirty files and remote.
- **Templates and profiles.** `.tpl` files in
  `~/.config/2Clipboard/templates/` with `{{TITLE}}`, `{{DATE}}`, `{{ID}}`,
  `{{TAGS}}`, `{{CONTENT}}`, `{{SOURCE}}`, `{{STATUS}}`, `{{CMD}}`,
  `{{HOST}}`, `{{USER}}`, `{{CWD}}`, `{{GIT_BRANCH}}`, `{{GIT_COMMIT}}`,
  `{{NOW}}`, `{{VERSION}}`.
- **Four output formats.** `markdown`, `plain`, `json`, `yaml`.
- **Pipe mode.** Reads from stdin automatically; `--stdout` writes the clean
  payload to stdout (status messages go to stderr) for chaining into `jq`,
  `yq`, `curl`.
- **Append / prepend.** Add to the current clipboard instead of replacing.
- **Named slots.** Save and restore clipboard contents.
- **History.** `~/.cache/2Clipboard/history.log` with `grep PAT` and `clear`.
- **Real backend detection.** Wayland only if the socket exists; X11 if
  `DISPLAY` is set; override with `TWOCLIP_BACKEND`.
- **Self-install into `PATH`.** Disable with `TWOCLIP_NO_INSTALL=1`.
- **Silent mode.** `--silent` / `--quiet` with no stdout/stderr, ideal for
  `sxhkd`.
- **Strict validation.** `--word-len` / `--hash-chars` between 1 and 64.
- **Optional tracing.** `TWOCLIP_DEBUG=1` for diagnostics.

---

## Install

### Per-distro dependencies

You only need Bash 4+, a clipboard backend, and optionally `notify-send`
and `jq`.

| Distro | X11 backend | Wayland backend |
|---|---|---|
| Arch / Manjaro | `sudo pacman -S xclip libnotify jq` | `sudo pacman -S wl-clipboard` |
| Debian / Ubuntu | `sudo apt install xclip libnotify-bin jq` | `sudo apt install wl-clipboard` |
| Fedora / RHEL 9+ | `sudo dnf install xclip libnotify jq` | `sudo dnf install wl-clipboard` |
| openSUSE | `sudo zypper install xclip libnotify-tools jq` | `sudo zypper install wl-clipboard` |
| Alpine | `sudo apk add xclip libnotify jq` | `sudo apk add wl-clipboard` |
| Void | `sudo xbps-install -S xclip libnotify jq` | `sudo xbps-install -S wl-clipboard` |
| Gentoo | `sudo emerge -av x11-misc/xclip x11-libs/libnotify app-misc/jq` | `sudo emerge -av gui-apps/wl-clipboard` |
| NixOS | `nix-shell -p xclip libnotify jq` | `nix-shell -p wl-clipboard` |

Full guide (RHEL 8, CentOS Stream, Rocky, AlmaLinux, macOS):
see [INSTALL.md](INSTALL.md).

### From source

    git clone https://github.com/iendure/2Clipboard.git ~/.local/src/2Clipboard
    cd ~/.local/src/2Clipboard
    make install
    hash -r
    2Clipboard --version

### Without git

    curl -fsSL https://github.com/iendure/2Clipboard/archive/refs/tags/v2.2.0.tar.gz \
        | tar -xz -C /tmp
    cd /tmp/2Clipboard-2.2.0
    make install
    hash -r

### Directory layout created at first run

    ~/.config/2Clipboard/templates/    <- your .tpl files
    ~/.cache/2Clipboard/history.log    <- operation log
    ~/.cache/2Clipboard/slots/         <- named slots

Full details in [INSTALL.md](INSTALL.md) · Spanish:
[INSTALL_es.md](INSTALL_es.md).

---

## Quick start

    # Classic project code (v1)
    2Clipboard gen
    # -> [2026-10-09]-kamishin-cdb28c17

    # Identifier only
    2Clipboard id
    # -> zeciiaoo-bc811448

    # Markdown header with blank fields
    2Clipboard header

    # Attach a file with a traceable header
    2Clipboard file ~/notes.md --title "Notes" --tags "journal,personal"

    # Blank header + file contents (SYSPROMPT-style workflow)
    2Clipboard header --body @~/prompt.md --title "" --tags ""

    # Run a command and copy its output
    2Clipboard run -- ls -la /etc

    # Boolean validation (copies "true" or "false")
    2Clipboard check /etc/hosts

---

## Actions

    2Clipboard [ACTION] [OPTIONS...]

Default action is `gen`.

| Action | Alias | Description |
|---|---|---|
| `gen` | — | Project identifier (date + name + hash). v1 mode. |
| `header` | `head` | Header only (Date/ID/Tags ready to fill in). |
| `id` | — | Identifier only (`name-hash`). For scripting. |
| `text STR` | — | Copy a literal with header. |
| `file PATH` | — | Copy a file with header. |
| `run -- CMD [ARGS]` | — | Run CMD, capture stdout+stderr and exit code, propagate exit. |
| `check PATH` | — | `true` if it exists (file/directory/command), otherwise `false`. |
| `git` | — | Branch, commit, dirty files, remote. |
| `env VAR` | — | Value of an environment variable. |
| `slot save NAME` | — | Save current clipboard into a slot. |
| `slot load NAME` | — | Restore a slot to the clipboard. |
| `slot list` | — | List existing slots. |
| `slot del NAME` | `slot rm` | Delete a slot. |
| `paste` | — | Print clipboard to stdout. |
| `history [N]` | — | Last N entries (default 20). |
| `history grep PAT` | — | Filter entries by pattern. |
| `history clear` | — | Empty the history. |
| `version` | — | Print the version. |

---

## Options

### Generation (`gen`)

| Option | Default | Description |
|---|---|---|
| `-w`, `--word-len LEN` | `8` | Name length (1-64). |
| `-H`, `--hash-chars CHARS` | `8` | Hash length (1-64). |
| `--no-name` | — | Skip the name. |
| `--no-hash` | — | Skip the hash. |
| `--date-format FMT` | `%Y-%m-%d` | `strftime` format (`""` disables). |
| `--time-format FMT` | off | `strftime` format (e.g. `%H:%M`). |
| `--date-prefix STR` | `[` | Prefix before the date. |
| `--date-suffix STR` | `]` | Suffix after the date. |
| `--name-prefix STR` | `-` | Prefix before the name. |
| `--name-suffix STR` | `""` | Suffix after the name. |
| `--hash-prefix STR` | `-` | Prefix before the hash. |

> `-h` is reserved for `--help`; the hash shortcut is `-H`.

### Header and format (all actions)

| Option | Description |
|---|---|
| `--title STR` | Header title. |
| `--tags STR` | Comma-separated tags. |
| `--no-title` | Skip the `# ` title line. |
| `--header` / `--no-header` | Force / disable header. |
| `--format FMT` | `markdown` \| `plain` \| `json` \| `yaml`. |
| `--template STR` | Inline template or `@path` to a `.tpl`. |
| `--profile NAME` | Shorthand for `--template @NAME`. |
| `--body STR` | Inline body (with `header`). |
| `--body @PATH` | Body from a file (shortcut). |
| `--body-file PATH` | Body from a file (long form). |

### Behavior (all actions)

| Option | Description |
|---|---|
| `--append` | Add to the end of the current clipboard. |
| `--prepend` | Add to the beginning of the current clipboard. |
| `--stdout` | Write the payload to stdout (messages go to stderr). |
| `--dry-run` | Don't copy, just print. |
| `--clip-cmd CMD` | Filter the payload through `bash -c CMD` (payload via stdin). |
| `--silent`, `--quiet` | Silence all output. |
| `--no-notify` | No desktop notifications. |
| `--no-history` | Don't record in the history. |
| `-h`, `--help` | Show help. |
| `-v`, `--version` | Show version. |
| `--license` | Show the MIT license. |

---

## Profiles and templates

    ~/.config/2Clipboard/templates/
    |- llm.tpl
    |- zettel.tpl
    |- work.tpl
    |- bug.tpl
    `- minimal.tpl

A profile is just a named template. Invoke with `--profile NAME`, or via
`TWOCLIP_PROFILE`.

Ready-to-use templates ship in [`examples/templates/`](examples/templates/).
Copy them into `~/.config/2Clipboard/templates/` once:

    mkdir -p ~/.config/2Clipboard/templates
    cp examples/templates/*.tpl ~/.config/2Clipboard/templates/

### Reference templates

`llm.tpl` — LLM sessions:

    # {{TITLE}}
    - Date: **{{DATE}}**  ·  ID: **{{ID}}**
    - Tags: {{TAGS}}

    {{CONTENT}}

`zettel.tpl` — zettelkasten:

    # {{ID}}

    Tags:: {{TAGS}}
    Date:: {{DATE}}
    Source:: {{SOURCE}}
    Title:: {{TITLE}}

    {{CONTENT}}

`work.tpl` — work log:

    [{{DATE}} {{TIME}}] {{ID}}
    Tags: {{TAGS}}
    Title: {{TITLE}}
    ---
    {{CONTENT}}

`bug.tpl` — bug report:

    ## Bug Report {{ID}}

    - **Date:** {{DATE}}
    - **Tags:** {{TAGS}}
    - **Source:** `{{SOURCE}}`
    - **Cmd:** `{{CMD}}`  ->  exit {{STATUS}}

    ### Output
    {{CONTENT}}

`minimal.tpl` — one line and tags:

    {{TITLE}} — {{DATE}} — {{ID}} — [{{TAGS}}]

    {{CONTENT}}

### Template variables

| Variable | Contents |
|---|---|
| `{{TITLE}}` | Title (`--title`). |
| `{{DATE}}` | Formatted date. |
| `{{TIME}}` | Formatted time. |
| `{{ID}}` | Full identifier (`name-hash`). |
| `{{NAME}}` | Pronounceable name only. |
| `{{HASH}}` | Hash only. |
| `{{TAGS}}` | Tags as passed. |
| `{{SOURCE}}` | Source path. |
| `{{CONTENT}}` | Body. |
| `{{STATUS}}` | Exit code (`run`). |
| `{{CMD}}` | Executed command (`run`). |
| `{{HOST}}` | `hostname`. |
| `{{USER}}` | `$USER`. |
| `{{CWD}}` | Current directory. |
| `{{GIT_BRANCH}}` | Git branch. |
| `{{GIT_COMMIT}}` | Short git commit. |
| `{{NOW}}` | ISO 8601 date+time. |
| `{{VERSION}}` | 2Clipboard version. |

---

## Structured output

### `markdown` (default)

    # Title
    - Date: **2026-10-09**
    - ID: **docigoji-e0d69df6**
    - Tags: ai,work

    <body>

### `plain`

    Title
    Date: 2026-10-09
    ID: docigoji-e0d69df6
    Tags: ai,work

    <body>

### `json`

    {
      "title": "Session",
      "date": "2026-10-09",
      "time": "",
      "id": "docigoji-e0d69df6",
      "tags": ["ai", "work"],
      "source": "",
      "status": "",
      "cmd": "",
      "content": "..."
    }

### `yaml`

    title: "Session"
    date: "2026-10-09"
    id: "docigoji-e0d69df6"
    tags: [ai, work]
    content: |
      ...

### End-to-end pipelines

`--stdout` writes **only** the payload to stdout; messages go to stderr.

    # Extract a session ID
    2Clipboard header --format json --tags "ai" --stdout 2>/dev/null | jq -r .id

    # Feed a structured payload to an API
    2Clipboard file prompt.md --format json --stdout 2>/dev/null \
        | curl -s https://api.example.com/v1/chat -d @-

    # Accumulate sessions in a YAML file
    2Clipboard header --format yaml --tags "meta" --stdout 2>/dev/null \
        >> ~/sessions.yaml

---

## Environment variables

| Variable | Effect |
|---|---|
| `TWOCLIP_PROFILE` | Default profile (same as `--profile`). |
| `TWOCLIP_TAGS` | Default tags. |
| `TWOCLIP_TITLE` | Default title. |
| `TWOCLIP_BACKEND` | `x11` or `wayland` (default `auto`). |
| `TWOCLIP_NO_INSTALL` | `1` disables self-install. |
| `TWOCLIP_DEBUG` | `1` enables verbose tracing. |

CLI flags always override environment variables.

---

## Clipboard backends

Real detection, in order:

1. `TWOCLIP_BACKEND=x11|wayland` -> used as-is.
2. `WAYLAND_DISPLAY` set **and** socket present -> Wayland.
3. `XDG_SESSION_TYPE=wayland` **and** `wayland-0` socket -> Wayland.
4. `DISPLAY` set -> X11 (`xclip`, then `xsel`).
5. Nothing -> payload is printed to stdout so you don't lose it.

This avoids the classic *"Failed to connect to a Wayland server"* on X11
machines that happen to have `wl-copy` installed as a dependency.

---

## Slots and history

    # Save the current clipboard
    2Clipboard slot save 2fa

    # Restore it
    2Clipboard slot load 2fa

    # List, delete
    2Clipboard slot list
    2Clipboard slot del 2fa

    # Save from stdin
    echo "content" | 2Clipboard slot save draft

    # History
    2Clipboard history 50
    2Clipboard history grep ai
    2Clipboard history clear

Format: `date<TAB>action<TAB>preview(120 chars)`.

---

## Recipes

### A. Header only, with blank fields

    2Clipboard header --tags ""

### B. System prompt for LLMs with traceability

    2Clipboard header --body @~/prompt.md --title "" --tags ""

### C. Short question for AI chat

    2Clipboard header --body "How do I optimize this SQL query?" --tags "ai,sql,question"

### D. Paste code with context

    sed -n '1,200p' src/main.py | 2Clipboard header --title "main.py" --tags "ai,code,snippet"

### E. Daily work log

    2Clipboard header --profile work --title "Log $(date +%A)" --tags "journal"

### F. Bug report

    2Clipboard run -- ./repro.sh
    # or:
    2Clipboard header --profile bug --body @/tmp/repro.log --tags "bug,repro"

### G. Commit log

    git log --oneline -20 | 2Clipboard header --title "Recent Commits" --tags "git,log"

### H. Validate before acting

    if [ "$(2Clipboard check /etc/nginx/nginx.conf --silent)" = "true" ]; then
        systemctl restart nginx
    fi

### I. ID for scripting

    SID="$(2Clipboard id --silent)"
    mkdir -p "/tmp/$SID"

### J. Modify the clipboard without replacing it

    2Clipboard header --tags "refined" --prepend
    echo -e "\n\n---\nNote" | 2Clipboard text --append --no-header
    2Clipboard file a.md --append
    2Clipboard file b.md --append

### K. JSON / YAML for automation

    2Clipboard header --format json --tags "ai" --stdout 2>/dev/null | jq -r .id
    2Clipboard header --format yaml --tags "meta" --stdout 2>/dev/null >> ~/session.yaml

### L. Wrappers

    snapshot() {
        local title="${1:-Auto}"
        2Clipboard git --title "$title" --append --silent
    }

### M. Slots for temporary secrets

    2Clipboard slot save 2fa
    2Clipboard slot load 2fa

---

## Keybinding daemons

### sxhkd

    alt + KP_Insert
        2Clipboard header --profile llm --silent

    alt + shift + KP_Insert
        2Clipboard gen --silent --word-len 6 --hash-chars 4

    super + c
        2Clipboard git --silent

    super + v
        2Clipboard slot load work --silent

### i3 / sway

    bindsym $mod+c exec --no-startup-id 2Clipboard git --silent

### Hyprland

    bind = ALT, Insert, exec, 2Clipboard header --profile llm --silent
    bind = SUPER, C,    exec, 2Clipboard git --silent

### XFCE4

Settings -> Keyboard -> Application Shortcuts, add
`2Clipboard header --profile llm --silent`.

---

## Embedding in other scripts

    #!/usr/bin/env bash
    set -euo pipefail
    export TWOCLIP_NO_INSTALL=1

    sid="$(2Clipboard id --silent --stdout)"
    payload="$(2Clipboard header --format json --tags "batch" --stdout 2>/dev/null)"
    echo "$payload" | jq -r .id
    echo "Session: $sid"

- `TWOCLIP_NO_INSTALL=1` — do not overwrite the deployed binary.
- `--silent` — no stdout/stderr output.
- `--stdout` — payload to stdout; messages to stderr.
- `--dry-run` — do not touch the clipboard.

---

## Troubleshooting

### *Failed to connect to a Wayland server* on X11

    export TWOCLIP_BACKEND=x11

### `line NNN: GIT_BRANCH: unbound variable`

Stale deployed binary:

    ~/.local/bin/2Clipboard --version
    hash -r
    2Clipboard --version

### `jq: parse error` after piping

Status messages go to stderr since 2.2.0. Verify:

    grep 'copied to clipboard' ~/.local/bin/2Clipboard
    # should end with:  >&2 ;;

### Pipeline hangs after `| head`

`xclip`'s daemon inherits stdout and keeps the pipe open. 2.2.0 redirects
to `/dev/null`:

    grep 'xclip -selection clipboard -i' ~/.local/bin/2Clipboard

### `--body @path` does not read the file

    grep -A3 '\-\-body)' ~/.local/bin/2Clipboard
    # should contain:  @*) BODY="${BODY#@}"; BODY_IS_FILE=true ;;

### Verbose trace

    TWOCLIP_DEBUG=1 2Clipboard header --tags test

---

## Documentation

- [INSTALL.md](INSTALL.md) — multi-distro installation.
- [CHANGELOG.md](CHANGELOG.md) — version history.
- [CONTRIBUTING.md](CONTRIBUTING.md) — how to contribute.
- [examples/templates/](examples/templates/) — ready-to-copy `.tpl` files.
- [docs/](docs/) — documentation sources for the future website.
- Spanish: [README_es.md](README_es.md) · [INSTALL_es.md](INSTALL_es.md) ·
  [CHANGELOG_es.md](CHANGELOG_es.md) · [CONTRIBUTING_es.md](CONTRIBUTING_es.md).

---

## Roadmap

- [ ] Persistent config file (`~/.config/2Clipboard/config`).
- [ ] Dictionary / wordlist mode with real words.
- [ ] TUI / rofi / dmenu picker.
- [ ] History search with `fzf`.
- [ ] Richer export: HTML, org-mode.
- [ ] Slot encryption with `age` or `gpg`.
- [ ] Per-workspace multi-clipboard.

---

## License

MIT. See [LICENSE](LICENSE).

Copyright (c) 2026 ENDURE · Built to last.

---

<p align="center">
  <a href="https://endure.digital/">Web</a> ·
  <a href="https://github.com/iendure">GitHub</a> ·
  <a href="https://c.endure.digital/">Contact</a> ·
  <a href="https://w.endure.digital/">WhatsApp</a>
</p>
