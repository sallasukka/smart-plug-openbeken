#!/usr/bin/env bash
# Yhteiset asetukset kaikille skripteille
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
[ -f "$ROOT/.env" ] && set -a && . "$ROOT/.env" && set +a
PLUG_IP="${PLUG_IP:-}"
SERIAL_PORT="${SERIAL_PORT:-/dev/ttyUSB0}"
OBK_VERSION="${OBK_VERSION:-1.18.321}"
VENV="$ROOT/venv"
need_ip() { [ -n "$PLUG_IP" ] || { echo "Aseta PLUG_IP tiedostoon .env" >&2; exit 1; }; }
AUTH=(); [ -n "${PLUG_PASSWORD:-}" ] && AUTH=(-u "admin:$PLUG_PASSWORD")
cmnd() { need_ip; curl -s -m 10 "${AUTH[@]}" "http://$PLUG_IP/cm?cmnd=$(python3 -c 'import sys,urllib.parse;print(urllib.parse.quote(sys.argv[1]))' "$1")"; echo; }
