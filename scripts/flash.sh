#!/usr/bin/env bash
# Kirjoittaa OpenBekenin johdon (UART) kautta
. "$(dirname "$0")/common.sh"
FW="$ROOT/fw/OpenBK7231N_QIO_$OBK_VERSION.bin"
[ -f "$FW" ] || { echo "Puuttuu $FW, aja ensin scripts/download-firmware.sh" >&2; exit 1; }
ls "$ROOT"/backup/*.bin >/dev/null 2>&1 || { echo "Ei varmuuskopiota! Aja ensin scripts/backup.sh" >&2; exit 1; }
echo "Kytke CEN hetkeksi maahan (reset), kun työkalu odottaa yhteyttä."
"$VENV/bin/ltchiptool" flash write -d "$SERIAL_PORT" -t 60 "$FW"
