#!/usr/bin/env bash
# Asentaa flashaustyökalut (bk7231tools, ltchiptool) virtuaaliympäristöön
. "$(dirname "$0")/common.sh"
python3 -m venv "$VENV"
"$VENV/bin/pip" install -q --upgrade pip
"$VENV/bin/pip" install -q bk7231tools==2.1.2 ltchiptool==4.15.0 pyserial==3.5
echo "Valmis. Sarjaporttia varten: sudo usermod -aG dialout \$USER (ja kirjaudu uudelleen)"
