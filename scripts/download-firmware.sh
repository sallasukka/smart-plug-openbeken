#!/usr/bin/env bash
# Downloads OpenBeken firmware (QIO .bin for wired flashing, .rbl for OTA)
. "$(dirname "$0")/common.sh"
mkdir -p "$ROOT/fw" && cd "$ROOT/fw"
BASE="https://github.com/openshwprojects/OpenBK7231T_App/releases/download/$OBK_VERSION"
for f in "OpenBK7231N_QIO_$OBK_VERSION.bin" "OpenBK7231N_$OBK_VERSION.rbl"; do
  curl -fL -o "$f" "$BASE/$f"
done
sha256sum ./*
