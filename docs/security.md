# Security and future risks

Compiled on 2026-11-16 from public sources (OpenBeken community, Elektroda forum).
No published CVEs were found for OpenBeken, but there are design-related risks.
Most important first.

## 1. The web UI has no password by default 🔴
Anyone on the same network can control the relay, change settings and **upload any firmware
via OTA**. I found no indication that OpenBeken verifies a cryptographic signature on
firmware; the checksum only protects against corruption.

**Action:** *Config* → *Configure WiFi & Web* → *Web Authentication* (available since
1.17.342; we run 1.18.321). The user is `admin`, the password is your choice.
- HTTP Basic credentials travel unencrypted (no HTTPS), so this mainly stops casual use on the
  same network, not an eavesdropper.
- Write the password down: a forgotten password may require reflashing over the cable.
- The scripts (`status.sh` etc.) need the password (`PLUG_PASSWORD` in `.env`) once this is on.

## 2. Safe mode opens a password-less WiFi access point 🟠
Five quick power cycles (or five failed boots, e.g. during power outages) open the access
point `OpenBK7231N_XXXXXXXX` **without a password**. Someone nearby can join it and change
settings. Settings are not wiped, but they can be edited. According to the community, a
secured AP mode is being developed. Web Authentication stays on in safe mode too, so item 1
reduces this risk as well.

## 3. The device on the home network 🟠
A cheap IoT device on the same network as your computers and phones is too close to everything.
- If your router supports it, move the plug to a **guest or IoT network**.
- **Never forward ports** to the device from the internet. Use a VPN or Home Assistant for remote access.

## 4. MQTT without encryption 🟡
If you enable Home Assistant/MQTT, credentials and messages usually travel in plain text.
No reliable information on TLS support was found (in a community report the TLS port was in
use but the traffic was unencrypted). Use MQTT only on your local network, with a
device-specific account.

## 5. Origin of firmware updates 🟡
- Only download from `github.com/openshwprojects/OpenBK7231T_App/releases`.
- Check the SHA-256 against the hash GitHub shows before OTA. Scam sites (of the
  "openbeken ota flash" kind) show up in search engines.
- Follow the releases (on GitHub: *Watch → Releases*) for security fixes.

## 6. Sensitive files 🟡
- **The stock flash backup** contains device-specific Tuya keys and previous WiFi
  credentials. Don't publish it (it is in `.gitignore`), but keep it safe.
- `.env` contains the device IP; it does not belong in git.
- Remove the device from the Tuya/Smart Life app and your Tuya account if it is still there.

## 7. Physical safety ⚠️
- Opening the case voids the electrical safety approval (CE); make sure the case is put back
  exactly as it was and that no wires or solder are left inside.
- Never connect the serial adapter while the device is plugged into the wall.

## Checklist
- [ ] Web Authentication on, password written down
- [ ] Device on a guest/IoT network, no port forwarding
- [ ] DHCP reservation for its MAC address
- [ ] Device removed from the Tuya account
- [ ] Backup stored safely (not unencrypted in the cloud)
- [ ] GitHub *Watch → Releases* for OpenBeken

## Sources
- [Elektroda: OpenBeken Web Authentication](https://www.elektroda.com/rtvforum/topic4021160.html)
- [Elektroda: safe mode and the open AP](https://www.elektroda.com/rtvforum/topic4077513.html)
- [Elektroda: safe mode discussion](https://www.elektroda.com/rtvforum/topic4078092.html)
- [Elektroda: MQTT TLS in OpenBeken](https://www.elektroda.com/rtvforum/topic4158793.html)
- [Elektroda: BK7231 bootloader recovery](https://www.elektroda.com/rtvforum/topic4056377.html)
- [Elektroda: BK7231N (CB3S) recovery](https://www.elektroda.com/rtvforum/topic4085447.html)
- [Elektroda: SPI recovery with CH341 (BK7231GUIFlashTool)](https://www.elektroda.com/rtvforum/topic4147664.html)
