#!/usr/bin/env bash
# Writes OpenBeken over the cable (UART)
. "$(dirname "$0")/common.sh"
FW="$ROOT/fw/OpenBK7231N_QIO_$OBK_VERSION.bin"
[ -f "$FW" ] || { echo "Missing $FW, run scripts/download-firmware.sh first" >&2; exit 1; }
ls "$ROOT"/backup/*.bin >/dev/null 2>&1 || { echo "No backup! Run scripts/backup.sh first" >&2; exit 1; }
echo "Briefly connect CEN to ground (reset) while the tool is waiting for a connection."
"$VENV/bin/ltchiptool" flash write -d "$SERIAL_PORT" -t 60 "$FW"
