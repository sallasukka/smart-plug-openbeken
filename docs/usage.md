# Usage and maintenance

## Wireless update (OTA)
- Releases: https://github.com/openshwprojects/OpenBK7231T_App/releases
- Pick **`OpenBK7231N_<version>.rbl`** (N, not T; .rbl, not .bin).
- In a browser: `http://<PLUG_IP>` → *OTA* → choose the file → start.
- Or from the command line: update `OBK_VERSION` in `.env`, then
  `scripts/download-firmware.sh && scripts/ota.sh`.

## Backup WiFi (SSID2)
- The device tries SSID1 first. If that fails after a few attempts, it switches to SSID2
  (about 1–2 min).
- It does not switch to a "better" network; it stays on SSID2 as long as that connection works.
- On a hotspot the device gets a different IP address. Check the hotspot's list of connected devices.

## New network / forgotten credentials
Power-cycle the device quickly **5 times** and it opens its own access point again.

## Restoring the stock Tuya firmware
Over the cable, from the backup:
```bash
./venv/bin/ltchiptool flash write -d /dev/ttyUSB0 backup/original_full_XXXX.bin
```

## Home Assistant
OpenBeken supports MQTT and Home Assistant auto-discovery:
*Config* → *Configure MQTT*, then *Home Assistant Discovery*.

## HTTP commands
OpenBeken accepts Tasmota-style commands: `http://<PLUG_IP>/cm?cmnd=<command>`,
e.g. `POWER ON`, `POWER TOGGLE`, `status 0`.

## Can the device be bricked?
The risk of a permanent brick is small, and even the worst case can be recovered.

**Why:** the start of the flash holds the bootloader, which is also what wired flashing
talks to. OTA does not touch it:
1. The new `.rbl` is written to a separate download area while the old firmware keeps running.
2. On restart, the bootloader verifies the package checksum and only then copies it into place.
3. If the download is interrupted, the incomplete package is rejected and the device boots
   the old firmware.

| Situation | Result | Fix |
|---|---|---|
| Wrong file (T build, or `.bin` instead of `.rbl`) | Package rejected, or device won't boot | Reflash over the cable |
| Power loss while the bootloader is copying (a few seconds) | Rare; the package is usually still there | Over the cable if needed |
| Wrong pin/WiFi settings | Device not visible on the network, firmware fine | Power-cycle 5× → own access point |
| Wired flash of a wrong file at offset 0 (over the bootloader) | The only real permanent brick | SPI programmer (CH341) + BK7231GUIFlashTool |

**Avoid problems:**
- Only use `OpenBK7231N_<version>.rbl` from the official release and check its SHA-256.
- Update over a good WiFi connection; don't unplug the device until it has restarted (30–60 s).
- Keep the USB adapter, this repo and the stock flash backup.
