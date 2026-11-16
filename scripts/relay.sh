#!/usr/bin/env bash
# Usage: scripts/relay.sh on|off|toggle
. "$(dirname "$0")/common.sh"
case "${1:-}" in on) cmnd "POWER ON";; off) cmnd "POWER OFF";; toggle) cmnd "POWER TOGGLE";;
  *) echo "Usage: $0 on|off|toggle" >&2; exit 1;; esac
