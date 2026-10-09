#!/usr/bin/env bash
# tests/smoke.sh — smoke tests for 2Clipboard
set -uo pipefail

# ---- Resolve script and binary ------------------------------------------------
HERE="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
ROOT="$(cd -- "$HERE/.." >/dev/null 2>&1 && pwd -P)"

# $BIN gana SOLO si es un fichero ejecutable real (no un directorio,
# no un symlink roto, no una cadena vacía exportada por accidente).
is_exec_file() {
    [ -f "$1" ] && [ -x "$1" ] && [ ! -d "$1" ]
}

if [ -n "${BIN:-}" ] && is_exec_file "$BIN"; then
    BIN_CMD="$BIN"
elif is_exec_file "$ROOT/2Clipboard"; then
    BIN_CMD="$ROOT/2Clipboard"
elif command -v 2Clipboard >/dev/null 2>&1 \
     && is_exec_file "$(command -v 2Clipboard)"; then
    BIN_CMD="$(command -v 2Clipboard)"
else
    echo "2Clipboard not found (checked \$BIN='${BIN:-}'," >&2
    echo "  $ROOT/2Clipboard, PATH)" >&2
    echo "Unset BIN or pass a valid path: BIN=/path/to/2Clipboard bash tests/smoke.sh" >&2
    exit 1
fi

# Aviso si $BIN apuntaba a algo inválido (para que no sea silencioso).
if [ -n "${BIN:-}" ] && ! is_exec_file "$BIN"; then
    printf '[warn] BIN=%q ignorado (no es fichero ejecutable)\n' "$BIN" >&2
fi

# Never trigger self-install from tests
export TWOCLIP_NO_INSTALL=1

# ---- Counters -----------------------------------------------------------------
PASS=0
FAIL=0
VERBOSE="${VERBOSE:-0}"

ok()   { printf '  [ok]   %s\n' "$1"; PASS=$((PASS+1)); }
fail() { printf '  [FAIL] %s\n' "$1"; FAIL=$((FAIL+1)); }

# run_test DESC -- CMD...
run_test() {
    local desc="$1"; shift
    [ "${1:-}" = "--" ] && shift
    local out rc
    out="$("$@" 2>&1)"; rc=$?
    if [ "$rc" -eq 0 ]; then
        ok "$desc"
    else
        fail "$desc"
        [ "$VERBOSE" = "1" ] && printf '         %s\n' "${out//$'\n'/$'\n'         }"
    fi
}

echo "== 2Clipboard smoke tests =="
echo "   binary: $BIN_CMD"
echo "   root:   $ROOT"
echo

run_test "--version prints something" \
    -- bash -c "$BIN_CMD --version | grep -q '^2Clipboard'"

run_test "--help exits 0" \
    -- bash -c "$BIN_CMD --help >/dev/null"

run_test "gen produces output" \
    -- bash -c "[ -n \"\$($BIN_CMD gen --silent --stdout)\" ]"

run_test "id has name-hash shape" \
    -- bash -c "$BIN_CMD id --silent --stdout | grep -Eq '^[a-z]+-[0-9a-f]+$'"

run_test "header contains Date" \
    -- bash -c "$BIN_CMD header --silent --stdout | grep -q 'Date:'"

run_test "header contains Tags" \
    -- bash -c "$BIN_CMD header --silent --stdout | grep -q 'Tags:'"

run_test "check true" \
    -- bash -c "[ \"\$($BIN_CMD check /etc/hosts --silent --stdout --no-notify)\" = true ]"

run_test "check false" \
    -- bash -c "[ \"\$($BIN_CMD check /ruta/que/no/existe --silent --stdout --no-notify)\" = false ]"

run_test "JSON parseable" \
    -- bash -c "$BIN_CMD header --format json --tags ai --silent --stdout 2>/dev/null | jq -e . >/dev/null"

run_test "YAML contains id" \
    -- bash -c "$BIN_CMD header --format yaml --silent --stdout | grep -q '^id:'"

run_test "--body @file reads content" \
    -- bash -c "f=\$(mktemp); echo 'marca-xyz' > \$f; $BIN_CMD header --body @\$f --silent --stdout | grep -q 'marca-xyz'; rc=\$?; rm -f \$f; exit \$rc"

run_test "--dry-run does not copy" \
    -- bash -c "$BIN_CMD header --tags x --dry-run --stdout | grep -q 'Tags:'"

run_test "run propagates exit 0" \
    -- bash -c "$BIN_CMD run -- true --silent"

run_test "run propagates exit != 0" \
    -- bash -c "$BIN_CMD run -- false --silent; [ \$? -ne 0 ]"

run_test "unknown action fails" \
    -- bash -c "! $BIN_CMD nonexistent-action 2>/dev/null"

run_test "unknown option fails" \
    -- bash -c "! $BIN_CMD --nonexistent 2>/dev/null"

run_test "history N works" \
    -- bash -c "$BIN_CMD history 5 >/dev/null"

echo
echo "Result: $PASS ok, $FAIL failed"
[ "$FAIL" -eq 0 ] || exit 1
