#!/usr/bin/env bash
# Checks the clock, timers and relay state
. "$(dirname "$0")/common.sh"
echo "== Clock / NTP";      cmnd "ntp_info"
echo "== Clock events";       cmnd "listClockEvents"
echo "== Status";             "$(dirname "$0")/status.sh"
echo "(More detailed output is in the web UI's Logs tab.)"
