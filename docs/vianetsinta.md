# Vianetsintä – opit matkan varrelta

## Sarjaportti ei aukea (Permission denied)
Käyttäjä ei ole `dialout`-ryhmässä:
```bash
sudo usermod -aG dialout $USER   # pysyvä, vaatii uudelleenkirjautumisen
sudo chmod a+rw /dev/ttyUSB0     # väliaikainen
```

## Laitteelta ei tule yhtään tavua
Lähes aina kytkentä tai virta, ei sirutyyppi:
1. TX/RX ristiin? Kokeile myös toisin päin.
2. Saako moduuli 3,3 V? Mittaa suoraan moduulin nastoista. Adapterin 3,3 V voi romahtaa
   kuormassa, jolloin tarvitaan erillinen virtalähde (GND:t yhteen).
3. Yhteinen GND.
4. Pitävätkö koukut/juotokset?

**Loopback-testi:** irrota johdot laitteesta ja yhdistä adapterin TX → RX.
Lähetetyn datan pitää palata.

## Toistuva roskadata (`00 00 07 22 00 04 80 01 …`)
Sama jakso kaikilla baudinopeuksilla ja aivan liian nopeasti → data ei tule sirusta,
vaan kelluvasta/huonosta RX-linjasta tai adapterista. Korjaa kytkennät.

## Moduulin merkintä epäselvä
"C82S" oli todellisuudessa **CB2S** (B ja 8 sekoittuvat painatuksessa).

## tuya-cloudcutter
Langaton flashaus ilman johtoja toimii joillakin BK7231N-laitteilla, jos alkuperäinen
firmware on tarpeeksi vanha. Tässä laitteessa päädyttiin johtoon.
https://github.com/tuya-cloudcutter/tuya-cloudcutter

## WiFi-asetukset "eivät tallentuneet"
Laite saattaa liittyä kotiverkkoon vasta muutaman minuutin päästä. Odota ennen kuin
yrität uudelleen.

## Restart reason: HardwareWatchdog
Tyypillistä, kun laite saa virtansa heikosta adapterin 3,3 V:sta. Seinävirralla ei toistu.
