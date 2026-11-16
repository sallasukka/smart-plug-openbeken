#!/usr/bin/env bash
# Langaton päivitys: lähettää .rbl-tiedoston laitteelle ja käynnistää sen uudelleen.
# Käyttö: scripts/ota.sh [polku.rbl]   (oletus: fw/OpenBK7231N_<OBK_VERSION>.rbl)
# Vaihtoehto: web-käyttöliittymä -> OTA -> valitse .rbl
. "$(dirname "$0")/common.sh"; need_ip
RBL="${1:-$ROOT/fw/OpenBK7231N_$OBK_VERSION.rbl}"
case "$(basename "$RBL")" in OpenBK7231N_*.rbl) ;; *) echo "Tiedoston pitää olla OpenBK7231N_*.rbl (N-versio!)" >&2; exit 1;; esac
curl -fsS -m 120 --data-binary @"$RBL" "http://$PLUG_IP/api/ota" && echo
curl -fsS -m 10 -X POST "http://$PLUG_IP/api/reboot" && echo
echo "Odota ~30 s ja aja scripts/status.sh"
