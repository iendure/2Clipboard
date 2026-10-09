# Changelog

Formato: [Keep a Changelog](https://keepachangelog.com/).
Versionado: [SemVer](https://semver.org/lang/es/).

Mantenido por **ENDURE · Built to last** — https://endure.digital/

## [2.2.0] — 2026-10-09

### Añadido
- Validación estricta de `--word-len` / `--hash-chars` (enteros 1-64).
- `TWOCLIP_DEBUG=1` para traza detallada a stderr.
- Subcomando `version` (además de `--version`).
- Flag `--license` para imprimir la licencia MIT.
- `Makefile`: targets `release` (tarball + sha256), `check` (alias `lint`),
  `DESTDIR` para empaquetado.
- Mensajes de error/warning consistentes (`2Clipboard: error: ...`).

### Corregido
- `render_template`: eliminados escapes falsos de `&` y `/` que inyectaban
  caracteres literales en los valores.
- `--clip-cmd`: ya no usa `eval`; pasa por `bash -c` con payload por stdin.
- `--dry-run --stdout` ya no imprime dos veces.
- `slot load --dry-run` no toca el portapapeles.

## [2.1.0] — 2026-10-09

### Añadido
- Acción `header` para emitir solo el encabezado.
- Acción `id` para obtener solo el identificador (nombre-hash).
- `--dry-run`, `--clip-cmd`, `--quiet`.
- `slot save` lee de stdin si hay datos.
- `history grep PAT` y `history clear`.
- `TWOCLIP_PROFILE`, `TWOCLIP_TAGS`, `TWOCLIP_TITLE`.
- Detección real del backend (Wayland solo si el socket existe).

### Corregido
- `--body @archivo` carga el contenido.
- `GIT_BRANCH` / `GIT_COMMIT` inicializadas.
- Duplicado de `paste_from_clipboard` eliminado.
- Mensajes de estado a stderr; `--stdout` pipeable a jq/yq/curl.
- `xclip` / `xsel` no heredan stdout (fin del pipe colgado).
- `--help` y `--version` no leen stdin.
- `history grep PAT` acepta posicionales múltiples.

### Cambiado
- `-H` (mayúscula) para `--hash-chars`; `-h` queda para `--help`.
- `action_file` ya no autocompleta TITLE con el basename.

## [2.0.0] — 2026-10-08

### Añadido
- Subcomandos: gen, text, file, run, check, git, env, slot, paste, history.
- Detección automática de stdin.
- Plantillas {{VAR}} inline o desde ~/.config/2Clipboard/templates/.
- Formatos: markdown, plain, json, yaml.
- Historial (history.log).
- Slots con nombre (slots/).
- --append / --prepend.
- Autoinstalación en PATH.

## [1.0.0] — 2026-10-07

### Añadido
- Generación de código [YYYY-MM-DD]-nombre-hash.
- Nombres pronunciables + hash criptográfico.
- Copia al portapapeles (Wayland / X11).
- Notificaciones de escritorio.
