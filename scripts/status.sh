#!/usr/bin/env bash
# Näyttää firmwaren, WiFin, käyntiajan ja releen tilan
. "$(dirname "$0")/common.sh"
R=$(cmnd "status 0")
[ -n "${R//[[:space:]]/}" ] || { echo "Laite ei vastaa osoitteessa $PLUG_IP" >&2; exit 1; }
echo "$R" | python3 -c '
import sys,json
d=json.load(sys.stdin); w=d["StatusSTS"]["Wifi"]
print("Firmware:", d["StatusFWR"]["Version"])
print("WiFi:    ", w["SSId"], "(" + str(w["RSSI"]) + " %)")
print("IP:      ", d["StatusNET"]["IPAddress"], "/", d["StatusNET"]["Hostname"])
print("Uptime:  ", d["StatusSTS"]["Uptime"])
print("Rele:    ", d["StatusSTS"].get("POWER", d["StatusSTS"].get("POWER1","?")))
print("Restart: ", d["StatusPRM"]["RestartReason"])'
