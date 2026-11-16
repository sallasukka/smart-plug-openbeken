#!/usr/bin/env bash
# Reads the whole 2 MB flash (stock Tuya firmware). ALWAYS do this before flashing.
. "$(dirname "$0")/common.sh"
mkdir -p "$ROOT/backup"
OUT="$ROOT/backup/original_full_$(date +%Y%m%d_%H%M%S).bin"
echo "Briefly connect CEN to ground (reset) while the tool is waiting for a connection."
"$VENV/bin/bk7231tools" read_flash -d "$SERIAL_PORT" --timeout 60 "$OUT"
sha256sum "$OUT"
"$VENV/bin/bk7231tools" dissect_dump -e -O "$ROOT/backup/dissect" "$OUT" || true
