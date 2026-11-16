# Coffee maker automations

Three features using OpenBeken's built-in scripting. The firmware stays official, so OTA
updates keep working normally.

| Feature | Default | Setting in `.env` |
|---|---|---|
| Auto-off | after 45 min on | `AUTO_OFF_MIN` (1–240) |
| Morning start | **disabled** | `MORNING_TIME=06:30`, `MORNING_DAYS=0x3E` |
| State after power loss | always off | (fixed, `SetStartValue 1 0`) |

## Setup
```bash
# edit .env: AUTO_OFF_MIN, and MORNING_TIME if wanted
DRY_RUN=1 scripts/deploy-autoexec.sh   # see what will be sent
scripts/deploy-autoexec.sh             # send it and restart
scripts/check-autoexec.sh              # check the clock and timers
```
The script stores `autoexec.bat` in the device's LittleFS storage (visible in the web UI's
*LittleFS* tab), so the settings survive restarts and OTA updates.

## How it works
- **Auto-off:** when the relay turns on (button, browser or timer), `AddChangeHandler`
  starts a one-shot timer (`addRepeatingEventUID … 1 10`) that turns the relay off. If the
  relay is turned off earlier, the timer is cancelled. Turning it on again restarts the countdown.
- **Morning:** `addClockEvent HH:MM <days> 1 setChannel 1 1` – requires the clock to be set
  via NTP (the device must be online). Auto-off also applies after a morning start.
- **Days** (`MORNING_DAYS`) are a bit mask: Sun 0x01, Mon 0x02, Tue 0x04, Wed 0x08, Thu 0x10,
  Fri 0x20, Sat 0x40. Mon–Fri = 0x3E, every day = 0x7F, Sat–Sun = 0x41.
- **Clock:** Finnish time (UTC+2) with daylight saving time from the last Sunday of March
  to the last Sunday of October. Change `time_setTZ` and `TIME_setDST` in
  `config/autoexec.bat.template` for other time zones.

## ⚠️ Safety
- **The morning start turns on the heating element unattended.** Make sure in the evening
  that there is water in the machine and the pot is in place. If you are not sure the coffee
  maker has its own overheat protection, don't use the timer.
- Always keep auto-off enabled.
- Check the plug's label for its maximum current/power (typically 10 A / 2300 W or
  16 A / 3680 W). A coffee maker usually draws 1000–1500 W.
- If the device cannot get the time (no network), the morning timer won't fire – auto-off
  still works, because it doesn't need the clock.

## Not yet tested
The commands and APIs were checked against OpenBeken's documentation and source code
(2026-11-16), but have not yet been run on this device. In particular, verify the DST rule
(`TIME_setDST`) with `scripts/check-autoexec.sh` and by comparing the time.
