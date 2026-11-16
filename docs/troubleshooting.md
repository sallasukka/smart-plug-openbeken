# Troubleshooting – lessons learned

## Serial port won't open (Permission denied)
The user is not in the `dialout` group:
```bash
sudo usermod -aG dialout $USER   # permanent, requires logging in again
sudo chmod a+rw /dev/ttyUSB0     # temporary
```

## Not a single byte from the device
Almost always wiring or power, not the chip type:
1. TX/RX crossed? Also try them the other way round.
2. Does the module get 3.3 V? Measure directly at the module pins. The adapter's 3.3 V can
   collapse under load; then use a separate supply (grounds connected together).
3. Common GND.
4. Are the clips/solder joints making contact?

**Loopback test:** disconnect the wires from the device and connect the adapter's TX → RX.
The data you send should come back.

## Repeating garbage data (`00 00 07 22 00 04 80 01 …`)
The same sequence at every baud rate and far too fast → the data is not coming from the chip,
but from a floating/bad RX line or the adapter. Fix the wiring.

## Unclear module marking
"C82S" was actually **CB2S** (B and 8 are easy to confuse in the print).

## tuya-cloudcutter
Wireless flashing without wires works on some BK7231N devices if the stock firmware is old
enough. For this device we ended up using the cable.
https://github.com/tuya-cloudcutter/tuya-cloudcutter

## WiFi settings "did not save"
The device may only join the home network after a few minutes. Wait before trying again.

## Restart reason: HardwareWatchdog
Typical when the device is powered from a weak 3.3 V adapter supply. Does not recur on mains power.
