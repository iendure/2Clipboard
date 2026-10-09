<p align="center">
  <img src="assets/ENDURE__logo__dark_Built_to_last.svg" alt="ENDURE — Built to last" width="280">
</p>

# Contribuir a 2Clipboard

**ENDURE · Built to last** — https://endure.digital/

Gracias por tu interés. Es una herramienta pequeña y enfocada. Los parches
son bienvenidos, pero mantenlos acotados y probados.

## Reglas básicas

- Solo Bash 4+. Sin dependencias externas más allá de las que ya lista
  `README.md`.
- Todo cambio en `2Clipboard` debe mantener `make test` pasando (17/17).
- Añade un smoke test en `tests/smoke.sh` para cualquier flag o subcomando
  nuevo visible al usuario.
- Actualiza `CHANGELOG.md` bajo una sección `Unreleased` o versionada.
- Mantén la superficie pública del CLI retrocompatible dentro de la misma
  versión mayor. Las deprecaciones pasan primero por `CHANGELOG.md`.

## Flujo de trabajo

    git clone https://github.com/iendure/2Clipboard.git
    cd 2Clipboard
    make lint
    make test
    # edita
    make test

## Estilo de commits

Asunto imperativo y corto (<= 72 caracteres), línea en blanco, cuerpo si
hace falta. Ejemplos:

    fix: --body @file ahora lee el archivo
    feat: añadir `history grep PAT`
    docs: aclarar detección de backend X11 vs Wayland

## Publicar un release

    # 1. Sube VERSION en 2Clipboard
    # 2. Actualiza CHANGELOG.md con la sección nueva
    # 3. Ejecuta:
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
