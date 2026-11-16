#!/usr/bin/env bash
# Wireless update: sends an .rbl file to the device and restarts it.
# Usage: scripts/ota.sh [path.rbl]   (default: fw/OpenBK7231N_<OBK_VERSION>.rbl)
# Alternative: web UI -> OTA -> choose the .rbl
. "$(dirname "$0")/common.sh"; need_ip
RBL="${1:-$ROOT/fw/OpenBK7231N_$OBK_VERSION.rbl}"
case "$(basename "$RBL")" in OpenBK7231N_*.rbl) ;; *) echo "File must be OpenBK7231N_*.rbl (the N build!)" >&2; exit 1;; esac
curl -fsS -m 120 "${AUTH[@]}" --data-binary @"$RBL" "http://$PLUG_IP/api/ota" && echo
curl -fsS -m 10 "${AUTH[@]}" -X POST "http://$PLUG_IP/api/reboot" && echo
echo "Wait ~30 s, then run scripts/status.sh"
