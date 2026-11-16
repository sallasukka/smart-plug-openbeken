#!/usr/bin/env bash
# PFW02-G:n pinniasetukset: P24 rele, P26 nappi, P7 WiFi-LED (käänteinen)
# Käyttö: PLUG_IP=192.168.4.1 scripts/configure-pins.sh  (laitteen oma AP)
. "$(dirname "$0")/common.sh"
for c in "setPinRole 24 Rel" "setPinChannel 24 1" \
         "setPinRole 26 Btn" "setPinChannel 26 1" \
         "setPinRole 7 WifiLED_n" "setPinChannel 7 0"; do
  echo "> $c"; cmnd "$c"
done
