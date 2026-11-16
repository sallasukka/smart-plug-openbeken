# Kahvinkeitin-automaatiot

Kolme toimintoa OpenBekenin omalla skriptikielellä. Firmware pysyy virallisena, joten
OTA-päivitykset toimivat normaalisti.

| Toiminto | Oletus | Asetus `.env`:ssä |
|---|---|---|
| Automaattinen sammutus | 45 min päällä olon jälkeen | `AUTO_OFF_MIN` (1–240) |
| Aamukäynnistys | **pois päältä** | `MORNING_TIME=06:30`, `MORNING_DAYS=0x3E` |
| Tila sähkökatkon jälkeen | aina pois | (kiinteä, `SetStartValue 1 0`) |

## Käyttöönotto
```bash
# muokkaa .env: AUTO_OFF_MIN, tarvittaessa MORNING_TIME
DRY_RUN=1 scripts/deploy-autoexec.sh   # näe mitä lähetetään
scripts/deploy-autoexec.sh             # lähetä ja käynnistä uudelleen
scripts/check-autoexec.sh              # tarkista kello ja ajastukset
```
Skripti tallentaa `autoexec.bat`-tiedoston laitteen LittleFS-muistiin (näkyy web-käyttöliittymässä
*LittleFS*-välilehdellä), joten asetukset säilyvät uudelleenkäynnistyksissä ja OTA-päivityksissä.

## Miten se toimii
- **Sammutus:** kun rele kytkeytyy päälle (napista, selaimesta tai ajastuksesta),
  `AddChangeHandler` käynnistää kertaluonteisen ajastimen (`addRepeatingEventUID … 1 10`), joka
  sammuttaa releen. Jos rele sammutetaan aiemmin, ajastin perutaan. Uudelleen päälle → laskenta alkaa alusta.
- **Aamu:** `addClockEvent HH:MM <päivät> 1 setChannel 1 1` – vaatii, että kello on haettu
  NTP:llä (laitteen pitää olla verkossa). Aamukäynnistyksen jälkeen myös automaattinen sammutus pätee.
- **Päivät** (`MORNING_DAYS`) ovat bittimaski: su 0x01, ma 0x02, ti 0x04, ke 0x08, to 0x10,
  pe 0x20, la 0x40. Ma–pe = 0x3E, joka päivä = 0x7F, la–su = 0x41.
- **Kello:** Suomen aika (UTC+2) ja kesäaika maaliskuun viimeisestä sunnuntaista lokakuun
  viimeiseen sunnuntaihin.

## ⚠️ Turvallisuus
- **Aamukäynnistys kytkee lämmityslevyn päälle ilman valvontaa.** Varmista illalla, että
  keittimessä on vettä ja kannu paikallaan. Jos et ole varma keittimen omasta
  ylikuumenemissuojasta, älä käytä ajastusta.
- Pidä automaattinen sammutus aina päällä.
- Tarkista pistorasian tarrasta suurin sallittu virta/teho (tyypillisesti 10 A / 2300 W tai
  16 A / 3680 W). Kahvinkeitin ottaa yleensä 1000–1500 W.
- Jos laite ei saa kellonaikaa (ei verkkoa), aamuajastus ei käynnisty – sammutus toimii silti,
  koska se ei tarvitse kelloa.

## Testaamatta
Komennot ja rajapinnat on tarkistettu OpenBekenin dokumentaatiosta ja lähdekoodista
(16.11.2026), mutta niitä ei ole vielä ajettu tällä laitteella. Erityisesti kesäaikasääntö
(`TIME_setDST`) kannattaa tarkistaa `scripts/check-autoexec.sh`-komennolla ja kellonajan
vertailulla.
