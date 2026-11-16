#!/usr/bin/env bash
# Generates config/autoexec.bat from .env settings, sends it to the device,
# sets the relay state after power loss and restarts the device.
#
# .env:
#   AUTO_OFF_MIN=45          turn off after n minutes (required, 1–240)
#   MORNING_TIME=06:30       morning start, empty = disabled
#   MORNING_DAYS=0x3E        0x3E = Mon–Fri, 0x7F = every day (0x01 Sun, 0x02 Mon ... 0x40 Sat)
#   NTP_SERVER=              NTP server IP address, empty = OpenBeken default
#   DRY_RUN=1                only generate the file, do not send
. "$(dirname "$0")/common.sh"
AUTO_OFF_MIN="${AUTO_OFF_MIN:-45}"
MORNING_TIME="${MORNING_TIME:-}"
MORNING_DAYS="${MORNING_DAYS:-0x3E}"
NTP_SERVER="${NTP_SERVER:-}"
if [ -n "$NTP_SERVER" ]; then NTP_LINE="ntp_setServer $NTP_SERVER"; else NTP_LINE="// NTP server: OpenBeken default"; fi

[[ "$AUTO_OFF_MIN" =~ ^[0-9]+$ ]] && (( AUTO_OFF_MIN >= 1 && AUTO_OFF_MIN <= 240 )) \
  || { echo "AUTO_OFF_MIN must be 1–240" >&2; exit 1; }
if [ -n "$MORNING_TIME" ]; then
  [[ "$MORNING_TIME" =~ ^([01][0-9]|2[0-3]):[0-5][0-9]$ ]] || { echo "MORNING_TIME must be HH:MM" >&2; exit 1; }
  [[ "$MORNING_DAYS" =~ ^0x[0-9A-Fa-f]{1,2}$ ]] || { echo "MORNING_DAYS must look like 0x3E" >&2; exit 1; }
  MORNING_LINE="addClockEvent $MORNING_TIME $MORNING_DAYS 1 setChannel 1 1"
else
  MORNING_LINE="// disabled (set MORNING_TIME in .env)"
fi

OUT="$ROOT/config/autoexec.bat"
sed -e "s|@AUTO_OFF_MIN@|$AUTO_OFF_MIN|g" -e "s|@AUTO_OFF_SEC@|$((AUTO_OFF_MIN*60))|g" \
    -e "s|@NTP_LINE@|$NTP_LINE|g" -e "s|@MORNING_LINE@|$MORNING_LINE|g" \
    "$ROOT/config/autoexec.bat.template" > "$OUT"
echo "Generated $OUT:"; grep -vE '^\s*(//|$)' "$OUT" | sed 's/^/  /'
[ "${DRY_RUN:-0}" = 1 ] && exit 0

need_ip
echo "> Sending autoexec.bat"
curl -fsS -m 20 "${AUTH[@]}" --data-binary @"$OUT" "http://$PLUG_IP/api/lfs/autoexec.bat"; echo
echo "> Relay off after power loss"
cmnd "SetStartValue 1 0"
echo "> Restarting"
curl -fsS -m 10 "${AUTH[@]}" -X POST "http://$PLUG_IP/api/reboot"; echo
echo "Wait ~30 s, then: scripts/check-autoexec.sh"
