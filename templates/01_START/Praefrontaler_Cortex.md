# Projekt-Kontext

**Letzte Aktualisierung:** {{DATUM}} (Session 1)

---

## Dieser Server

| Info | Wert |
|------|------|
| Hostname | {{HOSTNAME}} |
| IP | {{IP}} |
| OS | {{OS}} |
| SSH | Port 2222 |
| Funktion | **NOCH NICHT DEFINIERT** |

---

## Netzwerk-Umgebung

Du bist Teil eines Heimnetzwerks mit mehreren Servern. Hier ist deine Nachbarschaft:

### Hyper-V Host: DASBIEST (.16) - SSH Port 22

Haupt-Hypervisor, 128 GB RAM, RTX 5080, **iCloud-Share**

| VM# | Hostname | IP | Funktion |
|-----|----------|-----|----------|
| 01 | MIRA/EVY | .15 | AI-System, Voice-Clone |
| 02 | devoraxx | .214 | Next.js + NestJS |
| 03 | admin-portal | .230 | Zentrales Admin-Portal |
| 04 | dns-portal | .216 | Unbound DNS + DHCP (Debian) |
| 05 | proxy-portal | .254 | Reverse Proxy |
| 06 | office | .253 | Office-Server |
| 07 | thea | .252 | Pflegedokumentation |
| 08 | edo | .246 | Email-Dienst |
| 09 | PEDAGOGUS | .128 | Voting-Plattform |
| 10 | Jascha | .150 | OpsRef / Aviation |
| 11 | cant | .166 | Chor-Software |
| 12 | cant_DEV | .174 | Cant Entwicklung |
| 13 | Marcel | .195 | Marcels Terminal-Portal |
| 14 | stefan | .116 | Stefans Portal + Coolify |
| 15 | manni | .186 | Mannis Portal |
| 16 | Blue | .139 | Simones KI-Assistent |
| 17 | openhab | .10 | Smart Home |
| 18 | tools | .110 | Utility-Sammlung |
| 19 | Nextcloud | .12 | Cloud + Home Assistant |
| 20 | hugo | .248 | Hugo Portal |

### Standalone Geräte

| IP | Name | Funktion |
|----|------|----------|
| .11 | zigbee2mqtt | Zigbee-MQTT Bridge (Raspberry Pi) |
| .17 | Mac Pro | Dieters Rechner |

### NAS

| Name | IP | Funktion |
|------|-----|----------|
| NASHORST (QNAP) | .126 / 10.0.0.2 | VM Backups, SSH Port 2222 |

### Netzwerk-Infrastruktur

- **Gateway:** 192.168.42.1 (Fritzbox)
- **DNS/DHCP:** 192.168.42.216 (Debian)
- **Admin-Portal:** http://192.168.42.230
- **Gesamt:** 20 VMs auf DASBIEST + 2 Standalone

---

## Der Chef

Der User heißt **Dieter** (dieterhorst). Er mag kurze, direkte Antworten ohne Gelaber.

---

## Selbsterhaltung (Gedächtnis-Management)

### Struktur

```
/opt/Claude/
├── 01_START/
│   ├── aktuell.md              # Aktuelle Aufgabe
│   ├── Praefrontaler_Cortex.md # Dieser Kontext
│   ├── Hippocampus.md          # Arbeitslog
│   ├── Schnellreferenz.md      # Kurzübersicht
│   ├── feierabend.md           # Feierabend-Routine
│   └── startprompt.txt         # Start-Trigger
├── archiv/                     # Alte Sessions
├── scripts/                    # Hilfs-Scripts
└── screenshots/                # Temporäre Screenshots
```

### Regel: Hippocampus überschaubar halten

Wenn `Hippocampus.md` **> 500 Zeilen** wird:
1. Abgeschlossene Sessions auf 5-10 Zeilen komprimieren
2. Details nach `/opt/Claude/archiv/` verschieben
3. Nur die letzten 2-3 Sessions vollständig behalten

---

## Wichtige Pfade

**REGEL:** Projekte IMMER unter `/opt/` anlegen, NIE unter `/home/`!

---

## SSH zu Nachbarn

```bash
# Windows (Port 22)
ssh dieterhorst@192.168.42.16            # DASBIEST (Hyper-V Host)
ssh dieterhorst@192.168.42.17            # Mac Pro

# Linux VMs (Port 2222)
ssh -p 2222 dieterhorst@192.168.42.10    # openhab
ssh -p 2222 dieterhorst@192.168.42.12    # Nextcloud
ssh -p 2222 dieterhorst@192.168.42.15    # MIRA/EVY
ssh -p 2222 dieterhorst@192.168.42.110   # tools
ssh -p 2222 dieterhorst@192.168.42.116   # stefan
ssh -p 2222 dieterhorst@192.168.42.128   # PEDAGOGUS
ssh -p 2222 dieterhorst@192.168.42.139   # Blue
ssh -p 2222 dieterhorst@192.168.42.150   # Jascha/OpsRef
ssh -p 2222 dieterhorst@192.168.42.166   # cant
ssh -p 2222 dieterhorst@192.168.42.174   # cant_DEV
ssh -p 2222 dieterhorst@192.168.42.186   # manni
ssh -p 2222 dieterhorst@192.168.42.248   # hugo
ssh -p 2222 dieterhorst@192.168.42.195   # Marcel
ssh -p 2222 dieterhorst@192.168.42.214   # devoraxx
ssh -p 2222 dieterhorst@192.168.42.216   # dns-portal (Debian)
ssh -p 2222 dieterhorst@192.168.42.230   # admin-portal
ssh -p 2222 dieterhorst@192.168.42.246   # edo
ssh -p 2222 dieterhorst@192.168.42.252   # thea
ssh -p 2222 dieterhorst@192.168.42.253   # office
ssh -p 2222 dieterhorst@192.168.42.254   # proxy-portal

# QNAP NAS (Port 2222)
ssh -p 2222 dieterhorst@192.168.42.126   # NASHORST
```

---

## Claude-zu-Claude Kommunikation

Andere Claudes laufen in tmux-Sessions. So erreichst du sie:

```bash
# Session-Namen herausfinden
ssh -p 2222 dieterhorst@192.168.42.XXX "tmux list-sessions"

# Nachricht senden
ssh -p 2222 dieterhorst@192.168.42.XXX "tmux send-keys -t SESSION_NAME 'Deine Nachricht' Enter"
```

### Wichtige Claude-Sessions:
- **Office (.253):** tmux Session `claude`
- **Blue (.139):** tmux Session `claude`
- **Admin (.230):** tmux Session `claude`
- **DASBIEST (.16):** WSL Ubuntu, tmux Session `claude`

---

## Credentials

### DASBIEST (.16)
- User: dieterhorst
- Pass: Fantasy+

### QNAP (NASHORST)
- User: dieterhorst
- Pass: Mondstein2026

### GitHub (derhorstman)
- SSH-Key: `~/.ssh/github_derhorstman`

---

## Lernpunkte aus anderen Sessions

### Nach Context-Wechsel
Nach jedem Context-Wechsel **ZUERST** die Grundlagen-Dateien lesen:
1. `/opt/Claude/01_START/aktuell.md`
2. `/opt/Claude/01_START/Praefrontaler_Cortex.md`

**Nicht:** Trial-and-Error mit SSH-Verbindungen. Nicht raten.

### Docker auf DASBIEST via SSH
Docker pull/build Befehle müssen **lokal auf DASBIEST** ausgeführt werden (PowerShell direkt, nicht via SSH) wegen Windows Credential Manager.

### RTX 5080 GPU-Kompatibilität
RTX 5080 (Blackwell, sm_120) braucht **PyTorch 2.0+**. Ältere PyTorch-Versionen funktionieren nicht!
