# 2Clipboard

> Notifica y copia: un solo binario para llevar al portapapeles todo lo que
> produces, con metadatos trazables listos para pegar.

[![Version](https://img.shields.io/badge/version-2.2.0-blue.svg)](#)
[![Bash](https://img.shields.io/badge/bash-4%2B-4EAA25.svg)](#)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](#licencia)
[![Platform](https://img.shields.io/badge/platform-X11%20%7C%20Wayland-lightgrey.svg)](#)

Utilidad CLI en Bash para **generar, formatear y copiar al portapapeles**
identificadores, adjuntos con cabecera de metadatos, salidas de comandos,
validaciones booleanas y cualquier texto. Soporta perfiles, plantillas,
formatos estructurados (Markdown, YAML, JSON, plain), slots con nombre e
historial.

Diseñada para desarrolladores, flujos de prompting con LLM, bitácoras
técnicas, zettelkasten y gestores de atajos (`sxhkd`, `xbindkeys`,
`xfce4-keyboard-settings`, `i3`, `dwm`).

---

## Tabla de contenidos

1. [Caracteristicas](#caracteristicas)
2. [Instalacion](#instalacion)
3. [Inicio rapido](#inicio-rapido)
4. [Acciones](#acciones)
5. [Opciones](#opciones)
6. [Perfiles y plantillas](#perfiles-y-plantillas)
7. [Salida estructurada](#salida-estructurada)
8. [Variables de entorno](#variables-de-entorno)
9. [Backends de portapapeles](#backends-de-portapapeles)
10. [Slots e historial](#slots-e-historial)
11. [Recetas y casos de uso](#recetas-y-casos-de-uso)
12. [Integracion con gestores de atajos](#integracion-con-gestores-de-atajos)
13. [Embeber 2Clipboard en otros scripts](#embeber-2clipboard-en-otros-scripts)
14. [Solucion de problemas](#solucion-de-problemas)
15. [Documentacion adicional](#documentacion-adicional)
16. [Hoja de ruta](#hoja-de-ruta)
17. [Licencia](#licencia)

---

## Caracteristicas

- **Identificadores unicos y legibles.** Combina fecha, nombre pronunciable
  tipo marca (`kamishin`, `valeri`, `rafinton`) y hash criptografico corto
  (`openssl rand -hex`).
- **Adjuntos con cabecera de metadatos.** Copia el contenido de un archivo
  con encabezado trazable: fecha, ID unico, tags, fuente.
- **Ejecutor de comandos.** Corre cualquier comando, captura `stdout+stderr`,
  incluye el exit code y lo copia todo, propagando el exit code original.
- **Validador booleano.** `check PATH` copia `true` o `false` (existencia de
  archivo, carpeta o comando en `PATH`).
- **Captura de git.** `git` copia branch, commit, archivos sucios y remote.
- **Plantillas y perfiles.** Archivos `.tpl` en
  `~/.config/2Clipboard/templates/` con variables `{{TITLE}}`, `{{DATE}}`,
  `{{ID}}`, `{{TAGS}}`, `{{CONTENT}}`, `{{SOURCE}}`, `{{STATUS}}`, `{{CMD}}`,
  `{{HOST}}`, `{{USER}}`, `{{CWD}}`, `{{GIT_BRANCH}}`, `{{GIT_COMMIT}}`,
  `{{NOW}}`, `{{VERSION}}`.
- **Cuatro formatos de salida.** `markdown`, `plain`, `json`, `yaml`.
- **Modo pipe.** Lee de stdin automaticamente; `--stdout` emite el payload
  limpio (mensajes a stderr) para encadenar a `jq`, `yq`, `curl`.
- **Append / prepend.** Suma al portapapeles actual en lugar de reemplazarlo.
- **Slots con nombre.** Guarda y recupera el portapapeles.
- **Historial.** `~/.cache/2Clipboard/history.log`, con `grep PAT` y `clear`.
- **Deteccion real de backend.** Wayland solo si el socket existe; X11 si
  `DISPLAY` esta definido; override con `TWOCLIP_BACKEND`.
- **Autoinstalacion en `PATH`.** Desactivable con `TWOCLIP_NO_INSTALL=1`.
- **Silencioso.** `--silent` / `--quiet` sin stdout/stderr, ideal para `sxhkd`.
- **Validacion estricta.** `--word-len` / `--hash-chars` entre 1 y 64.
- **Traza opcional.** `TWOCLIP_DEBUG=1` para diagnostico.

---

## Instalacion

### Dependencias por distro

Solo necesitas Bash 4+, un backend de portapapeles y, opcionalmente,
`notify-send` y `jq`.

| Distro | Backend X11 | Backend Wayland |
|---|---|---|
| Arch / Manjaro | `sudo pacman -S xclip libnotify jq` | `sudo pacman -S wl-clipboard` |
| Debian / Ubuntu | `sudo apt install xclip libnotify-bin jq` | `sudo apt install wl-clipboard` |
| Fedora / RHEL 9+ | `sudo dnf install xclip libnotify jq` | `sudo dnf install wl-clipboard` |
| openSUSE | `sudo zypper install xclip libnotify-tools jq` | `sudo zypper install wl-clipboard` |
| Alpine | `sudo apk add xclip libnotify jq` | `sudo apk add wl-clipboard` |
| Void | `sudo xbps-install -S xclip libnotify jq` | `sudo xbps-install -S wl-clipboard` |
| Gentoo | `sudo emerge -av x11-misc/xclip x11-libs/libnotify app-misc/jq` | `sudo emerge -av gui-apps/wl-clipboard` |
| NixOS | `nix-shell -p xclip libnotify jq` | `nix-shell -p wl-clipboard` |

Guia detallada, incluyendo RHEL 8, CentOS Stream, Rocky, AlmaLinux y
macOS: ver [INSTALL.md](INSTALL.md).

### Instalacion desde el fuente

    git clone https://github.com/iendure/2Clipboard.git ~/.local/src/2Clipboard
    cd ~/.local/src/2Clipboard
    make install
    hash -r
    2Clipboard --version

### Instalacion sin git

    curl -fsSL https://github.com/iendure/2Clipboard/archive/refs/tags/v2.2.0.tar.gz \
        | tar -xz -C /tmp
    cd /tmp/2Clipboard-2.2.0
    make install
    hash -r

### Estructura creada

    ~/.config/2Clipboard/templates/    <- plantillas .tpl
    ~/.cache/2Clipboard/history.log    <- historial
    ~/.cache/2Clipboard/slots/         <- slots con nombre

Detalles completos (dependencias por distro, integracion con sxhkd, i3,
sway, Hyprland, XFCE4, troubleshooting): [INSTALL.md](INSTALL.md).

---

## Inicio rapido

    # Codigo de proyecto clasico (v1)
    2Clipboard gen
    # -> [2026-10-09]-kamishin-cdb28c17

    # Solo el identificador
    2Clipboard id
    # -> zeciiaoo-bc811448

    # Encabezado markdown con campos en blanco
    2Clipboard header

    # Adjuntar un archivo con cabecera trazable
    2Clipboard file ~/notas.md --title "Notas" --tags "journal,personal"

    # Encabezado en blanco + contenido de un archivo
    2Clipboard header --body @~/prompt.md --title "" --tags ""

    # Correr un comando y copiar su salida
    2Clipboard run -- ls -la /etc

    # Validar existencia (copia "true" o "false")
    2Clipboard check /etc/hosts

---

## Acciones

   2Clipboard [ACCION] [OPCIONES...]

Sin accion → `gen`.

| Accion | Alias | Descripcion |
|---|---|---|
| `gen` | — | Identificador de proyecto (fecha + nombre + hash). Modo v1. |
| `header` | `head` | Solo el encabezado (con Date/ID/Tags listos para rellenar). |
| `id` | — | Solo el ID (`nombre-hash`). Util para scripting. |
| `text STR` | — | Copia un literal con cabecera. |
| `file PATH` | — | Copia un archivo con cabecera. |
| `run -- CMD [ARGS]` | — | Ejecuta CMD, captura stdout+stderr y su exit, propaga el exit. |
| `check PATH` | — | `true` si existe (archivo/carpeta/comando), si no `false`. |
| `git` | — | Branch, commit, archivos sucios, remote. |
| `env VAR` | — | Valor de una variable de entorno. |
| `slot save NAME` | — | Guarda el portapapeles actual en un slot. |
| `slot load NAME` | — | Restaura un slot al portapapeles. |
| `slot list` | — | Lista slots existentes. |
| `slot del NAME` | `slot rm` | Elimina un slot. |
| `paste` | — | Imprime el portapapeles a stdout. |
| `history [N]` | — | Ultimas N entradas (def. 20). |
| `history grep PAT` | — | Filtra entradas por patron. |
| `history clear` | — | Vacia el historial. |
| `version` | — | Imprime la version. |

---

## Opciones

### Generacion (aplican a `gen`)

| Opcion | Defecto | Descripcion |
|---|---|---|
| `-w`, `--word-len LEN` | `8` | Longitud del nombre (1-64). |
| `-H`, `--hash-chars CHARS` | `8` | Longitud del hash (1-64). |
| `--no-name` | — | Omite el nombre. |
| `--no-hash` | — | Omite el hash. |
| `--date-format FMT` | `%Y-%m-%d` | Formato `strftime` (`""` desactiva). |
| `--time-format FMT` | desactivado | Formato `strftime` (ej. `%H:%M`). |
| `--date-prefix STR` | `[` | Prefijo antes de la fecha. |
| `--date-suffix STR` | `]` | Sufijo tras la fecha. |
| `--name-prefix STR` | `-` | Prefijo antes del nombre. |
| `--name-suffix STR` | `""` | Sufijo tras el nombre. |
| `--hash-prefix STR` | `-` | Prefijo antes del hash. |

> `-h` esta reservado para `--help`; el atajo del hash es `-H`.

### Cabecera y formato (todas las acciones)

| Opcion | Descripcion |
|---|---|
| `--title STR` | Titulo de la cabecera. |
| `--tags STR` | Tags separados por coma. |
| `--no-title` | Suprime la linea `# ` del titulo. |
| `--header` / `--no-header` | Fuerza / desactiva cabecera. |
| `--format FMT` | `markdown` \| `plain` \| `json` \| `yaml`. |
| `--template STR` | Plantilla inline, o `@ruta` a un `.tpl`. |
| `--profile NAME` | Atajo de `--template @NAME`. |
| `--body STR` | Cuerpo inline (con `header`). |
| `--body @PATH` | Cuerpo desde archivo (atajo). |
| `--body-file PATH` | Cuerpo desde archivo (forma larga). |

### Comportamiento (todas las acciones)

| Opcion | Descripcion |
|---|---|
| `--append` | Suma al final del portapapeles actual. |
| `--prepend` | Suma al principio del portapapeles actual. |
| `--stdout` | Emite el payload por stdout (mensajes a stderr). |
| `--dry-run` | No copia: solo imprime. |
| `--clip-cmd CMD` | Filtra el payload por `bash -c CMD` (payload por stdin). |
| `--silent`, `--quiet` | Silencia toda salida. |
| `--no-notify` | Sin notificaciones de escritorio. |
| `--no-history` | No registra en el historial. |
| `-h`, `--help` | Muestra la ayuda. |
| `-v`, `--version` | Muestra la version. |
| `--license` | Muestra la licencia (MIT). |

---

## Perfiles y plantillas

    ~/.config/2Clipboard/templates/
    |- llm.tpl
    |- zettel.tpl
    |- work.tpl
    |- bug.tpl
    `- minimal.tpl

Un perfil es una plantilla con nombre. Se invoca con `--profile NAME`, o
mediante `TWOCLIP_PROFILE`.

### Plantillas de referencia

`llm.tpl` — sesiones LLM:

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

`work.tpl` — bitacora laboral:

    [{{DATE}} {{TIME}}] {{ID}}
    Tags: {{TAGS}}
    Title: {{TITLE}}
    ---
    {{CONTENT}}

`bug.tpl` — reporte de bug:

    ## Bug Report {{ID}}

    - **Date:** {{DATE}}
    - **Tags:** {{TAGS}}
    - **Source:** `{{SOURCE}}`
    - **Cmd:** `{{CMD}}`  ->  exit {{STATUS}}

    ### Output
    {{CONTENT}}

`minimal.tpl` — una linea y tags:

    {{TITLE}} — {{DATE}} — {{ID}} — [{{TAGS}}]

    {{CONTENT}}

### Variables disponibles

| Variable | Contenido |
|---|---|
| `{{TITLE}}` | Titulo (`--title`). |
| `{{DATE}}` | Fecha formateada. |
| `{{TIME}}` | Hora formateada. |
| `{{ID}}` | Identificador completo (`nombre-hash`). |
| `{{NAME}}` | Solo el nombre pronunciable. |
| `{{HASH}}` | Solo el hash. |
| `{{TAGS}}` | Tags tal cual. |
| `{{SOURCE}}` | Ruta de origen. |
| `{{CONTENT}}` | Cuerpo. |
| `{{STATUS}}` | Exit code (`run`). |
| `{{CMD}}` | Comando ejecutado (`run`). |
| `{{HOST}}` | `hostname`. |
| `{{USER}}` | `$USER`. |
| `{{CWD}}` | Directorio actual. |
| `{{GIT_BRANCH}}` | Rama git. |
| `{{GIT_COMMIT}}` | Commit corto git. |
| `{{NOW}}` | Fecha+hora ISO 8601. |
| `{{VERSION}}` | Version de 2Clipboard. |

---

## Salida estructurada

### `markdown` (defecto)

    # Titulo
    - Date: **2026-10-09**
    - ID: **docigoji-e0d69df6**
    - Tags: ai,work

    <cuerpo>

### `plain`

    Titulo
    Date: 2026-10-09
    ID: docigoji-e0d69df6
    Tags: ai,work

    <cuerpo>

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

### Pipeline end-to-end

`--stdout` emite **solo** el payload por stdout; los mensajes van a stderr:

    # Extraer el ID de una sesion
    2Clipboard header --format json --tags "ai" --stdout 2>/dev/null | jq -r .id

    # Alimentar una API con el payload estructurado
    2Clipboard file prompt.md --format json --stdout 2>/dev/null \
        | curl -s https://api.example.com/v1/chat -d @-

    # Acumular sesiones en un YAML
    2Clipboard header --format yaml --tags "meta" --stdout 2>/dev/null \
        >> ~/sessions.yaml

---

## Variables de entorno

| Variable | Efecto |
|---|---|
| `TWOCLIP_PROFILE` | Perfil por defecto (equivale a `--profile`). |
| `TWOCLIP_TAGS` | Tags por defecto. |
| `TWOCLIP_TITLE` | Titulo por defecto. |
| `TWOCLIP_BACKEND` | `x11` o `wayland` (defecto `auto`). |
| `TWOCLIP_NO_INSTALL` | `1` desactiva el auto-install. |
| `TWOCLIP_DEBUG` | `1` activa traza detallada. |

Las banderas CLI tienen mayor prioridad que las variables.

---

## Backends de portapapeles

Deteccion real, por orden:

1. `TWOCLIP_BACKEND=x11|wayland` -> se usa tal cual.
2. `WAYLAND_DISPLAY` definido **y** socket presente -> Wayland.
3. `XDG_SESSION_TYPE=wayland` **y** socket `wayland-0` -> Wayland.
4. `DISPLAY` definido -> X11 (`xclip`, luego `xsel`).
5. Nada -> el payload se imprime a stdout para no perderlo.

Evita el clasico *"Failed to connect to a Wayland server"* en maquinas X11
que tienen `wl-copy` instalado como dependencia de otra cosa.

---

## Slots e historial

    # Guardar el portapapeles actual
    2Clipboard slot save 2fa

    # Restaurarlo
    2Clipboard slot load 2fa

    # Listar, borrar
    2Clipboard slot list
    2Clipboard slot del 2fa

    # Guardar desde stdin
    echo "contenido" | 2Clipboard slot save borrador

    # Historial
    2Clipboard history 50
    2Clipboard history grep ai
    2Clipboard history clear

Formato: `fecha<TAB>accion<TAB>preview(120 chars)`.

---

## Recetas y casos de uso

### A. Encabezado solo, con campos en blanco

    2Clipboard header --tags ""

### B. Prompt de sistema para LLM con trazabilidad

    2Clipboard header --body @~/prompt.md --title "" --tags ""

### C. Pregunta corta para chat IA

    2Clipboard header --body "Como optimizo esta consulta SQL?" --tags "ai,sql,question"

### D. Pegar codigo con contexto

    sed -n '1,200p' src/main.py | 2Clipboard header --title "main.py" --tags "ai,code,snippet"

### E. Bitacora de trabajo diaria

    2Clipboard header --profile work --title "Log $(date +%A)" --tags "journal"

### F. Reporte de bug

    2Clipboard run -- ./repro.sh
    # o:
    2Clipboard header --profile bug --body @/tmp/repro.log --tags "bug,repro"

### G. Commit log

    git log --oneline -20 | 2Clipboard header --title "Recent Commits" --tags "git,log"

### H. Validar antes de actuar

    if [ "$(2Clipboard check /etc/nginx/nginx.conf --silent)" = "true" ]; then
        systemctl restart nginx
    fi

### I. ID para scripting

    SID="$(2Clipboard id --silent)"
    mkdir -p "/tmp/$SID"

### J. Modificar el portapapeles sin reemplazarlo

    2Clipboard header --tags "refined" --prepend
    echo -e "\n\n---\nNota" | 2Clipboard text --append --no-header
    2Clipboard file a.md --append
    2Clipboard file b.md --append

### K. JSON / YAML para automatizacion

    2Clipboard header --format json --tags "ai" --stdout 2>/dev/null | jq -r .id
    2Clipboard header --format yaml --tags "meta" --stdout 2>/dev/null >> ~/session.yaml

### L. Wrappers de otros scripts

    snapshot() {
        local title="${1:-Auto}"
        2Clipboard git --title "$title" --append --silent
    }

### M. Slots para secretos temporales

    2Clipboard slot save 2fa
    2Clipboard slot load 2fa

---

## Integracion con gestores de atajos

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

### XFCE4

Configuracion -> Teclado -> Atajos, asigna `2Clipboard header --profile llm --silent`.

---

## Embeber 2Clipboard en otros scripts

    #!/usr/bin/env bash
    set -euo pipefail
    export TWOCLIP_NO_INSTALL=1

    sid="$(2Clipboard id --silent --stdout)"
    payload="$(2Clipboard header --format json --tags "batch" --stdout 2>/dev/null)"
    echo "$payload" | jq -r .id
    echo "Sesion: $sid"

- `TWOCLIP_NO_INSTALL=1` — no reescribe el binario desplegado.
- `--silent` — cero salida por stdout/stderr.
- `--stdout` — payload por stdout; mensajes a stderr.
- `--dry-run` — no toca el portapapeles.

---

## Solucion de problemas

### *Failed to connect to a Wayland server* en X11

    export TWOCLIP_BACKEND=x11

### `line NNN: GIT_BRANCH: unbound variable`

Version desplegada obsoleta:

    ~/.bin/2Clipboard --version
    hash -r
    2Clipboard --version

### `jq: parse error` al pipear

Los mensajes van a stderr en 2.2.0. Verifica:

    grep 'copied to clipboard' ~/.bin/2Clipboard
    # debe terminar en:  >&2 ;;

### Pipeline colgado tras `| head`

La version actual redirige `xclip` a `/dev/null`:

    grep 'xclip -selection clipboard -i' ~/.bin/2Clipboard

### `--body @ruta` no carga el archivo

    grep -A3 '\-\-body)' ~/.bin/2Clipboard
    # debe contener:  @*) BODY="${BODY#@}"; BODY_IS_FILE=true ;;

### Los tests fallan con `binary: ~/.bin`

    BIN="$(command -v 2Clipboard)" bash tests/smoke.sh

o con diagnostico:

    VERBOSE=1 bash tests/smoke.sh

### Traza detallada de cualquier operacion

    TWOCLIP_DEBUG=1 2Clipboard header --tags test

---

## Documentacion adicional

- [INSTALL.md](INSTALL.md) — instalacion detallada, integracion, troubleshooting.
- [CHANGELOG.md](CHANGELOG.md) — historial de versiones.
- [tests/smoke.sh](tests/smoke.sh) — suite de pruebas de humo.

---

## Hoja de ruta

- [ ] Config file persistente (`~/.config/2Clipboard/config`).
- [ ] Modo diccionario / wordlist con palabras reales.
- [ ] Menu TUI / rofi / dmenu.
- [ ] Busqueda en historial con `fzf`.
- [ ] Exportacion enriquecida: HTML, org-mode.
- [ ] Encriptacion de slots con `age` o `gpg`.
- [ ] Multi-portapapeles por workspace.

---

## ENDURE

**Built to last.**

| Canal | Enlace |
|---|---|
| Web | https://endure.digital/ |
| GitHub | https://github.com/iendure |
| Contacto | https://c.endure.digital/ |
| WhatsApp | https://w.endure.digital/ |

---

## Parte de ENDURE

<p align="center">
  <img src="assets/ENDURE__logo__dark_Built_to_last.svg" alt="ENDURE — Built to last" width="220">
</p>

**2Clipboard es construido y mantenido por [ENDURE](https://endure.digital/)**,
una casa de herramientas enfocadas y duraderas. Descubre el catálogo
completo en [endure.digital/brands](https://endure.digital/brands).

<p align="center">
  <a href="https://endure.digital/">Sitio</a> ·
  <a href="https://endure.digital/brands">Todas las marcas</a> ·
  <a href="https://github.com/iendure">GitHub</a> ·
  <a href="https://c.endure.digital/">Contacto</a> ·
  <a href="https://w.endure.digital/">WhatsApp</a>
</p>

---

## Licencia

MIT. Ver [LICENSE](LICENSE).

Copyright (c) 2026 ENDURE · Built to last.
