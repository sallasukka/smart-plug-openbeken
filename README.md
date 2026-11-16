# PFW02-G → OpenBeken

Tuya-älypistorasian **smart-PFW02-G** irrotus Tuyan pilvestä: alkuperäinen firmware
korvataan avoimen lähdekoodin [OpenBeken](https://github.com/openshwprojects/OpenBK7231T_App)-firmwarella.
Ensimmäinen asennus tehdään johdolla (UART), päivitykset sen jälkeen langattomasti (OTA).

| | |
|---|---|
| Laite | smart-PFW02-G (Tuya, EU-pistorasia) |
| WiFi-moduuli | Tuya **CB2S** |
| Siru | Beken **BK7231N**, 2 Mt flash |
| Firmware | OpenBK7231N **1.18.321** (testattu 13.11.2026) |
| Pinnit | P24 rele · P26 nappi · P7 WiFi-LED (käänteinen) |

> ⚠️ **Hengenvaara:** pistorasia ei saa koskaan olla kiinni verkkovirrassa, kun kotelo
> on auki tai sarja-adapteri on kytkettynä. Laite saa flashauksen ajan virtansa 3,3 V:sta.

## Pikaohje

```bash
cp .env.example .env              # aseta PLUG_IP ja SERIAL_PORT
scripts/setup.sh                  # työkalut venv-ympäristöön
scripts/download-firmware.sh      # OpenBeken .bin + .rbl
scripts/backup.sh                 # 1. varmuuskopio alkuperäisestä (johdolla)
scripts/flash.sh                  # 2. OpenBeken johdolla
PLUG_IP=192.168.4.1 scripts/configure-pins.sh   # 3. pinnit laitteen omassa AP:ssa
```

Sen jälkeen WiFi-tunnukset: liity verkkoon `OpenBK7231N_XXXXXXXX` → http://192.168.4.1 →
*Config* → *Configure WiFi*. Tarkemmin: [docs/flashaus.md](docs/flashaus.md).

## Käyttö

```bash
scripts/status.sh                 # firmware, WiFi, uptime, rele
scripts/relay.sh on|off|toggle
scripts/ota.sh                    # langaton päivitys .rbl-tiedostolla
scripts/deploy-autoexec.sh        # kahvinkeitinautomaatiot laitteelle
```

Tai selaimella `http://<PLUG_IP>`. Lisää: [docs/kaytto.md](docs/kaytto.md).

## Dokumentaatio

- [docs/flashaus.md](docs/flashaus.md) – kytkennät, varmuuskopio, flashaus, käyttöönotto
- [docs/kaytto.md](docs/kaytto.md) – OTA, brickaantumisriski, WiFi-varaverkko, palautus, Home Assistant
- [docs/kahvinkeitin.md](docs/kahvinkeitin.md) – automaattinen sammutus, aamuajastus, sähkökatko
- [docs/tietoturva.md](docs/tietoturva.md) – **tietoturvariskit ja tarkistuslista**
- [docs/vianetsinta.md](docs/vianetsinta.md) – mitä matkan varrella meni pieleen ja miksi

## Mitä repossa EI ole

Firmware-tiedostot ja laitteen varmuuskopio ovat `.gitignore`ssa. Alkuperäisen flashin
dumpissa on laitekohtaiset Tuya-avaimet ja WiFi-tunnukset, joten sitä ei pidä julkaista.
OpenBeken ladataan aina suoraan projektin julkaisuista.
