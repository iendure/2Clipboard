# Installing 2Clipboard

Multi-distro installation guide. 2Clipboard is pure Bash; you only need a
clipboard backend and two optional utilities.

- **Requirements:** Bash 4+, `openssl` (or `/dev/urandom` fallback).
- **Clipboard backend:** `xclip` / `xsel` (X11) or `wl-clipboard` (Wayland).
- **Optional:** `notify-send` (desktop notifications), `jq` (parse JSON
  output), `shellcheck` (dev only).

Skip to your distro, install the packages, then jump to
[Install 2Clipboard](#install-2clipboard).

---

## Arch Linux / Manjaro / EndeavourOS

    # X11 backend
    sudo pacman -S --needed bash openssl xclip libnotify jq

    # Wayland backend (replace xclip)
    sudo pacman -S --needed wl-clipboard

    # Optional dev tools
    sudo pacman -S --needed shellcheck make

AUR: not required. `make install` puts the binary in `~/.local/bin`.

## Debian / Ubuntu / Linux Mint / Pop!_OS / Kali

    sudo apt update
    sudo apt install -y bash openssl xclip libnotify-bin jq

    # Wayland:
    sudo apt install -y wl-clipboard

    # Optional dev tools:
    sudo apt install -y shellcheck make

## Fedora / RHEL 9+ / Rocky Linux / AlmaLinux / CentOS Stream

    sudo dnf install -y bash openssl xclip libnotify jq

    # Wayland:
    sudo dnf install -y wl-clipboard

    # Optional dev tools:
    sudo dnf install -y ShellCheck make

On RHEL 8 and older, enable EPEL first:

    sudo dnf install -y epel-release
    sudo dnf install -y xclip libnotify jq

## openSUSE Tumbleweed / Leap

    sudo zypper install -y bash openssl xclip libnotify-tools jq

    # Wayland:
    sudo zypper install -y wl-clipboard

    # Optional dev tools:
    sudo zypper install -y ShellCheck make

## Alpine Linux

    sudo apk add bash openssl xclip libnotify jq

    # Wayland:
    sudo apk add wl-clipboard

    # Optional dev tools:
    sudo apk add shellcheck make

Note: `openssl` on Alpine is provided by `openssl` and `libcrypto3`. If
`openssl rand` fails, install `openssl-dev` and re-check.

## Void Linux

    sudo xbps-install -S bash openssl xclip libnotify jq

    # Wayland:
    sudo xbps-install -S wl-clipboard

    # Optional dev tools:
    sudo xbps-install -S shellcheck make

## Gentoo

    sudo emerge -av app-shells/bash dev-libs/openssl x11-misc/xclip \
                  x11-libs/libnotify app-misc/jq

    # Wayland:
    sudo emerge -av gui-apps/wl-clipboard

    # Optional dev tools:
    sudo emerge -av app-shells/shellcheck sys-devel/make

## NixOS / nix-shell

On NixOS, add to `configuration.nix`:

    environment.systemPackages = with pkgs; [
      bash openssl xclip libnotify jq
      # wayland: wl-clipboard
      # dev:     shellcheck gnumake
    ];

Or run without installing:

    nix-shell -p bash openssl xclip libnotify jq --run 'make install'

## macOS (experimental)

2Clipboard focuses on Linux. On macOS, the clipboard backend is `pbcopy`
/ `pbpaste`, which 2Clipboard does not detect yet. Use at your own risk:

    brew install bash openssl jq

---

## Install 2Clipboard

### From source (recommended)

    git clone https://github.com/iendure/2Clipboard.git ~/.local/src/2Clipboard
    cd ~/.local/src/2Clipboard
    make install
    hash -r
    2Clipboard --version

`make install` copies the script to `$(PREFIX)/bin` (default
`~/.local/bin`) and creates the config and cache directories on first run.
Override with `PREFIX=...` or stage with `DESTDIR=...`:

    make install DESTDIR=/tmp/stage PREFIX=/usr

### Without git

    curl -fsSL https://github.com/iendure/2Clipboard/archive/refs/tags/v2.2.0.tar.gz \
        | tar -xz -C /tmp
    cd /tmp/2Clipboard-2.2.0
    make install
    hash -r

### Manual copy

    cp 2Clipboard ~/.bin/2Clipboard
    chmod +x ~/.bin/2Clipboard
    ~/.bin/2Clipboard --help
    hash -r

The first run triggers self-install if the script is not already in
`~/.local/bin/` or `~/.bin/`. Disable with `TWOCLIP_NO_INSTALL=1`.

---

## Directory layout created at first run

    ~/.config/2Clipboard/templates/    <- your .tpl files
    ~/.cache/2Clipboard/history.log    <- operation log
    ~/.cache/2Clipboard/slots/         <- named clipboard slots

---

## Sample template

Save this as `~/.config/2Clipboard/templates/llm.tpl`:

    # {{TITLE}}
    - Date: **{{DATE}}**  - ID: **{{ID}}**
    - Tags: {{TAGS}}

    {{CONTENT}}

Then use it with:

    2Clipboard header --profile llm --tags "ai,research"

---

## Environment variables

Add to `~/.bashrc`, `~/.zshrc` or `~/.profile`:

    export TWOCLIP_PROFILE="llm"
    export TWOCLIP_TAGS="ai,personal"
    export TWOCLIP_TITLE="Notes"
    # Force a clipboard backend if you have wl-copy installed but run X11:
    # export TWOCLIP_BACKEND="x11"
    # Debug:
    # export TWOCLIP_DEBUG=1

---

## Integration with keybinding daemons

### sxhkd (bspwm, i3, dwm)

    alt + KP_Insert
        2Clipboard header --profile llm --silent

    alt + shift + KP_Insert
        2Clipboard gen --silent --word-len 6 --hash-chars 4

    super + c
        2Clipboard git --silent

    super + v
        2Clipboard slot load work --silent

### i3 / sway (native bindsym)

    bindsym $mod+c exec --no-startup-id 2Clipboard git --silent
    bindsym $mod+Shift+c exec --no-startup-id 2Clipboard header --profile llm --silent

### xbindkeys

    "2Clipboard header --profile llm --silent"
        Alt+Insert

### XFCE4

Settings → Keyboard → Application Shortcuts → add
`2Clipboard header --profile llm --silent`.

### Hyprland (native bind)

    bind = ALT, Insert, exec, 2Clipboard header --profile llm --silent
    bind = SUPER, C,    exec, 2Clipboard git --silent

---

## Verification

    make lint
    make test

    2Clipboard header --tags "inbox" --stdout
    2Clipboard header --format json --tags "ai" --stdout 2>/dev/null | jq -r .id
    2Clipboard file README.md --title "README" --tags "doc" --stdout | head -5
    2Clipboard run -- echo hello
    2Clipboard check /etc/hosts

All 17 smoke tests should pass.

---

## Release build

    make release
    # -> dist/2Clipboard-2.2.0.tar.gz
    # -> dist/2Clipboard-2.2.0.tar.gz.sha256

---

## Uninstall

    make uninstall

Or manually:

    rm -f ~/.local/bin/2Clipboard ~/.bin/2Clipboard
    rm -rf ~/.cache/2Clipboard
    # ~/.config/2Clipboard keeps your templates; remove it if you want

---

## Troubleshooting

### `Failed to connect to a Wayland server` on X11

Force the X11 backend:

    export TWOCLIP_BACKEND=x11

### `line NNN: GIT_BRANCH: unbound variable`

The deployed binary is stale. Refresh:

    ~/.local/bin/2Clipboard --version
    hash -r
    2Clipboard --version

### `jq: parse error` after piping

Status messages go to stderr since 2.2.0. Verify:

    grep 'copied to clipboard' ~/.local/bin/2Clipboard
    # should end with:  >&2 ;;

### Pipeline hangs after `| head`

The `xclip` daemon inherits stdout and keeps the pipe open. 2.2.0
redirects to `/dev/null`. Verify:

    grep 'xclip -selection clipboard -i' ~/.local/bin/2Clipboard

### `--body @path` does not read the file

    grep -A3 '\-\-body)' ~/.local/bin/2Clipboard
    # should contain:  @*) BODY="${BODY#@}"; BODY_IS_FILE=true ;;

### No `openssl` available

2Clipboard falls back to `head -c … /dev/urandom | od`. To force the
fallback path, temporarily rename `openssl`.

### Debug

    TWOCLIP_DEBUG=1 2Clipboard header --tags test

---

## ENDURE

**Built to last.**

- Web:      https://endure.digital/
- GitHub:   https://github.com/iendure
- Contact:  https://c.endure.digital/
- WhatsApp: https://w.endure.digital/
