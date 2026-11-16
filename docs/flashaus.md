# Flashaus johdolla (UART)

## Tarvikkeet
- USB–sarja-adapteri **3,3 V** logiikalla (CH340, CP2102 tai PL2303)
- Hyppylankoja / juotoskolvi
- Tarvittaessa erillinen 3,3 V virtalähde: WiFi-moduuli ottaa käynnistyessään 200–300 mA,
  johon kaikkien adaptereiden 3,3 V -nasta ei riitä.

## Kytkennät (CB2S)

| Adapteri | CB2S |
|---|---|
| 3V3 | VCC |
| GND | GND |
| TX | **RX1** |
| RX | **TX1** |
| (GND, hetkellisesti) | CEN – reset |

TX ja RX menevät **ristiin**. BK7231N ei tarvitse GPIO0-maadoitusta kuten ESP:
työkalun odottaessa yhteyttä CEN kytketään hetkeksi maahan, jolloin siru käynnistyy
uudelleen ja jää bootloaderiin.

## 1. Varmuuskopio
```bash
scripts/backup.sh
```
Lukee koko 2 Mt flashin (n. 5–8 min). Talleta tiedosto turvaan, sillä vain sen avulla pääsee
takaisin alkuperäiseen Tuya-firmwareen.

## 2. Flashaus
```bash
scripts/flash.sh
```
Kirjoittaa `OpenBK7231N_QIO_<versio>.bin`-tiedoston ltchiptoolilla. Käytä **N**-versiota
(BK7231N), älä T-versiota.

## 3. Käyttöönotto
1. Irrota CEN, käynnistä laite uudelleen. Se avaa WiFi-tukiaseman `OpenBK7231N_XXXXXXXX`.
2. Liity siihen ja aja `PLUG_IP=192.168.4.1 scripts/configure-pins.sh`.
3. http://192.168.4.1 → *Config* → *Configure WiFi*: SSID1 = kotiverkko, SSID2 = varaverkko
   (esim. puhelimen hotspot). **Vain 2,4 GHz.**
4. Laite käynnistyy ja liittyy kotiverkkoon. Tämä voi kestää muutaman minuutin.
   Etsi IP reitittimestä (laitenimi `obkXXXXXXXX`) ja tee sille DHCP-varaus MAC-osoitteella.
5. Irrota johdot, kokoa kotelo, ja vasta sitten kytke seinään.
