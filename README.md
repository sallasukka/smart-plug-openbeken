# Smart plug → OpenBeken

Freeing the Tuya smart plug **smart-PFW02-G** from the Tuya cloud: the stock firmware is
replaced with the open-source [OpenBeken](https://github.com/openshwprojects/OpenBK7231T_App)
firmware. The first install is done over a serial cable (UART); after that, updates are
wireless (OTA). The plug is used to control a coffee maker.

| | |
|---|---|
| Device | smart-PFW02-G (Tuya, EU socket) |
| WiFi module | Tuya **CB2S** |
| Chip | Beken **BK7231N**, 2 MB flash |
| Firmware | OpenBK7231N **1.18.321** (tested 2026-11-13) |
| Pins | P24 relay · P26 button · P7 WiFi LED (inverted) |

> ⚠️ **Danger to life:** never connect the plug to mains power while the case is open or
> the serial adapter is attached. During flashing the device is powered from 3.3 V.

## Quick start

```bash
cp .env.example .env              # set PLUG_IP and SERIAL_PORT
scripts/setup.sh                  # install tools into a venv
scripts/download-firmware.sh      # OpenBeken .bin + .rbl
scripts/backup.sh                 # 1. back up the stock firmware (wired)
scripts/flash.sh                  # 2. flash OpenBeken (wired)
PLUG_IP=192.168.4.1 scripts/configure-pins.sh   # 3. pins, via the device's own AP
```

Then set the WiFi credentials: join `OpenBK7231N_XXXXXXXX` → http://192.168.4.1 →
*Config* → *Configure WiFi*. Details: [docs/flashing.md](docs/flashing.md).

## Usage

```bash
scripts/status.sh                 # firmware, WiFi, uptime, relay
scripts/relay.sh on|off|toggle
scripts/ota.sh                    # wireless update with an .rbl file
scripts/deploy-autoexec.sh        # coffee maker automations to the device
```

Or use a browser at `http://<PLUG_IP>`. More: [docs/usage.md](docs/usage.md).

## Documentation

- [docs/flashing.md](docs/flashing.md) – wiring, backup, flashing, first setup
- [docs/usage.md](docs/usage.md) – OTA, bricking risk, backup WiFi, restoring, Home Assistant
- [docs/coffee-maker.md](docs/coffee-maker.md) – auto-off, morning timer, power-loss behaviour
- [docs/security.md](docs/security.md) – **security risks and checklist**
- [docs/troubleshooting.md](docs/troubleshooting.md) – what went wrong along the way, and why

## What is NOT in this repo

Firmware files and the device backup are in `.gitignore`. The stock flash dump contains
device-specific Tuya keys and WiFi credentials, so it must not be published.
OpenBeken is always downloaded straight from the project's releases.
