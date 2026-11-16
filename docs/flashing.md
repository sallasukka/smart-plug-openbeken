# Flashing over a cable (UART)

## What you need
- USB–serial adapter with **3.3 V** logic (CH340, CP2102 or PL2303)
- Jumper wires / soldering iron
- If needed, a separate 3.3 V power supply: the WiFi module draws 200–300 mA at startup,
  which not every adapter's 3.3 V pin can deliver.

## Wiring (CB2S)

| Adapter | CB2S |
|---|---|
| 3V3 | VCC |
| GND | GND |
| TX | **RX1** |
| RX | **TX1** |
| (GND, momentarily) | CEN – reset |

TX and RX are **crossed**. Unlike an ESP, the BK7231N does not need GPIO0 grounded:
while the tool is waiting for a connection, briefly connect CEN to ground. The chip resets
and stays in the bootloader.

## 1. Backup
```bash
scripts/backup.sh
```
Reads the whole 2 MB flash (about 5–8 min). Keep the file safe: it is the only way back to
the stock Tuya firmware.

## 2. Flash
```bash
scripts/flash.sh
```
Writes `OpenBK7231N_QIO_<version>.bin` with ltchiptool. Use the **N** build (BK7231N),
not the T build.

## 3. First setup
1. Disconnect CEN and restart the device. It opens a WiFi access point `OpenBK7231N_XXXXXXXX`.
2. Join it and run `PLUG_IP=192.168.4.1 scripts/configure-pins.sh`.
3. http://192.168.4.1 → *Config* → *Configure WiFi*: SSID1 = home network, SSID2 = backup
   network (e.g. a phone hotspot). **2.4 GHz only.**
4. The device restarts and joins the home network. This can take a few minutes.
   Find its IP in the router (hostname `obkXXXXXXXX`) and add a DHCP reservation for its MAC address.
5. Remove the wires, close the case, and only then plug it into the wall.
