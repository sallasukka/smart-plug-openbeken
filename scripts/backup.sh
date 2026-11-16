#!/usr/bin/env bash
# Lukee koko 2 Mt flash-muistin talteen (alkuperäinen Tuya-firmware). Tee AINA ennen flashausta.
. "$(dirname "$0")/common.sh"
mkdir -p "$ROOT/backup"
OUT="$ROOT/backup/original_full_$(date +%Y%m%d_%H%M%S).bin"
echo "Kytke CEN hetkeksi maahan (reset), kun työkalu odottaa yhteyttä."
"$VENV/bin/bk7231tools" read_flash -d "$SERIAL_PORT" --timeout 60 "$OUT"
sha256sum "$OUT"
"$VENV/bin/bk7231tools" dissect_dump -e -O "$ROOT/backup/dissect" "$OUT" || true
