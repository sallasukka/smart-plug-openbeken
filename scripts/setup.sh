#!/usr/bin/env bash
# Installs the flashing tools (bk7231tools, ltchiptool) into a virtualenv
. "$(dirname "$0")/common.sh"
python3 -m venv "$VENV"
"$VENV/bin/pip" install -q --upgrade pip
"$VENV/bin/pip" install -q bk7231tools==2.1.2 ltchiptool==4.15.0 pyserial==3.5
echo "Done. For serial port access: sudo usermod -aG dialout \$USER (then log in again)"
