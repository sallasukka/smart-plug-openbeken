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

## Voiko laite brickata?
Pysyvän brickin riski on pieni, ja pahinkin tilanne on korjattavissa.

**Miksi:** flashin alussa on bootloader, jonka kautta laite flashataan johdolla.
OTA ei koske siihen:
1. Uusi `.rbl` kirjoitetaan erilliselle latausalueelle; vanha firmware pyörii samalla.
2. Uudelleenkäynnistyksessä bootloader tarkistaa paketin tarkistussummalla ja kopioi sen
   vasta sitten käyttöön.
3. Jos lataus katkeaa, vajaa paketti hylätään ja laite käynnistyy vanhalla firmwarella.

| Tilanne | Seuraus | Korjaus |
|---|---|---|
| Väärä tiedosto (T-versio tai `.bin` `.rbl`:n sijaan) | Paketti hylätään tai laite ei käynnisty | Johdolla uudelleen |
| Virtakatko bootloaderin kopioidessa (muutama sekunti) | Harvinainen; paketti yleensä vielä tallessa | Tarvittaessa johdolla |
| Väärät pinni-/WiFi-asetukset | Laite ei näy verkossa, firmware kunnossa | Virta 5× pois/päälle → oma tukiasema |
| Johdolla väärä tiedosto offsettiin 0 (bootloaderin päälle) | Ainoa todellinen pysyvä brick | SPI-ohjelmoija (CH341) + BK7231GUIFlashTool |

**Vältä ongelmat:**
- Käytä vain `OpenBK7231N_<versio>.rbl` virallisesta julkaisusta ja tarkista SHA-256.
- Päivitä hyvällä WiFi-yhteydellä; älä irrota laitetta ennen kuin se on käynnistynyt (30–60 s).
- Säilytä USB-adapteri, tämä repo ja alkuperäisen flashin varmuuskopio.
