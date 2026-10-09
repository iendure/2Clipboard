<p align="center">
  <img src="assets/ENDURE__logo__dark_Built_to_last.svg" alt="ENDURE — Built to last" width="280">
</p>

# Instalación de 2Clipboard

Guía multi-distro. 2Clipboard es Bash puro; solo necesitas un backend de
portapapeles y dos utilidades opcionales.

- **Requisitos:** Bash 4+, `openssl` (o fallback a `/dev/urandom`).
- **Backend de portapapeles:** `xclip` / `xsel` (X11) o `wl-clipboard` (Wayland).
- **Opcional:** `notify-send` (notificaciones), `jq` (parsear JSON),
  `shellcheck` (solo desarrollo).

Salta a tu distro, instala los paquetes y ve a
[Instalar 2Clipboard](#instalar-2clipboard).

---

## Arch Linux / Manjaro / EndeavourOS

    # Backend X11
    sudo pacman -S --needed bash openssl xclip libnotify jq

    # Backend Wayland (sustituye a xclip)
    sudo pacman -S --needed wl-clipboard

    # Herramientas de desarrollo opcionales
    sudo pacman -S --needed shellcheck make

AUR: no hace falta. `make install` deja el binario en `~/.local/bin`.

## Debian / Ubuntu / Linux Mint / Pop!_OS / Kali

    sudo apt update
    sudo apt install -y bash openssl xclip libnotify-bin jq

    # Wayland:
    sudo apt install -y wl-clipboard

    # Desarrollo:
    sudo apt install -y shellcheck make

## Fedora / RHEL 9+ / Rocky / AlmaLinux / CentOS Stream

    sudo dnf install -y bash openssl xclip libnotify jq

    # Wayland:
    sudo dnf install -y wl-clipboard

    # Desarrollo:
    sudo dnf install -y ShellCheck make

En RHEL 8 y anteriores, habilita EPEL primero:

    sudo dnf install -y epel-release
    sudo dnf install -y xclip libnotify jq

## openSUSE Tumbleweed / Leap

    sudo zypper install -y bash openssl xclip libnotify-tools jq

    # Wayland:
    sudo zypper install -y wl-clipboard

    # Desarrollo:
    sudo zypper install -y ShellCheck make

## Alpine Linux

    sudo apk add bash openssl xclip libnotify jq

    # Wayland:
    sudo apk add wl-clipboard

    # Desarrollo:
    sudo apk add shellcheck make

Nota: en Alpine, `openssl` viene en `openssl` y `libcrypto3`. Si
`openssl rand` falla, instala `openssl-dev`.

## Void Linux

    sudo xbps-install -S bash openssl xclip libnotify jq

    # Wayland:
    sudo xbps-install -S wl-clipboard

    # Desarrollo:
    sudo xbps-install -S shellcheck make

## Gentoo

    sudo emerge -av app-shells/bash dev-libs/openssl x11-misc/xclip \
                  x11-libs/libnotify app-misc/jq

    # Wayland:
    sudo emerge -av gui-apps/wl-clipboard

    # Desarrollo:
    sudo emerge -av app-shells/shellcheck sys-devel/make

## NixOS / nix-shell

En NixOS, añade a `configuration.nix`:

    environment.systemPackages = with pkgs; [
      bash openssl xclip libnotify jq
      # wayland: wl-clipboard
      # dev:     shellcheck gnumake
    ];

O ejecuta sin instalar:

    nix-shell -p bash openssl xclip libnotify jq --run 'make install'

## macOS (experimental)

2Clipboard está centrado en Linux. En macOS, el backend es `pbcopy` /
`pbpaste`, que 2Clipboard todavía no detecta. Úsalo bajo tu responsabilidad:

    brew install bash openssl jq

---

## Instalar 2Clipboard

### Desde el fuente (recomendado)

    git clone https://github.com/iendure/2Clipboard.git ~/.local/src/2Clipboard
    cd ~/.local/src/2Clipboard
    make install
    hash -r
    2Clipboard --version

`make install` copia el script a `$(PREFIX)/bin` (por defecto
`~/.local/bin`) y crea los directorios de configuración y caché en la
primera ejecución. Sobrescribe con `PREFIX=...` o prepara un staging con
`DESTDIR=...`:

    make install DESTDIR=/tmp/stage PREFIX=/usr

### Sin git

    curl -fsSL https://github.com/iendure/2Clipboard/archive/refs/tags/v2.2.0.tar.gz \
        | tar -xz -C /tmp
    cd /tmp/2Clipboard-2.2.0
    make install
    hash -r

### Copia manual

    cp 2Clipboard ~/.bin/2Clipboard
    chmod +x ~/.bin/2Clipboard
    ~/.bin/2Clipboard --help
    hash -r

La primera ejecución dispara el auto-install si el script no está ya en
`~/.local/bin/` o `~/.bin/`. Desactívalo con `TWOCLIP_NO_INSTALL=1`.

---

## Estructura creada en la primera ejecución

    ~/.config/2Clipboard/templates/    <- tus plantillas .tpl
    ~/.cache/2Clipboard/history.log    <- historial
    ~/.cache/2Clipboard/slots/         <- slots con nombre

---

## Plantilla de ejemplo

Guarda esto como `~/.config/2Clipboard/templates/llm.tpl`:

    # {{TITLE}}
    - Date: **{{DATE}}**  - ID: **{{ID}}**
    - Tags: {{TAGS}}

    {{CONTENT}}

Luego úsala con:

    2Clipboard header --profile llm --tags "ai,research"

---

## Variables de entorno

Añade a `~/.bashrc`, `~/.zshrc` o `~/.profile`:

    export TWOCLIP_PROFILE="llm"
    export TWOCLIP_TAGS="ai,personal"
    export TWOCLIP_TITLE="Notas"
    # Fuerza un backend si tienes wl-copy instalado pero usas X11:
    # export TWOCLIP_BACKEND="x11"
    # Depuración:
    # export TWOCLIP_DEBUG=1

---

## Integración con gestores de atajos

### sxhkd (bspwm, i3, dwm)

    alt + KP_Insert
        2Clipboard header --profile llm --silent

    alt + shift + KP_Insert
        2Clipboard gen --silent --word-len 6 --hash-chars 4

    super + c
        2Clipboard git --silent

    super + v
        2Clipboard slot load work --silent

### i3 / sway (bindsym)

    bindsym $mod+c exec --no-startup-id 2Clipboard git --silent
    bindsym $mod+Shift+c exec --no-startup-id 2Clipboard header --profile llm --silent

### xbindkeys

    "2Clipboard header --profile llm --silent"
        Alt+Insert

### XFCE4

Configuración → Teclado → Atajos de aplicación → añadir
`2Clipboard header --profile llm --silent`.

### Hyprland

    bind = ALT, Insert, exec, 2Clipboard header --profile llm --silent
    bind = SUPER, C,    exec, 2Clipboard git --silent

---

## Verificación

    make lint
    make test

    2Clipboard header --tags "inbox" --stdout
    2Clipboard header --format json --tags "ai" --stdout 2>/dev/null | jq -r .id
    2Clipboard file README.md --title "README" --tags "doc" --stdout | head -5
    2Clipboard run -- echo hello
    2Clipboard check /etc/hosts

Los 17 smoke tests deben pasar.

---

## Construir un release

    make release
    # -> dist/2Clipboard-2.2.0.tar.gz
    # -> dist/2Clipboard-2.2.0.tar.gz.sha256

---

## Desinstalar

    make uninstall

O manualmente:

    rm -f ~/.local/bin/2Clipboard ~/.bin/2Clipboard
    rm -rf ~/.cache/2Clipboard
    # ~/.config/2Clipboard conserva tus plantillas; bórralo si quieres

---

## Solución de problemas

### `Failed to connect to a Wayland server` en X11

Fuerza el backend X11:

    export TWOCLIP_BACKEND=x11

### `line NNN: GIT_BRANCH: unbound variable`

El binario desplegado está obsoleto. Refréscalo:

    ~/.local/bin/2Clipboard --version
    hash -r
    2Clipboard --version

### `jq: parse error` al pipear

Los mensajes de estado van a stderr desde 2.2.0. Verifica:

    grep 'copied to clipboard' ~/.local/bin/2Clipboard
    # debe terminar en:  >&2 ;;

### El pipeline se cuelga tras `| head`

El demonio de `xclip` hereda stdout y mantiene el pipe abierto. 2.2.0
redirige a `/dev/null`. Verifica:

    grep 'xclip -selection clipboard -i' ~/.local/bin/2Clipboard

### `--body @ruta` no lee el archivo

    grep -A3 '\-\-body)' ~/.local/bin/2Clipboard
    # debe contener:  @*) BODY="${BODY#@}"; BODY_IS_FILE=true ;;

### No hay `openssl`

2Clipboard cae a `head -c … /dev/urandom | od`. Para forzar el fallback,
renombra temporalmente `openssl`.

### Depuración

    TWOCLIP_DEBUG=1 2Clipboard header --tags test

---

## ENDURE

**Built to last.**

- Web:      https://endure.digital/
- GitHub:   https://github.com/iendure
- Contact:  https://c.endure.digital/
- WhatsApp: https://w.endure.digital/
