# Käyttö ja ylläpito

## Langaton päivitys (OTA)
- Julkaisut: https://github.com/openshwprojects/OpenBK7231T_App/releases
- Valitse tiedosto **`OpenBK7231N_<versio>.rbl`** (N, ei T; .rbl, ei .bin).
- Selaimella: `http://<PLUG_IP>` → *OTA* → valitse tiedosto → käynnistä.
- Tai komentoriviltä: päivitä `OBK_VERSION` tiedostoon `.env`, sitten
  `scripts/download-firmware.sh && scripts/ota.sh`.

## WiFi-varaverkko (SSID2)
- Laite yrittää ensin SSID1:tä. Jos se ei onnistu muutaman yrityksen jälkeen,
  se siirtyy SSID2:een (n. 1–2 min).
- Laite ei vaihda verkkoa "paremman" perusteella; se pysyy SSID2:ssa niin kauan kuin
  yhteys toimii.
- Hotspotissa laitteella on eri IP-osoite. Katso se hotspotin laitelistasta.

## Uusi verkko / unohtuneet tunnukset
Katkaise ja kytke virta nopeasti **5 kertaa**, jolloin laite avaa taas oman tukiasemansa.

## Palautus alkuperäiseen Tuya-firmwareen
Johdolla, varmuuskopiosta:
```bash
./venv/bin/ltchiptool flash write -d /dev/ttyUSB0 backup/original_full_XXXX.bin
```

## Home Assistant
OpenBeken tukee MQTT:tä ja Home Assistantin automaattista löytämistä:
*Config* → *Configure MQTT*, sitten *Home Assistant Discovery*.

## HTTP-komennot
OpenBeken hyväksyy Tasmota-tyyliset komennot: `http://<PLUG_IP>/cm?cmnd=<komento>`,
esim. `POWER ON`, `POWER TOGGLE`, `status 0`.
