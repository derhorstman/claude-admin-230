# Projekt-Kontext

**Letzte Aktualisierung:** 2026-01-11 (Session 77 - Server-Liste aktualisiert)

---

## Aktuelles Projekt: Admin-Portal

**Dieser Server (192.168.42.230)** ist das zentrale Verwaltungssystem - mit eigenem Web-Portal!

### Admin-Portal (LÄUFT!)

| Info | Wert |
|------|------|
| URL | http://192.168.42.230 |
| API Docs | http://192.168.42.230/docs |
| VM-Management | http://192.168.42.230/vms |
| Login | superadmin / Biest2025!Portal |
| Projekt | /opt/admin-portal/ |
| Doku | /opt/admin-portal/docs/{IP}/HANDBUCH.md |

**Tech-Stack:** FastAPI + SvelteKit + PostgreSQL + Docker

**Features:**
- Dashboard mit Server-Status (VMs gruppiert unter Host)
- Maschinen-Detail mit Modul-Tabs (Health, Dienste, Docker, Webserver, Cronjobs, Logs)
- VM-Management (Hyper-V) - erstellen/löschen
- **VM-Backup** - Export/Liste/Löschen via `/backups`
- **Live-Terminal** - SSH im Browser mit xterm.js + Mobile-Support (Session 20/21)
- **Split-Terminal** - Mehrere Terminals gleichzeitig via `/terminals` + Snippets + Keep-Alive Button (Session 33/39)
- **Snippets** - Befehlsvorlagen mit Kategorien via `/snippets` (Session 33)
- **Promptmachine** - KI-gestützter Konzept- und Prompt-Generator (integriert in `/konzepte`) (Session 46)
- **Sessions** - Claude-Prozesse auf allen VMs überwachen (Session 24)
- Multi-Host Support (DASBIEST + kleinerHund)
- User-Verwaltung mit Rollen

```bash
cd /opt/admin-portal
sudo docker compose ps      # Status
sudo docker compose logs    # Logs
sudo docker compose up -d   # Starten
```

---

## Docker-Architektur Admin-Portal

### Container-Übersicht

| Container | Image | Port | Funktion |
|-----------|-------|------|----------|
| admin-frontend | admin-portal-frontend | 3000 | SvelteKit UI |
| admin-backend | admin-portal-backend | 8000 | FastAPI REST |
| admin-db | postgres:16-alpine | 5432 (intern) | PostgreSQL |
| admin-nginx | nginx:alpine | 80 | Reverse Proxy |

### WICHTIG: Nach Code-Änderungen Container neu bauen!

**Problem:** Docker-Container enthalten eine Kopie des Codes zum Build-Zeitpunkt. Änderungen am Quellcode sind erst nach Neu-Build sichtbar!

**Frontend neu bauen (nach Svelte-Änderungen):**
```bash
cd /opt/admin-portal
sudo docker compose build --no-cache frontend && sudo docker compose up -d frontend
```

**Backend neu bauen (nach Python-Änderungen):**
```bash
cd /opt/admin-portal
sudo docker compose build --no-cache backend && sudo docker compose up -d backend
```

**Alles neu bauen:**
```bash
cd /opt/admin-portal
sudo docker compose build --no-cache && sudo docker compose up -d
```

### Prüfen ob Änderungen im Container sind

**1. Container-Alter prüfen:**
```bash
sudo docker compose ps
# Spalte "CREATED" zeigt wann Container erstellt wurde
```

**2. Datei-Zeitstempel vergleichen:**
```bash
# Wann wurde die Datei geändert?
ls -la /opt/admin-portal/frontend/src/routes/konzepte/+page.svelte

# Wenn Datei NACH Container-Erstellung geändert → NEU BAUEN!
```

### Typische Fehlerquellen

| Symptom | Ursache | Lösung |
|---------|---------|--------|
| Änderungen nicht sichtbar | Container vor Code-Änderung gebaut | Container neu bauen |
| "Old version" trotz Code-Fix | Nur `up -d` ohne `build` | Mit `build --no-cache` neu bauen |
| Container startet nicht | Build-Fehler | `docker compose logs <service>` prüfen |

---

## Claude Code Wartung

### Version fixieren (WICHTIG!)

**Problem Session 59:** Claude Code hat sich automatisch auf buggy Version 2.0.76 aktualisiert.

**Stabile Version:** `2.0.65`

**Auto-Updates deaktiviert in:** `~/.claude.json` → `"autoUpdates": false`

**Version prüfen:**
```bash
claude --version
```

**Downgrade falls nötig:**
```bash
npm install -g @anthropic-ai/claude-code@2.0.65
```

**Nach Downgrade:** Session neu starten (Exit + `claude`)

### Bekannte Bugs

| Version | Problem | Status |
|---------|---------|--------|
| 2.0.76 | Schreibt ungewollte Texte ins Terminal | NICHT VERWENDEN |
| 2.0.65 | Stabil | EMPFOHLEN |

---

## Selbsterhaltung (Gedächtnis-Management)

### Regel: Hippocampus überschaubar halten

Wenn `Hippocampus.md` **> 500 Zeilen** wird:

1. **Komprimieren:** Abgeschlossene Sessions auf 5-10 Zeilen zusammenfassen
2. **Archivieren:** Details nach `/opt/Claude/archiv/` verschieben
3. **Behalten:** Nur die letzten 2-3 Sessions vollständig
4. **Bewahren:** Offene Punkte und Lessons Learned nie löschen

### Wann archivieren?

- Bei Session-Start prüfen: `wc -l /opt/Claude/01_START/Hippocampus.md`
- Wenn > 500 Zeilen → erst archivieren, dann arbeiten

---

## Infrastruktur-Übersicht

### Hyper-V Host: DASBIEST (.16) - SSH Port 22

Haupt-Hypervisor, 128 GB RAM, **iCloud-Share**

| VM# | Hostname | IP | OS | Funktion |
|-----|----------|-----|-----|----------|
| 01 | MIRA/EVY | .15 | Linux | AI-System |
| 02 | devoraxx | .214 | Linux | Next.js + NestJS |
| 03 | admin-portal | .230 | Linux | Zentrales Admin-Portal (ich) |
| 04 | dns-portal | .216 | FreeBSD | Unbound DNS + DHCP |
| 05 | proxy-portal | .254 | Linux | Reverse Proxy |
| 06 | office | .253 | Linux | Office-Server |
| 07 | thea | .252 | Linux | Pflegedokumentation |
| 08 | edo | .246 | Linux | Email-Dienst |
| 09 | PEDAGOGUS | .128 | Linux | Voting-Plattform |
| 10 | Jascha | .150 | Linux | OpsRef / Aviation |
| 11 | cant | .166 | Linux | Chor-Software |
| 12 | cant_DEV | .174 | Linux | Cant Entwicklung |
| 13 | Marcel | .195 | Linux | Marcels Terminal-Portal |
| 14 | stefan | .116 | Linux | Stefans Portal + Coolify |
| 15 | Projekt_15 | .186 | Linux | Neues Projekt |
| 16 | Blue | .139 | Linux | Simones KI-Assistent |
| 17 | openhab | .10 | Linux | Smart Home |
| 18 | Projekt_18 | .100 | Linux | Neues Projekt |
| 19 | Nextcloud | .12 | Linux | Cloud + Home Assistant |

### Standalone Geräte

| IP | Name | Funktion |
|----|------|----------|
| .11 | zigbee2mqtt | Zigbee-MQTT Bridge (Raspberry Pi) |
| .17 | Mac Pro | Dieters Rechner (nur noch für `open` Befehle) |

### Backup-System (NASHORST)

| Gerät | IP (LAN) | IP (Direkt) | Kapazität |
|-------|----------|-------------|-----------|
| QNAP TVS-h874T-i7-32G | .126 | 10.0.0.2 | 2x 10TB ZFS-Pools |

**Netzwerk:**
- 192.168.42.126 = 1 Gbps über Switch (für alle VMs)
- 10.0.0.2 = **2.5 Gbps Direktverbindung** (nur DASBIEST ↔ QNAP)

**Zugangsdaten:**
- SSH: `ssh -p 2222 dieterhorst@192.168.42.126` (Passwort: Mondstein2026)
- SMB (LAN): `//192.168.42.126/Public` → `/mnt/nashorst`
- SMB (Direkt): `//10.0.0.2/ZFS1_DATA` (für DASBIEST VM-Export)
- Credentials: `/root/.qnap-credentials`

**Backup-Scripts:**
1. `/opt/Claude/scripts/backup-vms-to-qnap.sh` - Projektdaten (19 VMs, täglich 3:00)
2. `C:\Scripts\vm_backup_qnap.ps1` auf DASBIEST - Hyper-V VM-Export (2.5 Gbps)
   - Scheduled Task: "VM Backup QNAP" täglich 3:00
   - Ziel: `//10.0.0.2/Public/Backups/VMs`

### Netzwerk-Infrastruktur

- **Gateway:** 192.168.42.1 (Fritzbox)
- **DNS/DHCP:** 192.168.42.216 (FreeBSD)
- **Admin-Portal:** http://192.168.42.230
- **Gesamt:** 19 VMs auf DASBIEST + 2 Standalone = 21 Geräte

### SSH-Zugriff (Key-Auth)

```bash
# Mac + Windows (Port 22)
ssh dieterhorst@192.168.42.17            # Mac Pro
ssh dieterhorst@192.168.42.16            # DASBIEST (Hyper-V Host)

# Linux/FreeBSD VMs (Port 2222)
ssh -p 2222 dieterhorst@192.168.42.10    # openhab (VM 17)
ssh -p 2222 dieterhorst@192.168.42.11    # zigbee2mqtt (Raspberry Pi)
ssh -p 2222 dieterhorst@192.168.42.12    # Nextcloud (VM 19)
ssh -p 2222 dieterhorst@192.168.42.15    # MIRA/EVY (VM 01)
ssh -p 2222 dieterhorst@192.168.42.100   # Projekt_18 (VM 18)
ssh -p 2222 dieterhorst@192.168.42.116   # stefan (VM 14)
ssh -p 2222 dieterhorst@192.168.42.128   # PEDAGOGUS (VM 09)
ssh -p 2222 dieterhorst@192.168.42.139   # Blue (VM 16)
ssh -p 2222 dieterhorst@192.168.42.150   # Jascha/OpsRef (VM 10)
ssh -p 2222 dieterhorst@192.168.42.166   # cant (VM 11)
ssh -p 2222 dieterhorst@192.168.42.174   # cant_DEV (VM 12)
ssh -p 2222 dieterhorst@192.168.42.186   # Projekt_15 (VM 15)
ssh -p 2222 dieterhorst@192.168.42.195   # Marcel (VM 13)
ssh -p 2222 dieterhorst@192.168.42.214   # devoraxx (VM 02)
ssh -p 2222 dieterhorst@192.168.42.216   # dns-portal (VM 04, FreeBSD)
ssh -p 2222 dieterhorst@192.168.42.230   # admin-portal (VM 03)
ssh -p 2222 dieterhorst@192.168.42.246   # edo (VM 08)
ssh -p 2222 dieterhorst@192.168.42.252   # thea (VM 07)
ssh -p 2222 dieterhorst@192.168.42.253   # office (VM 06)
ssh -p 2222 dieterhorst@192.168.42.254   # proxy-portal (VM 05)
```

---

## Module (verfügbar)

| Slug | Name | Für | OS |
|------|------|-----|-----|
| health | System-Health | alle | alle |
| services | Dienste | alle | alle |
| vm-management | VM-Verwaltung | host | hyperv |
| backup-config | Backup-Config | host | hyperv |
| cronjobs | Cronjobs | vm, standalone | linux |
| docker | Docker | vm, standalone | linux |
| webserver | Webserver | vm, standalone | linux |
| logs | Log-Viewer | alle | alle |

---

## Dienste-Übersicht

### SYSTEMHAUS-001 (192.168.42.15) - EVY/MIRA
- EVY Backend (Port 5000)
- MIRA Gateway (Port 8000)
- Voice API (Port 5070)
- Train API (Port 5071)
- Auth Service (Port 8002)
- Usage API (Port 5050)

### devoraxx (192.168.42.214)
- Next.js Frontend (Port 3000)
- NestJS API (Port 3001)
- PostgreSQL (Docker, Port 5432)
- Redis (Docker, Port 6379)

### Webserver (192.168.42.13)
- Apache2 + SSL + Proxy
- MariaDB
- Let's Encrypt (9 Domains)
- Roundcube Mail

### Admin-Server (192.168.42.230) - DIESER
- Admin-Portal (Port 80 → Docker)
- SMB Freigabe (Port 445)
- SSH (Port 2222)

### DNS-Server (192.168.42.216) - FreeBSD
- Unbound DNS (Port 53)
- ISC DHCP (Port 67)
- DNS/DHCP Web-Portal (Port 80)
- 153 Geräte, 68 Shelly-Namen aus OpenHAB
- **Fritzbox DHCP deaktiviert!**

### Reverse-Proxy (192.168.42.254) - NEU
- **Rolle:** Neuer zentraler Reverse Proxy
- **Aufgabe:** Domains vom alten Webserver übernehmen
- SMB Freigabe (`\\192.168.42.254\dieterhorst`)
- Claude Code installiert
- Eigene Selbsterhaltung unter `/opt/Claude/`

---

## Domains

| Domain | SSL | Backend |
|--------|-----|---------|
| mukupi.art | ✓ | .15 (EVY/MIRA) |
| systemhaus-horst.de | ✓ | .15 (MIRA) |
| app.devoraxx.de | ✓ | .214 (Devoraxx) |
| buendnis-leben.de | ✓ | Static |
| phil-pohlmeier.art | ✓ | Static |
| poimer.art | ✓ | Static |
| the-style-of-power.de | ✓ | Static |
| mail.systemhaus-horst.de | ✓ | Roundcube |
| edo.systemhaus-horst.de | ✓ | .246 (edo) |

---

## Offene Aufgaben

- [x] ~~**Zentrales Backup-System**~~ → QNAP TVS-h874T eingerichtet (Session 70)
- [x] ~~SSL/HTTPS für Admin-Portal~~ → via Proxy-Portal erledigt
- [ ] Alte Webserver ablösen (nur 962MB RAM!) → Reverse-Proxy übernimmt
- [x] ~~Admin-Portal Passwort ändern!~~ (Session 57)
- [ ] Ubuntu Server 24.04 Auto-Install ISO bauen
- [ ] Netzwerkadapter bei VM-Erstellung zum Switch verbinden (Backend-Fix)
- [x] ~~Thea (.252) deployed + Snippets~~ (Session 26)
- [x] ~~Session-API + Verlassen-Warnung~~ (Session 24)
- [x] ~~Neue VM .253 + Deploy-Template~~ (Session 22)
- [x] ~~Terminal Mobile-Support (iPad/Handy)~~ (Session 21)
- [x] ~~Live-Terminal + Snippets im Admin-Portal~~ (Session 20)
- [x] ~~Selbsterhaltung auf alle Maschinen verteilt~~ (Session 20)
- [x] ~~Reverse-Proxy VM vorbereitet~~ (Session 19)
- [x] ~~Funktionshandbücher für alle VMs~~ (Session 18)
- [x] ~~Selbsterhaltung repariert~~ (Session 18)
- [x] ~~DNS/DHCP Server auf FreeBSD~~ (Session 17)
- [x] ~~Shelly-Namen aus OpenHAB~~ (Session 17)
- [x] ~~VM-Backup Feature~~ (Session 14)
- [x] ~~FreeBSD 14.2 Auto-Install ISO~~ (Session 13)
- [x] ~~ISO-Auswahl im VM-Frontend~~ (Session 13)
- [x] ~~UI-Verbesserungen: Services, Logs, Settings, API-Docs~~ (Session 11)
- [x] ~~Multi-Host Support~~ (Session 8/9)
- [x] ~~Mobile-First Integration~~ (Session 10)
- [x] ~~Backend-Module implementieren~~ (Session 7)
- [x] ~~Dashboard Gruppierung~~ (Session 5/6)
- [x] ~~VM-Management übernehmen~~ (Session 4)

---

## Wichtige Pfade auf diesem Server

```
/opt/Claude/                           # Selbsterhaltung & Dokumentation
/opt/Claude/01_START/                  # Immer zuerst lesen
/opt/Claude/templates/                 # VM-Deploy-Schablonen
/opt/Claude/deploy-selbsterhaltung.sh  # Deploy-Script für neue VMs

/opt/admin-portal/              # Admin-Portal Projekt
/opt/admin-portal/backend/      # FastAPI
/opt/admin-portal/frontend/     # SvelteKit
/opt/admin-portal/docs/         # Portal-Dokumentation
```

---

## SMB-Zugang

- **Freigabe:** `\\192.168.42.230\dieterhorst`
- **Pfad:** `/` (Root-Zugriff)
- **User:** dieterhorst
- **Pass:** Fantasy+

---

## Workflow: Kollegen-Terminal fernsteuern

**Anwendung:** Wenn ein Kollege (andere VM) im Split-Terminal Hilfe braucht

### Schritte:

1. **Screenshot holen:**
   ```bash
   /opt/Claude/screenshot.sh
   ```
   Dann lesen: `/opt/Claude/screenshots/latest.png`

2. **Terminal-Session finden:**
   ```bash
   ssh -p 2222 dieterhorst@192.168.42.XXX "who && ps aux | grep tmux"
   ```
   → Zeigt die tmux-Session (z.B. `web-terminal-114`)

3. **In Terminal schreiben:**
   ```bash
   ssh -p 2222 dieterhorst@192.168.42.XXX "tmux send-keys -t SESSION_NAME 'Text hier' Enter"
   ```

### Helper-Scripts:

**Kontext lesen:**
```bash
/opt/Claude/scripts/kollege-kontext.sh 166
```
→ Zeigt aktuell.md vom Kollegen

**Ins Terminal schreiben:**
```bash
/opt/Claude/scripts/kollege-schreiben.sh 166 "Dein Text hier"
```
→ Findet automatisch die aktive tmux-Session

### Snippet-Trigger: "PROMPT_HILFE"

Wenn du diesen Text siehst:
```
# PROMPT_HILFE: Welcher Kollege braucht Hilfe?
```

**Sofort ausführen:**
1. Frage: "Welche IP? (.166 cant, .246 edo, .214 devoraxx, .252 thea, .253 office, .254 proxy, .15 mira, .150 opsref)"
2. Screenshot holen: `/opt/Claude/screenshot.sh`
3. Screenshot lesen: `/opt/Claude/screenshots/latest.png`
4. tmux-Session auf Ziel finden
5. Helfen beim Prompten oder direkt ins Terminal schreiben
