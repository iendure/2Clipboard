# =============================================================================
#  2Clipboard — Makefile
#  ENDURE · Built to last
#    Web:      https://endure.digital/
#    GitHub:   https://github.com/iendure
#    Contact:  https://c.endure.digital/
#    WhatsApp: https://w.endure.digital/
# =============================================================================
SHELL   := /usr/bin/env bash
NAME    := 2Clipboard
SRC     := $(NAME)
PREFIX  ?= $(HOME)/.local
BINDIR  ?= $(PREFIX)/bin
DESTDIR ?=
VERSION := $(shell grep -m1 '^readonly VERSION=' $(SRC) | cut -d'"' -f2)

.PHONY: all install uninstall test lint check help clean release dist about docs templates list

all: help

about:
	@echo "2Clipboard — Built to last"
	@echo "  Web:      https://endure.digital/"
	@echo "  GitHub:   https://github.com/iendure"
	@echo "  Contact:  https://c.endure.digital/"
	@echo "  WhatsApp: https://w.endure.digital/"

help:
	@echo "2Clipboard $(VERSION) — make targets:"
	@echo "  make install      Instala en $(DESTDIR)$(BINDIR)"
	@echo "  make uninstall    Elimina la instalación"
	@echo "  make test         Ejecuta las pruebas de humo (17)"
	@echo "  make lint|check   bash -n + shellcheck (si está)"
	@echo "  make release      Crea dist/2Clipboard-$(VERSION).tar.gz + .sha256"
	@echo "  make clean        Limpia backups, dist/ y temporales"
	@echo "  make about        Muestra la identidad ENDURE"
	@echo "  make docs         Lista los sources de docs/"
	@echo "  make templates    Lista las plantillas de ejemplo"
	@echo "  make list         Lista los archivos trackeados"

install:
	@mkdir -p "$(DESTDIR)$(BINDIR)"
	@install -m 755 "$(SRC)" "$(DESTDIR)$(BINDIR)/$(NAME)"
	@echo "[ok] Instalado: $(DESTDIR)$(BINDIR)/$(NAME)"
	@echo "     Verifica: hash -r && $(NAME) --version"

uninstall:
	@rm -f "$(DESTDIR)$(BINDIR)/$(NAME)"
	@rm -rf "$(HOME)/.cache/$(NAME)"
	@echo "[ok] Desinstalado. Plantillas en ~/.config/$(NAME)/ se conservan."

lint check:
	@bash -n "$(SRC)" && echo "[ok] sintaxis"
	@command -v shellcheck >/dev/null 2>&1 \
	    && shellcheck -S warning "$(SRC)" \
	    || echo "[i] shellcheck no instalado"

test:
	@bash tests/smoke.sh

release:
	@mkdir -p dist
	@tar -czf "dist/$(NAME)-$(VERSION).tar.gz" \
	     --exclude=dist \
	     --exclude=.git \
	     --exclude=.archive \
	     --exclude=.pytest_cache \
	     --exclude=__pycache__ \
	     --exclude='*.bak.*' \
	     --exclude='*.tmp' \
	     --exclude='*.tar.gz' \
	     --exclude='*.tar.gz.sha256' \
	     -C "$(CURDIR)/.." "$(NAME)"
	@cd dist && sha256sum "$(NAME)-$(VERSION).tar.gz" > "$(NAME)-$(VERSION).tar.gz.sha256"
	@echo "[ok] dist/$(NAME)-$(VERSION).tar.gz"
	@cat "dist/$(NAME)-$(VERSION).tar.gz.sha256"

clean:
	@rm -f *.bak.* *.tmp 2>/dev/null || true
	@rm -rf dist 2>/dev/null || true
	@echo "[ok] Limpio"

docs:
	@echo "Documentation sources in docs/ — 8 pages ready for an SSG."
	@ls -1 docs/*.md

templates:
	@echo "Example templates in examples/templates/ — copy them with:"
	@echo "  mkdir -p ~/.config/$(NAME)/templates"
	@echo "  cp examples/templates/*.tpl ~/.config/$(NAME)/templates/"
	@ls -1 examples/templates/*.tpl

list:
	@echo "== Tracked files =="
	@git ls-files 2>/dev/null || find . -type f -not -path './.git/*' | sort

