# Arbeitslog

Chronologische Dokumentation der Entwicklungsarbeit.

---

## WICHTIG: Nach jeder Session

**Am Ende jeder Session Praefrontaler_Cortex.md aktualisieren!**

Pfad: `/opt/Claude/01_START/Praefrontaler_Cortex.md`

Zu aktualisieren:
1. **Letzte Aktualisierung** - Session-Nummer hochzählen
2. **Offene Aufgaben** - Erledigte abhaken, neue hinzufügen
3. **Infrastruktur** - Bei Änderungen aktualisieren

---

## Archivierte Sessions

| Sessions | Zeitraum | Archiv |
|----------|----------|--------|
| 1-10 | vor 2025-12-10 | (nicht archiviert) |
| 11-21 | 2025-12-10 bis 2025-12-14 | `/opt/Claude/archiv/sessions_11-21.md` |
| 22-30 | 2025-12-14 bis 2025-12-18 | `/opt/Claude/archiv/sessions_22-30.md` |
| 53-55 | 2025-12-27 bis 2025-12-28 | `/opt/Claude/archiv/sessions_53-55.md` |

### Zusammenfassung Sessions 53-55

- **Session 53:** OAuth-Token auf .253 abgelaufen, Credentials kopiert
- **Session 54:** Neuer Kollege "cant" auf .166 deployed (Chor-Software)
- **Session 55:** H-Button für Prompt-Hilfe, Helper-Scripts, Snippets-Bugfixes

### Zusammenfassung Sessions 22-30

- **Session 22:** Deploy-Template für neue VMs + VM .253 eingerichtet
- **Session 23:** Mac TODO-Ordner eingebunden + Backup-Konflikt gelöst
- **Session 24:** Session-API + Verlassen-Warnung
- **Session 25:** tmux-Session-Test + Close-Button für Claude-Prozesse
- **Session 26:** Neue VM Thea (.252) + Deploy-Script verbessert
- **Session 27:** Funktionsname-Feld für Server
- **Session 28:** DELETE-Bug + WebSocket Heartbeat
- **Session 29:** Raspberry Pi als Standalone-Gerät
- **Session 30:** SSH-Key auf Raspberry Pi + Terminal funktioniert

---

## Session 75 - 2026-01-09

### Ziel
Frontend-Bugs fixen + neue VM "Blue" einrichten

### Erledigt

1. **Case-Sensitivity Bug im Frontend behoben**
   - Problem: "Neu" und "Import" Buttons bei Hyper-V Hosts fehlten
   - Ursache: DB speichert `HYPERV` (uppercase), Code prüfte auf `hyperv` (lowercase)
   - Fix: `host.os?.toLowerCase() === 'hyperv'`

2. **ISO-Karten Kontrast verbessert**
   - ISO-Namen jetzt weiß (#fff) statt dunkelgrau
   - Größenangaben hellgrau (#aaa)

3. **Neue VM "Blue" (.139) eingerichtet**
   - Persönlicher KI-Assistent für Dieters Ehefrau
   - SSH-Key installiert, Port 2222
   - Node.js 22.21.0, Claude Code 2.0.65
   - Selbsterhaltung deployed, tmux installiert
   - Im Portal eingetragen

4. **Deploy-Script verbessert**
   - Claude Code 2.0.65 statt latest
   - Auto-Updates deaktivieren
   - Alle Verzeichnisse (scripts, hooks, prompts)
   - pre-session-backup.sh kopieren
   - Credentials kopieren

5. **OpenHAB (.10) pre-session-backup.sh nachgeliefert**

### Geänderte Dateien
- `/opt/admin-portal/frontend/src/routes/servers/+page.svelte` (Case-Fix + Kontrast)
- `/opt/Claude/deploy-selbsterhaltung.sh` (erweitert)

---

## Session 74 - 2026-01-09

### Ziel
Backup-Seite im Admin-Portal reparieren (Pfad geändert)

### Erledigt

1. **Problem diagnostiziert**
   - Backups wurden auf neues SCSI-Laufwerk (ZFS19_DATA) verschoben
   - Alter Pfad funktionierte nicht mehr

2. **NAS-Backup-Pfad aktualisiert**
   - Alt: `/share/ZFS2_DATA/Public/Backups/VMs`
   - Neu: `/share/ZFS19_DATA/homes/dieterhorst/Backups/VMs`
   - Struktur blieb gleich (VM/daily/YYYY-MM-DD_HHMM)

3. **SSH-Auth auf sshpass umgestellt**
   - SSH-Key funktionierte nicht auf NAS
   - NAS_SSH_PASS Variable hinzugefügt
   - nas_ssh_command() nutzt jetzt sshpass

4. **Backend neu deployed**
   - `docker compose build --no-cache backend`
   - 14 VMs mit 56 Backups werden angezeigt

### Geänderte Dateien
- `/opt/admin-portal/backend/app/api/vmbackup.py`
  - NAS_SSH_PASS = "Mondstein2026"
  - NAS_BACKUP_PATH geändert
  - nas_ssh_command() mit sshpass

---

## Session 73 - 2026-01-06

### Ziel
Selbsterhaltung auf Konsistenz und Logik prüfen

### Erledigt

1. **Konsistenzprüfung durchgeführt**
   - Alle Dateien in /opt/Claude/ analysiert
   - Widersprüche und veraltete Einträge identifiziert

2. **Inkonsistenzen behoben**
   - Mac Pro IP: .144 → .17 korrigiert
   - Claude Code Version: 0.2.65 → 2.0.65 vereinheitlicht
   - iCloud-Backup Referenzen entfernt (durch QNAP ersetzt)
   - Obsolete Scripts gelöscht
   - Leerer Ordner 02_DOCS gelöscht
   - Horst.md archiviert (veraltet von 2025-12-22)
   - QNAP Sicherheitshinweis entfernt (NAS läuft bereits)
   - SSL/HTTPS als erledigt markiert

### Lessons Learned
- Regelmäßige Konsistenzprüfung verhindert Drift zwischen Dokumentation und Realität
- Obsolete Dateien/Scripts sollten gelöscht, nicht nur ignoriert werden

---

## Session 72 - 2026-01-05

### Ziel
QNAP NAS (NASHORST) vollständig ins Admin-Portal integrieren

### Erledigt

1. **QTS Health-Check implementiert**
   - Eigene Funktion `get_qts_health()` für QNAP-spezifische Befehle
   - CPU via `/proc/loadavg` + `/proc/cpuinfo`
   - RAM via `free -m` (QNAP gibt MB statt Bytes aus)
   - Disk via `zpool list -Hp` für ZFS-Pools
   - Uptime via `uptime`

2. **Log-Viewer für QTS gefixt**
   - QTS wurde fälschlich als Windows behandelt → "powershell: command not found"
   - Explizite QTS-Behandlung in Log-Funktionen hinzugefügt

3. **Backup-Seite auf NAS umgestellt**
   - War: Liest von Hyper-V Host `E:\Backup_VM` via PowerShell
   - Jetzt: Liest von NAS `/share/ZFS2_DATA/Public/Backups/VMs/` via SSH
   - Struktur: `VM_NAME/daily/YYYY-MM-DD_HHMM`
   - 14 VMs, 24 Backups werden korrekt angezeigt
   - Löschen funktioniert auf dem NAS

4. **"Backup starten" entfernt**
   - Nicht mehr nötig - Backup läuft automatisch via Scheduled Task auf DASBIEST

### Geänderte Dateien
- `/opt/admin-portal/backend/app/api/machines.py` - QTS Health + Logs
- `/opt/admin-portal/backend/app/api/vmbackup.py` - NAS statt Hyper-V Host
- `/opt/admin-portal/frontend/src/routes/backups/+page.svelte` - Aufgeräumt

### Lessons Learned
- QNAP QTS hat andere Befehle als Standard-Linux (`free -m` statt `free -b`)
- Backup-Struktur auf NAS: `daily/` Unterordner für tägliche Backups
- Datum-Format auf NAS: `YYYY-MM-DD_HHMM` (ohne Bindestrich bei Zeit)

---

## Session 71 - 2026-01-05

### Ziel
Terminal-Scroll Bug in Safari fixen (für Marcel)

### Erledigt

1. **Problem analysiert**
   - Marcel kann im Web-Terminal (Safari Desktop) nicht hochscrollen
   - tmux Copy-Mode (`Ctrl+B [`) funktioniert nicht
   - Er sieht nur die letzten Zeilen von Claude-Output

2. **Fix versucht**
   - Touch-Events für iOS hinzugefügt
   - `-webkit-overflow-scrolling: touch` aktiviert
   - `touch-action: pan-y` für Terminal-Container
   - Frontend neu gebaut und deployed
   - **Ergebnis: Hat nicht geholfen**

3. **Ursache identifiziert**
   - xterm.js hat bekannte Probleme mit Safari
   - Ist ein upstream Bug in der Terminal-Bibliothek
   - Nicht einfach zu fixen ohne xterm.js zu ersetzen

4. **Workaround für Marcel**
   - Dateien in Teilen anzeigen lassen ("Zeig mir Zeile 1-50")
   - Oder Chrome statt Safari nutzen

### Lessons Learned
- xterm.js + Safari = bekanntes, schwer lösbares Problem
- Nicht jeder braucht ein komplexes Setup
- Das Portal ist ein persönliches Werkzeug, kein Produkt für andere

---

## Session 70 - 2026-01-05

### Ziel
QNAP NAS (NASHORST) für Backups einrichten

### Erledigt

1. **QNAP NAS konfiguriert**
   - IP: 192.168.42.126 (LAN) / 10.0.0.2 (2.5 Gbps Direktverbindung)
   - Hostname: NASHORST
   - Speicher: 2x 10TB ZFS-Pools (zpool1, zpool2)
   - SMB-Share: `//192.168.42.126/Public`

2. **Projektdaten-Backup angepasst**
   - Neues Script: `/opt/Claude/scripts/backup-vms-to-qnap.sh`
   - Streamt direkt aufs NAS (kein lokaler Zwischenspeicher)
   - 12 VMs werden gesichert
   - Retention: 14 Tage

3. **Automatischer Mount eingerichtet**
   - fstab-Eintrag mit Credentials-Datei
   - Mount: `/mnt/nashorst`
   - Cronjob: täglich 3:00 Uhr

4. **VM-Export Backup auf DASBIEST**
   - PowerShell-Script: `C:\Scripts\vm_backup_qnap.ps1`
   - Scheduled Task: "VM Backup QNAP" täglich 3:00
   - Ziel: `//10.0.0.2/Public/Backups/VMs` (2.5 Gbps)
   - Rotation: 7 täglich, 4 wöchentlich, 3 monatlich
   - E-Mail Report an superadmin@systemhaus-horst.de

### Lessons Learned
- SMB-Mount braucht uid/gid für Schreibrechte
- 2.5 Gbps Direktverbindung nur von DASBIEST erreichbar
- vm_backup.py auf .230 obsolet - Backup läuft jetzt direkt auf DASBIEST

---

## Session 69 - 2026-01-04

### Ziel
GPU-Passthrough RTX 5080 an Office VM (.253) - zweiter Versuch mit Windows 11 Enterprise

### Erledigt

1. **Windows 11 Enterprise installiert**
   - Dieter hat 80€ Key gekauft und aktiviert
   - DDA sollte jetzt möglich sein

2. **GPU-Passthrough durchgeführt**
   - Office VM heruntergefahren
   - RTX 5080 via Disable-PnpDevice deaktiviert
   - LocationPath: `PCIROOT(E0)#PCI(0101)#PCI(0000)`
   - Dismount-VMHostAssignableDevice erfolgreich
   - Add-VMAssignableDevice erfolgreich

3. **VM-Start GESCHEITERT**
   - Fehler 0xC035001E: "Ein Hypervisorfeature ist für den Benutzer nicht verfügbar"
   - Identischer Fehler wie mit Windows 11 Pro
   - Problem liegt also NICHT am Windows-Edition

4. **Rollback durchgeführt**
   - GPU von VM entfernt
   - GPU zurück an Host gemountet
   - Office VM läuft wieder

5. **Hardware-Analyse**
   - Mainboard: ASUS Pro WS WRX90E-SAGE SE
   - CPU: AMD Threadripper PRO 9965WX
   - BIOS: AMI 1203 (Juli 2025)
   - IOV-Support: True (laut Get-VMHost)

### Vermutung
BIOS-Einstellungen:
- IOMMU/AMD-Vi nicht aktiviert?
- Re-Size BAR aktiv (kollidiert mit DDA)?
- SR-IOV fehlt?

### Lessons Learned
- Windows 11 Enterprise allein reicht nicht
- Der Fehler 0xC035001E kommt von der Hardware-/BIOS-Ebene
- RTX 5080 ist sehr neu (Jan 2025) - evtl. Treiber/Firmware-Probleme

---

## Session 66 - 2026-01-02

### Ziel
Prompt-Ordner verteilen + Konsistenzprüfung durchführen

### Erledigt

1. **Prompt-Ordner `/opt/Claude/prompts/` verteilt**
   - Von .254 an alle 12 VMs kopiert
   - Inhalt: `konsistenzpruefung.md`

2. **Konsistenzprüfung für Admin-Portal (.230) durchgeführt**
   - 94 Backend-Endpoints analysiert
   - Frontend API-Calls verglichen
   - Ergebnis: 🟢 GUT (0 kritische Bugs, 8 Minor)
   - Report: `konsistenz-report-admin-server.md` auf Mac Desktop

3. **Konsistenzprüfungs-Prompt v2 erstellt**
   - v1: 45 Zeilen, nur FastAPI
   - v2: 151 Zeilen, Multi-Framework Support
   - Neu: WebSocket-Check, Schema-Tiefenanalyse, Auth-Matrix, Query-Parameter, Legacy-Code-Suche
   - Auf alle 12 VMs verteilt (ersetzt v1)

4. **Snippet-Kategorie "Wartung & Analyse" erstellt**
   - ID: 17, Farbe: Orange (#f59e0b), Icon: wrench
   - Erstes Snippet: "Konsistenzprüfung Frontend/Backend" (ID: 56)

### Geänderte Dateien
- `/opt/Claude/prompts/konsistenzpruefung.md` (auf allen 12 VMs)
- Portal: Neue Kategorie + Snippet in DB

---

## Session 65 - 2026-01-02

### Ziel
Admin Portal iOS App - Konzepte Sync + Snippets Edit fixen

### Erledigt

1. **Konzepte: Sync-to-VM Button hinzugefügt**
   - "Zur VM synchronisieren" Button in Detailansicht
   - Nutzt existierenden API-Endpoint `syncConceptToVm`
   - Loading-Indikator während Sync

2. **Snippets: Edit-Funktion verbessert**
   - Bessere Fehlerbehandlung mit 5-Sekunden-Snackbar
   - Validierung der Snippet-ID vor Update
   - category_id nur gesendet wenn gesetzt

### Geänderte Dateien
- `/opt/admin-portal-app/lib/screens/konzepte_screen.dart`
  - `_syncing` State-Variable
  - `_syncToVm()` Methode
  - ElevatedButton mit cloud_upload Icon
- `/opt/admin-portal-app/lib/screens/snippets_screen.dart`
  - Verbesserte `_save()` Methode

---

## Session 64 - 2026-01-02

### Ziel
Admin Portal iOS App - Terminal WebView verbessern

### Erledigt

1. **Terminal WebView Input-Problem behoben**
   - Problem: Doppeltes Eingabefeld (Web-Input + iOS-Accessory-Leiste)
   - Lösung: Native Flutter-Eingabefeld unten am Bildschirm
   - Web-Input wird per JavaScript versteckt
   - Befehle werden per JavaScript an das Terminal gesendet
   - Toggle-Button in AppBar um Eingabefeld ein/auszuschalten

### Geänderte Dateien
- `/opt/admin-portal-app/lib/screens/webview_terminal_screen.dart`
  - Native TextEditingController + FocusNode
  - `_sendCommand()` Methode für JavaScript-Injection
  - Container mit Flutter TextField unten
  - Keyboard-Hide Toggle Button

---

## Session 63 - 2026-01-02

### Ziel
Admin Portal iOS App erstellen

### Erledigt

1. **Admin Portal iOS App komplett erstellt**
   - Projekt: `/opt/admin-portal-app/`
   - Screens: Login, Dashboard (mit Host-Gruppen), Sessions, Terminal, Snippets
   - API-Service für Backend-Kommunikation
   - Dark Theme passend zur Web-UI

2. **Login-Bug behoben**
   - API erwartet JSON, nicht form-urlencoded
   - Passwort-Hash in DB korrigiert

3. **Dashboard nach Web-UI umgestaltet**
   - Host-Gruppen mit collapsible VM-Listen
   - OS-Badges mit Farbcodierung

4. **Sessions-Seite implementiert**
   - Zeigt Claude-Prozesse auf allen VMs
   - Kill-Button + Terminal-Button

5. **Terminal-Übernahme via WebView**
   - Token-Injection in localStorage
   - Sidebar/Nav verstecken
   - `/machines/{id}` statt `/terminals/{id}`

---

## Archivierte Sessions

| Sessions | Zeitraum | Archiv |
|----------|----------|--------|
| 56-62 | 2025-12-28 bis 2026-01-01 | `/opt/Claude/archiv/sessions_56-62.md` |

---
