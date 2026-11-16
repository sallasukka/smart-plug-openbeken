#!/usr/bin/env bash
# Generoi config/autoexec.bat .env-asetuksista, lähettää sen laitteelle,
# asettaa releen tilan sähkökatkon jälkeen ja käynnistää laitteen uudelleen.
#
# .env:
#   AUTO_OFF_MIN=45          sammutus n minuutin päästä (pakollinen, 1–240)
#   MORNING_TIME=06:30       aamukäynnistys, tyhjä = pois päältä
#   MORNING_DAYS=0x3E        0x3E = ma–pe, 0x7F = joka päivä (0x01 su, 0x02 ma ... 0x40 la)
#   NTP_SERVER=           NTP-palvelimen IP-osoite, tyhjä = OpenBekenin oletus
#   DRY_RUN=1                vain generoi tiedoston, ei lähetä
. "$(dirname "$0")/common.sh"
AUTO_OFF_MIN="${AUTO_OFF_MIN:-45}"
MORNING_TIME="${MORNING_TIME:-}"
MORNING_DAYS="${MORNING_DAYS:-0x3E}"
NTP_SERVER="${NTP_SERVER:-}"
if [ -n "$NTP_SERVER" ]; then NTP_LINE="ntp_setServer $NTP_SERVER"; else NTP_LINE="// NTP-palvelin: OpenBekenin oletus"; fi

[[ "$AUTO_OFF_MIN" =~ ^[0-9]+$ ]] && (( AUTO_OFF_MIN >= 1 && AUTO_OFF_MIN <= 240 )) \
  || { echo "AUTO_OFF_MIN pitää olla 1–240" >&2; exit 1; }
if [ -n "$MORNING_TIME" ]; then
  [[ "$MORNING_TIME" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]] || { echo "MORNING_TIME muotoa HH:MM" >&2; exit 1; }
  [[ "$MORNING_DAYS" =~ ^0x[0-9A-Fa-f]{1,2}$ ]] || { echo "MORNING_DAYS muotoa 0x3E" >&2; exit 1; }
  MORNING_LINE="addClockEvent $MORNING_TIME $MORNING_DAYS 1 setChannel 1 1"
else
  MORNING_LINE="// pois päältä (aseta MORNING_TIME .env:iin)"
fi

OUT="$ROOT/config/autoexec.bat"
sed -e "s|@AUTO_OFF_MIN@|$AUTO_OFF_MIN|g" -e "s|@AUTO_OFF_SEC@|$((AUTO_OFF_MIN*60))|g" \
    -e "s|@NTP_LINE@|$NTP_LINE|g" -e "s|@MORNING_LINE@|$MORNING_LINE|g" \
    "$ROOT/config/autoexec.bat.template" > "$OUT"
echo "Generoitu $OUT:"; grep -vE '^\s*(//|$)' "$OUT" | sed 's/^/  /'
[ "${DRY_RUN:-0}" = 1 ] && exit 0

need_ip
echo "> Lähetetään autoexec.bat"
curl -fsS -m 20 "${AUTH[@]}" --data-binary @"$OUT" "http://$PLUG_IP/api/lfs/autoexec.bat"; echo
echo "> Rele pois päältä sähkökatkon jälkeen"
cmnd "SetStartValue 1 0"
echo "> Uudelleenkäynnistys"
curl -fsS -m 10 "${AUTH[@]}" -X POST "http://$PLUG_IP/api/reboot"; echo
echo "Odota ~30 s, sitten: scripts/check-autoexec.sh"
