# Aktuelle Aufgabe

**Stand:** 2026-01-11 (Session 77 - Feierabend)

---

## JETZT

**Status:** Feierabend

---

### Session 77 Ergebnisse

- **Zwei neue VMs deployed (Projekt_15 + Projekt_18):**
  - .186 (Projekt_15) und .100 (Projekt_18)
  - Debian 13, Node.js 22, Claude Code 2.0.65
  - Statische IPs gesetzt
  - SMB-Freigaben eingerichtet
  - SSH-Keys kopiert (inkl. Dieters Key)
  - Claude tmux-Sessions gestartet

- **Deploy-Script verbessert (`/opt/Claude/deploy-selbsterhaltung.sh`):**
  - Schritt 9: SSH-Keys automatisch vom Referenz-Server (.253) kopieren
  - Schritt 10: Statische IP konfigurieren
  - Schritt 11: SMB-Freigabe einrichten
  - Jetzt 12 Schritte statt 9

- **Server-Liste aktualisiert:**
  - Praefrontaler_Cortex.md mit allen 19 VMs auf DASBIEST
  - Liste von Office (.253) übernommen

---

### Session 76 Ergebnisse

- **SMB-Freigabe auf .253 repariert:**
  - Samba-Passwort neu gesetzt
  - Blockierendes pre-session-backup.sh abgebrochen (gzip 99% CPU)

- **S-Button im Split-Terminal gefixt:**
  - pre-session-backup.sh entfernt (blockierte Systeme)
  - Startet jetzt nur noch Claude mit Selbsterhaltung

- **GitHub eingerichtet:**
  - Account: derhorstman
  - Token konfiguriert (gh auth)
  - Repository erstellt: https://github.com/derhorstman/claude-selbsterhaltung (privat)
  - Erster Push erfolgreich

- **feierabend.md aktualisiert:**
  - Git push zu GitHub hinzugefügt

---

### Session 75 Ergebnisse

- **Frontend Case-Sensitivity Bug behoben:**
  - "Neu" und "Import" Buttons bei DASBIEST fehlten
  - Fix: `host.os?.toLowerCase() === 'hyperv'`

- **ISO-Karten Kontrast verbessert:**
  - Text jetzt weiß/hellgrau statt dunkelgrau

- **Neue VM "Blue" (.139) eingerichtet:**
  - Persönlicher KI-Assistent für Dieters Ehefrau
  - Vollständig deployed (Node.js, Claude Code 2.0.65, tmux)
  - Im Portal eingetragen

- **Deploy-Script `/opt/Claude/deploy-selbsterhaltung.sh` verbessert:**
  - Claude Code 2.0.65 fixiert
  - Auto-Updates deaktiviert
  - pre-session-backup.sh + Credentials werden kopiert

- **OpenHAB (.10) pre-session-backup.sh nachgeliefert**

---

### Session 74 Ergebnisse

- **Backup-Pfad im Admin-Portal aktualisiert:**
  - Backups wurden auf neues SCSI-Laufwerk verschoben
  - Alter Pfad: `/share/ZFS2_DATA/Public/Backups/VMs`
  - Neuer Pfad: `/share/ZFS19_DATA/homes/dieterhorst/Backups/VMs`
  - NAS SSH-Passwort hinzugefügt (sshpass statt Key-Auth)
  - Backend neu gebaut und deployed
  - 14 VMs mit je 4 Backups werden wieder angezeigt

---

### Session 73 Ergebnisse

- **Selbsterhaltung Konsistenzprüfung durchgeführt:**
  - Mac Pro IP korrigiert (.144 → .17)
  - Claude Code Version vereinheitlicht (0.2.65 → 2.0.65)
  - Obsolete iCloud-Backup Referenzen entfernt
  - Obsolete Scripts gelöscht (backup-vms-to-icloud.sh, backup-vms-to-eds009.sh)
  - Leerer Ordner 02_DOCS gelöscht
  - Horst.md ins Archiv verschoben
  - QNAP "Lieferung ausstehend" Hinweis entfernt
  - SSL/HTTPS als erledigt markiert (via Proxy-Portal)

---

### Session 72 Ergebnisse

- **QNAP NAS (NASHORST) voll ins Admin-Portal integriert:**
  - Health-Check mit QTS-spezifischen Befehlen (CPU, RAM, ZFS-Pools)
  - Log-Viewer funktioniert (kein PowerShell-Fehler mehr)
  - Storage-Modul aktiviert

- **Backup-Seite auf NAS umgestellt:**
  - Liest jetzt von `/share/ZFS2_DATA/Public/Backups/VMs/` auf dem NAS
  - Zeigt alle 14 VMs mit 24 Backups
  - Löschen funktioniert direkt auf dem NAS
  - "Backup starten"-Bereich entfernt (nicht mehr nötig, läuft automatisch auf DASBIEST)

- **Datum-Format angepasst:**
  - NAS-Format: `2026-01-05_1908` → wird als "05.01.2026 um 19:08 Uhr" angezeigt

---

### Session 71 Ergebnisse

- **Terminal-Scroll Bug untersucht (Safari/iOS):**
  - Marcel konnte im Web-Terminal nicht hochscrollen
  - Fix versucht: Touch-Events + webkit-overflow-scrolling
  - Hat nicht geholfen - xterm.js + Safari = bekanntes Problem
  - Workaround für Marcel: Dateien in Teilen anzeigen lassen

- **Diskussion: API-Key vs. Portal:**
  - Marcel/Freund: "Mit API-Key kann ich genauso programmieren"
  - Erkenntnis: Das Portal ist für dich gebaut, nicht für Gelegenheitsnutzer
  - Selbsterhaltung, Multi-VM, Workflows - brauchen die nicht

---

### Session 70 Ergebnisse

- **QNAP NAS (NASHORST) eingerichtet:**
  - IP: 192.168.42.126
  - Hostname: NASHORST
  - SSH: Port 2222
  - SMB-Share: `//192.168.42.126/Public` → `/mnt/nashorst`
  - Speicher: 2x ~10TB ZFS-Pools (zpool1, zpool2)

- **Backup-Script angepasst:**
  - Neues Script: `/opt/Claude/scripts/backup-vms-to-qnap.sh`
  - Streamt direkt aufs NAS (kein lokaler Zwischenspeicher nötig)
  - Log-Dateien auf NAS: `/mnt/nashorst/Backups/`
  - Retention: 14 Tage

- **Automatischer Mount:**
  - fstab-Eintrag hinzugefügt
  - Credentials-Datei: `/root/.qnap-credentials`

- **Cronjob aktualisiert:**
  - `0 3 * * *` → `/opt/Claude/scripts/backup-vms-to-qnap.sh`
  - Ersetzt das alte iCloud-Backup

- **VM-Export Backup auf DASBIEST:**
  - Script: `C:\Scripts\vm_backup_qnap.ps1`
  - Scheduled Task: "VM Backup QNAP" täglich 3:00
  - Ziel: `//10.0.0.2/Public/Backups/VMs` (2.5 Gbps Direktverbindung)
  - **TODO:** Hyper-V Admin Rechte für dieterhorst

---

### Session 69 Ergebnisse

- **GPU-Passthrough ERNEUT GESCHEITERT:**
  - Windows 11 Enterprise installiert (80€ Key)
  - DDA-Zuweisung technisch erfolgreich (Dismount + Add-VMAssignableDevice)
  - VM-Start schlägt fehl: Fehler 0xC035001E
  - "Ein Hypervisorfeature ist für den Benutzer nicht verfügbar"
  - Rollback durchgeführt - Office VM (.253) läuft wieder ohne GPU
  - **Vermutung:** BIOS-Einstellungen (IOMMU, SR-IOV, Re-Size BAR)

- **Hardware-Info DASBIEST:**
  - Mainboard: ASUS Pro WS WRX90E-SAGE SE
  - CPU: AMD Threadripper PRO 9965WX (24-Core)
  - GPU: NVIDIA RTX 5080
  - BIOS: AMI 1203 (Juli 2025)

- **Mögliche BIOS-Fixes:**
  - IOMMU/AMD-Vi aktivieren
  - SR-IOV aktivieren
  - Re-Size BAR deaktivieren (kollidiert oft mit DDA)
  - Above 4G Decoding aktivieren

---

### Session 68 Ergebnisse

- **GPU-Passthrough GESCHEITERT:**
  - Windows 11 Pro unterstützt DDA (Discrete Device Assignment) NICHT
  - Fehler 0xC035001E auch nach Registry-Hacks und Host-Neustart
  - Rollback durchgeführt - GPU wieder am Host, VM läuft ohne GPU
  - **Fazit:** Bräuchte Windows Server oder Windows 11 Enterprise

- **Admin-Portal nach Neustart repariert:**
  - Problem: System-Nginx auf .254 blockierte Docker-Nginx (Port 80)
  - Fix: System-Nginx gestoppt/deaktiviert, Docker-Container neu gestartet
  - `https://admin.systemhaus-horst.de/` wieder erreichbar

---

### Session 67 - GPU-Passthrough RTX 5080 (ABGEBROCHEN)

**Versuch:** RTX 5080 von DASBIEST an VM 015_SYSTEMHAUS-006_VM_001 (Office, .253) durchreichen

**Ergebnis:** NICHT MÖGLICH mit Windows 11 Pro

**Alternativen (falls später gewünscht):**
- Windows Server 2016/2019/2022 oder Windows 11 Enterprise
- GPU-P (GPU Partitioning) - nur für Windows-Gast-VMs
- Anderer Hypervisor (Proxmox, ESXi)

---

### Session 66 Ergebnisse

- **Prompt-Ordner verteilt:**
  - `/opt/Claude/prompts/` von .254 an alle 12 VMs verteilt
  - Inhalt: `konsistenzpruefung.md`

- **Konsistenzprüfung für Admin-Portal durchgeführt:**
  - Ergebnis: 🟢 GUT (0 kritische Bugs, 8 Minor)
  - Report auf Mac Desktop: `konsistenz-report-admin-server.md`

- **Konsistenzprüfungs-Prompt v2 erstellt:**
  - Framework-Auto-Erkennung (FastAPI, NestJS, Express, Flask)
  - WebSocket-Endpoints, Schema-Tiefenanalyse, Auth-Matrix
  - Auf alle 12 VMs verteilt

- **Neue Snippet-Kategorie "Wartung & Analyse":**
  - Farbe: Orange, Icon: wrench
  - Erstes Snippet: "Konsistenzprüfung Frontend/Backend"

### Session 65 Ergebnisse

- **Admin Portal iOS App - Fixes:**
  - Konzepte: "Zur VM synchronisieren" Button in Detailansicht hinzugefügt
  - Snippets: Edit-Funktion verbessert mit besserer Fehlerbehandlung

### Session 64 Ergebnisse

- **Terminal WebView Input-Problem behoben:**
  - Problem: Doppeltes Eingabefeld (Web + iOS-Accessory)
  - Lösung: Native Flutter-Eingabefeld am unteren Rand
  - Web-Input per JavaScript versteckt
  - Toggle-Button für Eingabefeld in AppBar

### Session 63 Ergebnisse

- **Admin Portal iOS App erstellt:**
  - Projekt: `/opt/admin-portal-app/`
  - Screens: Login, Dashboard, Server-Detail, Sessions, Terminal, Snippets
  - API-Service für Backend-Kommunikation
  - Dark Theme (Material 3)
  - Zum Mac synchronisiert: `~/Developer/admin-portal-app/`

- **FLUTTER_WORKFLOW.md überarbeitet:**
  - Jetzt für beide Apps (Office + Admin Portal)
  - Gemeinsame Einstellungen oben
  - Problemlösungen dokumentiert

---

### Session 62 Ergebnisse (Fortsetzung)

- **SMB-Shares auf Mac konfiguriert:**
  - Alle 13 Shares mit Hostnamen statt IPs
  - Script: `~/mount-all-shares.sh`
  - Passwörter im Schlüsselbund
  - .246 umbenannt: `dieterhorst` → `edo`

- **Mac /etc/hosts aktualisiert:**
  - Alle 12 Server mit Namen eingetragen
  - Primärer Name = NetBIOS-Name

- **Samba auf 6 VMs nachinstalliert:**
  - .252 (thea), .128 (pedagogus), .150 (opsref)
  - .166 (cant), .174 (cant-dev), .216 (dns/FreeBSD)

- **FreeBSD Firewall geöffnet:**
  - SMB-Ports 139/445 in pf.conf

### Session 62 Ergebnisse (Teil 1)

- **Context-Warning Hook auf alle 12 VMs deployed:**
  - Script: `/opt/Claude/hooks/context-warning.sh`
  - Warnt bei 70% → Feierabend-Routine empfohlen
  - Warnt bei 80% → Wird eng
  - Warnt bei 90% → KRITISCH
  - PreCompact Hook bei 95%+ (Auto-Compact)

- **Git-Workflow für cant eingerichtet:**
  - .166 = Produktion (Stefan nutzt 24/7)
  - .174 = Entwicklung (Dev-Server)
  - SSH-Key .174 → .166 eingerichtet
  - Repo geclont

- **.166 Produktionsschutz:**
  - Praefrontaler_Cortex.md mit WARNUNG
  - Keine Code-Änderungen ohne Absprache

### Session 61 Ergebnisse

- **Server-Liste aktualisiert**
- **Feierabend-Prompts vereinheitlicht** (alle 12 VMs)
- **Pre-Session Backup implementiert**

### Session 60 Ergebnisse

- **Sync-Feature für Konzepte:**
  - Backend: `POST /api/concepts/{id}/sync-to-vm`
  - Frontend: Grüner Sync-Button im Detail-Modal

### Session 59 Ergebnisse

- **Bug: Frontend-Änderungen verschwunden:**
  - Ursache: Container vor letzter Code-Änderung gebaut
  - Fix: `sudo docker compose build --no-cache frontend && sudo docker compose up -d frontend`

- **Bug: Claude Code 2.0.76 statt 0.2.65:**
  - Ursache: `autoUpdates: true` in `~/.claude.json`
  - Fix: Downgrade + Auto-Updates deaktiviert

- **Selbsterhaltung erweitert:**
  - Docker-Architektur dokumentiert
  - Container-Rebuild Anleitung
  - Claude Code Wartung mit Versions-Info

---

### Session 58 Ergebnisse

- **Konzepte-Seite: Löschen + Neu hinzugefügt:**
  - Roter Löschen-Button (Mülleimer) im Detail-Modal
  - Grüner "Neu"-Button im Header
  - Modal für neues Konzept mit allen Feldern
  - Frontend neu gebaut und deployed

### Session 57 Ergebnisse

- **Z-Button für "Session Zwischenspeichern":**
  - Neuer türkiser Button im Terminal-Header
  - Zeigt `/opt/Claude/01_START/zwischenspeichern.md` an
  - Für Zwischenstände ohne Session zu beenden

- **Passwort geändert:**
  - Alt: admin123
  - Neu: Biest2025!Portal

- **Neuer Kollege .174 eingerichtet:**
  - IP: 192.168.42.174
  - Hostname: systemhaus
  - OS: Debian 13 (trixie)
  - Node.js: v22.21.0
  - Claude Code: 2.0.65
  - SSH Port: 2222
  - Portal ID: 116
  - Funktion: noch offen

---

### Session 56 Ergebnisse

- **KRITISCHER BUG GEFUNDEN:** Claude Code 2.0.76 schreibt ungewollte Texte ins Terminal
  - Problem: Sinnvolle Antworten erscheinen automatisch ohne User-Eingabe
  - Betroffen: Alle Linux-VMs mit Version 2.0.76
  - Nicht betroffen: .216 (FreeBSD) mit Version 2.0.65
  - **Fix:** Downgrade auf Claude Code 2.0.65
  - Status: .230 downgraded, User testet gerade

- **Autocomplete-Fix im Web-Terminal:**
  - `autocomplete="off"` zu xterm.js textarea hinzugefügt
  - Betrifft: `/terminals` und Terminal-Komponente
  - Frontend neu gebaut

- **Hooks entfernt:**
  - settings.json auf .230 geleert (Hooks waren nicht die Ursache)

**ERLEDIGT:**
- [x] Alle Linux-VMs auf 2.0.65 downgraded
- [x] Bug-Report an Anthropic via /bug gesendet
- [x] Akte BUG-2025-001 angelegt
- [x] Ticket-System für Office (.253) eingerichtet
- [x] Mail-Entwurf via AppleScript funktioniert

---

### Session 55 Ergebnisse

- **Remote-Terminal Workflow implementiert:**
  - Screenshot vom Mac holen + analysieren
  - Ins Terminal eines Kollegen schreiben via SSH + tmux
  - Helper-Scripts: `kollege-kontext.sh`, `kollege-schreiben.sh`

- **H-Button im Split-Terminal:**
  - Neuer lila Button für Prompt-Hilfe
  - Sendet PROMPT_HILFE Trigger
  - Frontend neu gebaut

- **Snippet "Prompt-Hilfe für Kollegen":**
  - Neue Kategorie "Claude Workflows"
  - Triggert den Prompt-Hilfe Workflow

- **Snippets-Seite Bugs gefixt:**
  - Doppelte Kategorie "Claude Workflows" gelöscht
  - Maschinen-Dropdown repariert (API trailing slash + name statt hostname)

- **Sessions-Seite gefixt:**
  - kill-btn CSS: border: none + cursor: pointer fehlten

- **Terminal-Komponente (Server-Detail):**
  - H-Button für Prompt-Hilfe hinzugefügt (war nur auf /terminals)

---

### Session 54 Ergebnisse

- **Deploy-Script geprüft:** tmux wird bereits installiert (Zeile 53)
- **Neuer Kollege "cant" auf .166 deployed:**
  - Hostname: systemhaus
  - OS: Debian 13 (trixie)
  - Node.js: v22.21.0
  - Claude Code: 2.0.76
  - Funktion: Chor-Software
  - Im Portal eingetragen

---

### Session 53 Ergebnisse

- **VM .253 (office) repariert:**
  - OAuth-Token war abgelaufen
  - Claude Code neu installiert (npm install -g)
  - Settings.json Syntax gefixt: `Bash(*)` → `Bash`
  - Credentials von .230 kopiert

---

### Session 52 Ergebnisse

- **Neuer "Projekte"-Tab im Konzepte-Frontend:**
  - Zeigt projekt.yaml von allen VMs
  - Score-Badges (A-F), Tech Stack, Level-Balken
  - Detail-Modal mit Vision, nächste Schritte
  - Backend-API: `/api/projekte`

- **projekt_template.yaml von edo verteilt:**
  - Template an alle 8 VMs kopiert
  - Claude auf allen VMs gestartet für Analyse

- **OpsRef (.150) projekt.yaml erstellt:**
  - Aviation Reference Material Platform
  - Level 7, FastAPI + SvelteKit 5 + PostgreSQL 16 + pgvector
  - Scores nach devoraxx-Analyse: Security C, Quality C, Gesamt C

- **VM-Dropdown fix:**
  - Zeigt jetzt function_name statt technischen Namen
  - function_name für openhab, nextcloud, webserver gesetzt

- **Promptmachine-Bug gefixt:**
  - War leer wegen falschem {:else} statt {:else if}

---

### Session 51 Ergebnisse

- **Backup-System für DASBIEST bestellt:**
  - **Gerät:** QNAP TVS-h874T-i7-32G
  - **Platten:** 4x 16TB Seagate IronWolf Pro (3 Jahre Rescue Service)
  - **Kapazität:** 64TB brutto → ~48TB nutzbar (RAID5)
  - **Anschluss:** Thunderbolt 4 (direkt an DASBIEST)
  - **Preis:** 3.900€ (Amazon Bundle)
  - **Features:** ZFS, Selbstheilung, Snapshots, i7 CPU, 32GB RAM
  - **TODO:** Nach Lieferung einrichten + ins Portal eintragen

---

### Session 50 Ergebnisse (PROBLEMATISCH)

- **VM-Entfernung Fehler gefixt:**
  - Problem: "The string did not match the expected pattern" in Safari
  - Ursache: Detail-Seite `/servers/[id]` nutzte alte API
  - Backend: ConceptSync-Löschung vor Machine-Löschung hinzugefügt

- **Funktionsname-Feld im Edit-Modal:**
  - Neues Feld "Funktion (wird in Liste angezeigt)"
  - Kann jetzt separat von Beschreibung bearbeitet werden

- **Neue VM .150 eingerichtet:**
  - /opt/Claude Struktur erstellt
  - SSH auf Port 2222
  - Im Portal eingetragen (ID: 109)

- **Office wiederhergestellt** (ID: 110)

**HINWEIS:** Session lief schlecht - viele Missverständnisse, Code-Änderungen ohne klare Freigabe. Programmierverbot am Ende.

### Session 49 Ergebnisse

- **Mac Pro (.17) eingefangen:**
  - SSH-Key installiert
  - 64 GB RAM, 6-Core Xeon, macOS 12.7.6
  - Screenshot-Workflow für Claude eingerichtet

- **GitHub CLI installiert** (Token fehlt noch)

---

## Admin-Portal

| Info | Wert |
|------|------|
| URL | http://192.168.42.230 |
| API Docs | http://192.168.42.230/docs |
| Login | superadmin / Biest2025!Portal |
| Projekt | /opt/admin-portal/ |

### Container

```bash
cd /opt/admin-portal
sudo docker compose ps      # Status
sudo docker compose logs    # Logs
sudo docker compose up -d   # Starten
sudo docker compose build --no-cache frontend && sudo docker compose up -d  # Frontend neu bauen
```

---

## TODO: Nächste Schritte

### Dringend
- [x] ~~**Passwort ändern!**~~ (erledigt Session 57)
- [x] ~~SSL/HTTPS einrichten~~ (erledigt via Proxy-Portal)

### Offen
- [ ] **Terminal-Scroll in Safari/macOS fixen** (xterm.js Problem)
- [x] ~~GitHub Token für Code-Backups holen~~ (erledigt Session 76)

---

## Arbeitskontext

**Claude läuft auf:** 192.168.42.230 (Admin-Server) - LOKAL

**SSH zu anderen Servern (19 VMs auf DASBIEST):**
- MIRA (.15): `ssh -p 2222 dieterhorst@192.168.42.15`
- devoraxx (.214): `ssh -p 2222 dieterhorst@192.168.42.214`
- dns-portal (.216): `ssh -p 2222 dieterhorst@192.168.42.216`
- proxy-portal (.254): `ssh -p 2222 dieterhorst@192.168.42.254`
- office (.253): `ssh -p 2222 dieterhorst@192.168.42.253`
- thea (.252): `ssh -p 2222 dieterhorst@192.168.42.252`
- edo (.246): `ssh -p 2222 dieterhorst@192.168.42.246`
- PEDAGOGUS (.128): `ssh -p 2222 dieterhorst@192.168.42.128`
- Jascha/OpsRef (.150): `ssh -p 2222 dieterhorst@192.168.42.150`
- cant (.166): `ssh -p 2222 dieterhorst@192.168.42.166`
- cant_DEV (.174): `ssh -p 2222 dieterhorst@192.168.42.174`
- Marcel (.195): `ssh -p 2222 dieterhorst@192.168.42.195`
- stefan (.116): `ssh -p 2222 dieterhorst@192.168.42.116`
- Projekt_15 (.186): `ssh -p 2222 dieterhorst@192.168.42.186`
- Blue (.139): `ssh -p 2222 dieterhorst@192.168.42.139`
- openhab (.10): `ssh -p 2222 dieterhorst@192.168.42.10`
- Projekt_18 (.100): `ssh -p 2222 dieterhorst@192.168.42.100`
- Nextcloud (.12): `ssh -p 2222 dieterhorst@192.168.42.12`
- Mac Pro (.17): `ssh dieterhorst@192.168.42.17`

---

## Flutter iOS Apps

**Workflow-Dokumentation:** `/opt/Claude/01_START/FLUTTER_WORKFLOW.md`

| App | Server | Quellcode | Mac-Pfad |
|-----|--------|-----------|----------|
| Office App | .253 | `/opt/office_app/` | `~/Developer/office_app/` |
| Admin Portal App | .230 | `/opt/admin-portal-app/` | `~/Developer/admin-portal-app/` |

**Gemeinsam:**
- iPhone Device ID: `00008150-0008399E0EBA401C`
- Team ID: `58LU7ZPY87`
- Build muss im **lokalen Mac Terminal** laufen (SSH funktioniert NICHT!)

---

## ⚠️ GPU-Passthrough: Erledigt (GESCHEITERT)

**Stand:** 2026-01-04 (Session 69)

**Ergebnis:** Auch mit Windows 11 Enterprise scheitert DDA mit Fehler 0xC035001E.

**Nächste Schritte falls gewünscht:**
1. BIOS-Einstellungen prüfen (IOMMU, SR-IOV, Re-Size BAR)
2. Oder: Proxmox/ESXi statt Hyper-V für besseren GPU-Support

