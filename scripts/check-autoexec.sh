#!/usr/bin/env bash
# Tarkistaa kellon, ajastukset ja releen tilan
. "$(dirname "$0")/common.sh"
echo "== Kello / NTP";      cmnd "ntp_info"
echo "== Aikataulut";       cmnd "listClockEvents"
echo "== Tila";             "$(dirname "$0")/status.sh"
echo "(Tarkemmat tulosteet näkyvät web-käyttöliittymän Logs-välilehdellä.)"
