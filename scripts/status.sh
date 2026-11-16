#!/usr/bin/env bash
# Shows firmware, WiFi, uptime and relay state
. "$(dirname "$0")/common.sh"
R=$(cmnd "status 0")
[ -n "${R//[[:space:]]/}" ] || { echo "Device not responding at $PLUG_IP" >&2; exit 1; }
echo "$R" | python3 -c '
import sys,json
d=json.load(sys.stdin); w=d["StatusSTS"]["Wifi"]
print("Firmware:", d["StatusFWR"]["Version"])
print("WiFi:    ", w["SSId"], "(" + str(w["RSSI"]) + " %)")
print("IP:      ", d["StatusNET"]["IPAddress"], "/", d["StatusNET"]["Hostname"])
print("Uptime:  ", d["StatusSTS"]["Uptime"])
print("Relay:   ", d["StatusSTS"].get("POWER", d["StatusSTS"].get("POWER1","?")))
print("Restart: ", d["StatusPRM"]["RestartReason"])'
