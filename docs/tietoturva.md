# Tietoturva ja tulevat riskit

Koottu 16.11.2026 julkisista lähteistä (OpenBeken-yhteisö, Elektroda-foorumi).
OpenBekenistä ei löytynyt julkaistuja CVE-haavoittuvuuksia, mutta suunnitteluun liittyviä
riskejä on. Tärkeimmät ensin.

## 1. Web-käyttöliittymä on oletuksena ilman salasanaa 🔴
Kuka tahansa samassa verkossa voi ohjata relettä, muuttaa asetuksia ja **ladata laitteelle
minkä tahansa firmwaren OTA:n kautta**. En löytänyt tietoa, että OpenBeken tarkistaisi
firmwaren kryptografisen allekirjoituksen; tarkistussumma suojaa vain vioittumiselta.

**Toimenpide:** *Config* → *Configure WiFi & Web* → *Web Authentication* (versiosta 1.17.342
alkaen, meillä 1.18.321). Käyttäjä on `admin`, salasana omasi.
- HTTP Basic -tunnus kulkee salaamattomana (ei HTTPS:ää), joten se suojaa lähinnä satunnaiselta
  käytöltä samassa verkossa, ei salakuuntelijalta.
- Kirjaa salasana talteen: unohtunut salasana voi vaatia uudelleenflashauksen johdolla.
- Skriptit (`status.sh` ym.) tarvitsevat tunnuksen, kun tämä on päällä.

## 2. Safe mode avaa salasanattoman WiFi-tukiaseman 🟠
Viisi nopeaa virtakatkoa (tai viisi epäonnistunutta käynnistystä, esim. sähkökatkojen
sattuessa) avaa tukiaseman `OpenBK7231N_XXXXXXXX` **ilman salasanaa**. Lähellä oleva voi
liittyä siihen ja muuttaa asetuksia. Asetukset eivät nollaudu, mutta niitä voi muokata.
Suojattua AP-tilaa on yhteisön mukaan kehitteillä. Web Authentication pysyy päällä myös
safe modessa, joten kohta 1 pienentää tätäkin riskiä.

## 3. Laite kotiverkossa 🟠
Halpa IoT-laite samassa verkossa kuin tietokoneet ja puhelimet on turhan lähellä kaikkea.
- Jos reititin tukee, siirrä pistorasia **vieras- tai IoT-verkkoon**.
- **Älä avaa porttiohjauksia** laitteeseen internetistä. Etäkäyttö VPN:n tai Home Assistantin kautta.

## 4. MQTT ilman salausta 🟡
Jos otat Home Assistant/MQTT:n käyttöön, tunnukset ja viestit kulkevat yleensä selväkielisinä.
TLS-tuesta ei löytynyt varmaa tietoa (yhteisöraportissa TLS-portti oli käytössä mutta
liikenne salaamatonta). Käytä MQTT:tä vain omassa lähiverkossa ja laitekohtaista tunnusta.

## 5. Firmware-päivitysten alkuperä 🟡
- Lataa vain osoitteesta `github.com/openshwprojects/OpenBK7231T_App/releases`.
- Tarkista SHA-256 GitHubin ilmoittamaa tiivistettä vasten ennen OTA:ta. Huijaussivustoja
  ("openbeken ota flash" -tyyppisiä) löytyy hakukoneista.
- Seuraa julkaisuja (GitHubissa *Watch → Releases*) tietoturvakorjausten varalta.

## 6. Arkaluonteiset tiedostot 🟡
- **Alkuperäisen flashin varmuuskopio** sisältää laitekohtaiset Tuya-avaimet ja aiemmat
  WiFi-tunnukset. Älä julkaise sitä (on `.gitignore`ssa), mutta säilytä se turvassa.
- `.env` sisältää laitteen IP:n; ei kuulu gittiin.
- Poista laite Tuya/Smart Life -sovelluksesta ja Tuya-tililtä, jos se on vielä siellä.

## 7. Fyysinen turvallisuus ⚠️
- Kotelon avaaminen poistaa sähköturvallisuushyväksynnän (CE) merkityksen; varmista, että
  kotelo on koottu täsmälleen alkuperäiseen kuntoon eikä sisälle jäänyt johtoja tai tinaa.
- Älä koskaan kytke sarja-adapteria, kun laite on seinässä.

## Tarkistuslista
- [ ] Web Authentication päälle, salasana talteen
- [ ] Laite vieras-/IoT-verkkoon, ei porttiohjauksia
- [ ] DHCP-varaus MAC-osoitteelle
- [ ] Laite poistettu Tuya-tililtä
- [ ] Varmuuskopio talletettu turvaan (ei pilveen salaamattomana)
- [ ] GitHub *Watch → Releases* OpenBekenille

## Lähteet
- [Elektroda: OpenBeken Web Authentication](https://www.elektroda.com/rtvforum/topic4021160.html)
- [Elektroda: safe mode ja avoin AP](https://www.elektroda.com/rtvforum/topic4077513.html)
- [Elektroda: safe mode -keskustelu](https://www.elektroda.com/rtvforum/topic4078092.html)
- [Elektroda: MQTT TLS OpenBekenissä](https://www.elektroda.com/rtvforum/topic4158793.html)
- [Elektroda: BK7231 bootloaderin palautus](https://www.elektroda.com/rtvforum/topic4056377.html)
- [Elektroda: BK7231N (CB3S) palautus](https://www.elektroda.com/rtvforum/topic4085447.html)
- [Elektroda: SPI-palautus CH341:llä (BK7231GUIFlashTool)](https://www.elektroda.com/rtvforum/topic4147664.html)
