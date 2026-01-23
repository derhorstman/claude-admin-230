# Hippocampus - Session-Gedächtnis

**Server:** admin-portal (192.168.42.230)

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

## Session 94 - 2026-01-22

### Office-Rettung & Neue VM inka

**Ziel:** Hängenden Claude auf Office retten, neue VM für Inka einrichten

**Erledigt:**

1. **Office (.253) Claude-Prozess gerettet**
   - Prozess lief seit 05:34 (fast 2h), 44% CPU, 41% RAM
   - tmux-Buffer komplett ausgelesen (3000 Zeilen)
   - Session 102: Nuki-Mail, Buch "Normen brechen", "Dieter und die KI" neu angelegt
   - Inka-Projekt Material gelesen (Ganzer_Plan.pdf - Freelancer-Coaching)
   - kill -9 nötig, normale kill ignoriert

2. **Neue VM inka (.235) komplett eingerichtet**
   - Debian 13, 2GB RAM, 32GB Disk
   - SSH Port 2222, Key-Auth (admin-portal + office)
   - Hostname: inka
   - Statische IP 192.168.42.235
   - Selbsterhaltung: /opt/Claude/01_START/
   - SMB-Share "inka" → / mit force user=root
   - tmux 3.5a + Claude Code 2.0.65

3. **Mac aktualisiert**
   - /etc/hosts: 192.168.42.235 inka
   - mount-all-shares.command: inka Share hinzugefügt

**Fehler & Learning:**
- sed-Befehl `s/Port 22/Port 2222/` auf bereits geänderte Zeile angewendet
- Ergebnis: `Port 222222` → SSH tot, VM musste neu installiert werden
- **Richtig:** `s/^#\?Port 22$/Port 2222/` mit Anker für exakten Match

---

## Session 93 - 2026-01-21

### Infrastruktur-Wartung & Mac-Integration

**Ziel:** Server-Infrastruktur abgleichen, SSH-Keys deployen, SMB aufräumen, Mac-Scripts aktualisieren

**Erledigt:**

1. **Admin-Portal DB mit Praefrontaler_Cortex abgeglichen**
   - WIN11EP Simone (.213) fehlte → als VM 21 hinzugefügt
   - 2 Hosts + 21 VMs + 1 Standalone = 24 Maschinen

2. **SSH-Keys deployed**
   - Mein Key auf 4 Server: stefan (.116), jascha (.150), DASBIEST (.16), kleinerHund (.231)
   - Office (.253) Key auf 3 Server: cant_dev (.174), DASBIEST (.16), kleinerHund (.231)
   - Alle 22 Server jetzt mit Key-Auth erreichbar

3. **SMB-Shares bereinigt**
   - Alle 21 Linux-Server geprüft
   - Doppelte Shares entfernt: printers, print$, systemhaus-001, dieterhorst, opsref, cant-dev
   - dns-portal (.216) Pfad von /opt auf / korrigiert
   - Standard: Jeder Server hat nur noch [hostname] Share → /

4. **Mac /etc/hosts aktualisiert**
   - Hinzugefügt: tools (.110), simone (.213), kleinerhund (.231), hugo (.248)
   - Umbenannt: projekt-15 → manni

5. **Mac mount-all-shares.command überarbeitet**
   - Fehlende Shares hinzugefügt (tools, hugo)
   - Kaputte Shares entfernt (box_dh, scan_in, simone, kleinerhund)
   - Share-Namen korrigiert: mira (nicht systemhaus-001), jascha (nicht opsref), cantdev (nicht cant-dev)
   - dasbiest auf iCloudDrive Share geändert
   - Passwortloses sudo für dieterhorst eingerichtet
   - Case-insensitive grep für Mount-Check
   - 2>/dev/null für Fehlerunterdrückung

6. **Avahi auf devoraxx/office konfiguriert**
   - host-name explizit kleingeschrieben gesetzt
   - SMB-Service mit lowercase Namen
   - Problem: Finder-Seitenleiste zeigt trotzdem Großbuchstaben (NetBIOS-Limitation)

**Learnings:**
- NetBIOS wandelt Namen immer in Großbuchstaben um - nicht änderbar
- Mac Finder Netzwerk-Bereich zeigt SMB-Server (NetBIOS), nicht Avahi
- Bei API-Zugriff: Trailing Slash und Auth nicht vergessen
- Direkt die Datenbank fragen statt HTTP-API umständlich nutzen

---

## Session 92 - 2026-01-21

### Terminal-Disconnect Debugging

**Problem:** Terminal trennt sich nach 3-4 Minuten im laufenden Betrieb

**Analyse:**
- Backend-Logs: `connection open` → `connection closed` ohne Fehlermeldung
- Nginx-Logs: HTTP 101 (WebSocket OK), keine Timeouts
- DHCP-Logs: Warnungen "Dynamic and static leases present" für .206 und .219
- DHCP Pool (200-240) überschneidet sich mit 25+ statischen Reservierungen

**Ursache:** Neue Fritzbox hatte Netzwerk destabilisiert (DHCP-Probleme am Vortag)

**Ergebnis:** Fritzbox-Problem behoben, Terminal-Stabilität beobachten

**Learnings:**
- Bei Netzwerk-Problemen immer zuerst prüfen ob Hardware/Router geändert wurde
- DHCP Pool sollte keine statischen Reservierungen enthalten (aktuell nicht änderbar wegen VM-Abhängigkeiten)

---

## Session 91 - 2026-01-19

### Windows 11 Unattended Installation

**Ziel:** Windows VMs automatisch installieren wie Debian/FreeBSD

**Umgesetzt:**
- `/opt/Claude/scripts/build-windows-iso.sh` - ISO-Builder mit xorriso
- autounattend.xml embedded mit:
  - TPM/SecureBoot/RAM-Bypass (Registry-Hack)
  - Windows 11 Pro Auswahl
  - User dieterhorst/Fantasy+
  - OpenSSH auf Port 2222
  - Node.js, Git, Claude Code automatisch installiert
  - efisys_noprompt.bin (kein "Press any key")

**Probleme gelöst:**
- "Press any key to boot" → efisys_noprompt.bin
- ProductKey Fehler → KMS-Key für Win11 Pro
- "Keine Images verfügbar" → Windows 11 Pro statt Enterprise (ISO hatte kein Enterprise)
- "Windows 11 kann nicht ausgeführt werden" → Registry BypassTPMCheck/SecureBootCheck/RAMCheck
- Secure Boot blockiert xorriso-ISO → Secure Boot immer aus
- FirstLogonCommands liefen nicht → wcm:action="add" + ExecutionPolicy Bypass
- Passwort nicht übernommen → net user Befehl in FirstLogonCommands
- SSH Port 22 → Port 2222

**Erste Windows VM:**
- 015_SYSTEMHAUS-051_VM_001
- IP: 192.168.42.213
- SSH Port 2222
- Claude Code läuft

**Frontend:**
- OS-Typ Toggle (Linux/Windows) in "Neue VM erstellen"
- ISOs gefiltert nach OS-Typ
- "autounattend.xml einbauen" Button

### Learnings

- Windows ISOs haben verschiedene Editionen - genau prüfen welche drin sind
- xorriso baut funktionierende Windows ISOs aber ohne Microsoft-Signatur
- FirstLogonCommands brauchen wcm:action="add" für Zuverlässigkeit
- Windows 11 TPM-Check kann mit Registry-Hack umgangen werden

---

## Session 90 - 2026-01-17

### Resonanz-System / Kollektiv-Hippocampus

**Ausgangspunkt:** Dieters Idee eines "Superhirns" - VMs sollen voneinander wissen

**Umgesetzt:**
- Kollektiv-Hippocampus auf Office (.253) als zentrales Gedächtnis
- `melde-an-office.sh` - Session-Ergebnisse melden
- `frag-office.sh` - Wissen abfragen
- Auf alle 22 Instanzen deployed

**Kettentest:**
- Admin → Office → Proxy → DNS in 62 Sekunden
- DNS hat Rückgabe nicht verstanden

**Feierabend-Trigger:**
- Expliziter Block in allen Praefrontaler_Cortex
- "feierabend" = Routine ausführen, nicht nur verabschieden

**Korrekturen:**
- DNS (.216) = Debian (nicht mehr FreeBSD)
- Projekt_18 = .110 (nicht .100)

### Learnings

- tmux send-keys für Inter-VM-Kommunikation funktioniert
- Nicht alle VMs verstehen komplexe Anweisungen gleich gut
- DASBIEST WSL braucht Umwege (Dateien über Office holen)

---

## Session 89 - 2026-01-15

### Ziel
Snippets-System neu aufbauen

### Erledigt

1. **20 Server-Kategorien erstellt**
   - Eine Kategorie pro VM (passend zu /servers Seite)
   - Kategorie-Namen korrigiert: OpsRef→jascha, Projekt_15→manni, Blue→blue, etc.
   - tools (.110) und hugo (.248) hinzugefügt

2. **Snippet-UI komplett überarbeitet**
   - Problem: Kategorien + Snippets gleichzeitig → passt nicht auf Monitor
   - Lösung: Kategorien → Klick → Snippets mit Zurück-Button
   - Beide Terminal-Seiten (Split + Session) haben jetzt gleiches UI
   - Doppelter Scrollbalken entfernt

3. **Snippet-Logik geändert**
   - Alt: Snippets werden nach verbundenem Server gefiltert
   - Neu: Kategorie-Klick lädt Snippets dieser Kategorie (global)
   - Alle Kategorien werden immer angezeigt

4. **Erstes Snippet angelegt**
   - "Flutter iOS Build Workflow" für Office (.253)
   - Enthält: Sync-Befehl, Build-Befehl, Device ID, Team ID, Problemlösungen

---

## Session 88 - 2026-01-14

### Ziel
Schnellreferenz ausfüllen + Selbsterhaltung prüfen

### Erledigt

1. **Schnellreferenz.md komplett ausgefüllt**
   - Projektspezifisches: Admin-Portal, Tech-Stack, Ports, Docker Container
   - Häufige Befehle: Docker Status/Logs/Rebuild, Claude Code Version
   - Fehler und Lösungen: 6 dokumentierte Probleme aus vergangenen Sessions
   - Credentials-Hinweise: Pfade zu Config-Dateien (keine Passwörter)
   - Kontakte: SSH-Verbindungen zu allen VMs, Kollegen-Scripts
   - Wichtige Pfade und Lernpunkte

2. **Selbsterhaltung Konsistenzprüfung**
   - Hippocampus.md: Hostname "admin" → "admin-portal" korrigiert
   - Doppelte Archiv-Tabelle am Dateiende entfernt
   - Alle 5 Dateien geprüft, jetzt konsistent

3. **Testdatei auf Mac Desktop erstellt**
   - `admin-portal.txt` mit Hostname und IP

---

## Session 87 - 2026-01-14

### Ziel
Sessions-Erkennung False Positive fixen

### Erledigt

1. **Bug: `todo-autoclaude-watcher.cjs` als Claude-Session erkannt**
   - Problem: Portal zeigte .253 mit "Claude Code" obwohl nur ein Node.js-Script lief
   - Ursache: `grep -E '[c]laude'` matchte auch Scripts mit "claude" im Namen
   - Fix in `/opt/admin-portal/backend/app/api/sessions.py`:
     - Suche jetzt nach `/claude` oder `claude-code` (echter Binary-Pfad)
     - Filter: `grep -v '\-watcher'` schließt Watcher-Scripts aus
   - Backend neu gebaut und deployed

---

## Session 86 - 2026-01-14

### Ziel
Backup-API reparieren

### Erledigt

1. **Backup-Seite zeigte keine Backups**
   - Problem: PowerShell gibt Willkommensnachricht aus → JSON kaputt
   - Fix: `-NoProfile -NoLogo` zu allen PowerShell-Aufrufen hinzugefügt
   - Script vereinfacht (2 separate Aufrufe statt komplexes Inline-Script)

### Lernpunkt

**WICHTIG: PowerShell via SSH immer mit `-NoProfile -NoLogo` aufrufen!**

Sonst gibt Windows diese Meldung aus und zerstört den JSON-Output:
```
Windows PowerShell
Copyright (C) Microsoft Corporation. Alle Rechte vorbehalten.
```

---

## Session 85 - 2026-01-13

### Ziel
Kaputte Office-VM (.253) Datenrettung

### Erledigt

1. **VHDX gemountet**
   - `015_SYSTEMHAUS-006_VM_001_kapuut` war bereits als Disk 8 attached
   - `wsl --mount \\.\PhysicalDrive8 --bare` in WSL durchgereicht
   - Partition war LVM → `apt install lvm2` in WSL

2. **LVM aktiviert**
   - `vgscan` fand Volume Group `systemhaus-vg`
   - `vgchange -ay systemhaus-vg` aktivierte 2 Volumes (root + swap)
   - `mount -o ro /dev/systemhaus-vg/root /mnt/kaputt`

3. **Daten gerettet**
   - `/opt/office/`, `/opt/Claude/`, Apps alle lesbar
   - Backup-VM hochgefahren, Kollege via tmux informiert

4. **Sauber aufgeräumt**
   - `umount /mnt/kaputt`
   - `vgchange -an systemhaus-vg`
   - `wsl --unmount \\.\PhysicalDrive8`
   - `Dismount-VHD` in PowerShell

---

## Session 84 - 2026-01-13

### Ziel
Button für DASBIEST Claude-Session auf Terminals- und Sessions-Seite

### Erledigt

1. **"DASBIEST Claude starten" Button implementiert**
   - Orangefarbener Button auf der Terminals-Seite (Split Terminal)
   - Orangefarbener Button auf der Sessions-Seite (Header)
   - Klick: SSH zu DASBIEST → WSL Ubuntu → tmux + Claude starten
   - DASBIEST aus der normalen Maschinenauswahl entfernt

2. **Mehrere Bugfixes während der Implementierung**
   - `wsl` Befehl funktioniert nicht innerhalb von WSL → aufgeteilt in 2 Schritte
   - Extra `claude` Befehl entfernt (tmux startet Claude direkt)
   - Timeouts werden bei Terminal-Wechsel abgebrochen
   - Prüfung ob noch DASBIEST verbunden bevor Befehle gesendet werden

---

## Session 83 - 2026-01-13

### Ziel
Templates aktualisieren + neuen Server deployen

### Erledigt

1. **Office-Server (.253) ausgelesen**
   - Praefrontaler_Cortex.md, aktuell.md, feierabend.md analysiert
   - Änderungen seit letztem Template-Update identifiziert

2. **Templates aktualisiert** (`/opt/Claude/templates/01_START/`)
   - **aktuell.md:** + Wichtige Regeln (NIEMALS Dienste stoppen, langsam arbeiten)
   - **Praefrontaler_Cortex.md:** + Alle 19 VMs korrekt, + .100 Projekt_18, + FreeBSD bei dns-portal, + Lernpunkte
   - **feierabend.md:** + Screenshots löschen, + Git-Backup, + Pre-Session Backup
   - **Schnellreferenz.md:** + Vollständige IP-Liste (23 Einträge)

3. **Neuen Server .110 deployed**
   - Hostname: systemhaus
   - OS: Debian 13 (trixie)
   - Node.js: v22.21.0
   - Claude Code: 2.0.65
   - SSH Port 2222, SMB-Freigabe, 7 SSH-Keys kopiert

---

## Session 95 - 2026-01-23

### Erledigt
- **Neue VM labor (.239) komplett eingerichtet:**
  - SSH Port 2222, Hostname labor
  - SMB-Share "labor" mit Root-Zugriff
  - Selbsterhaltung deployed
  - Statische IP 192.168.42.239
  - tmux + Claude Code 2.0.65 (Auto-Updates deaktiviert)
  - In Admin-Portal DB eingetragen (ID 168)
  - Mac /etc/hosts aktualisiert

- **Umfangreicher Startprompt für Audio-Labor:**
  - Projekt: Web-Synthesizer für Klangentwicklung
  - Features: Oszillatoren, Filter, ADSR, Effekte, LFO, Sequenzer
  - Tech-Stack: React/Vue Frontend, Node.js Backend, Web Audio API
  - Ziel: Klangfarben und Tonmuster für neue Instrumentalwerke

---

## Session 82 - 2026-01-13

### Erledigt
- DASBIEST auf Sessions-Seite hinzugefügt
- Sessions-API gibt jetzt auch DASBIEST (.16) zurück
- Kill-Funktionen mit WSL-Wrapper für DASBIEST

---

## Session 81 - 2026-01-13

### Erledigt
- Terminal-Button für DASBIEST auf Detailseite + Split-Terminal
- Auto-Befehl: `wsl -d Ubuntu -e tmux attach -t claude`

---

### Zusammenfassung Sessions 63-80

- **Session 63-65:** Admin Portal iOS App erstellt (Login, Dashboard, Sessions, Terminal, Snippets)
- **Session 66:** Konsistenzprüfungs-Prompt v2, Snippet-Kategorie "Wartung & Analyse"
- **Session 69:** GPU-Passthrough RTX 5080 gescheitert (BIOS-Problem)
- **Session 70-72:** QNAP NAS (NASHORST) für Backups eingerichtet und ins Portal integriert
- **Session 73:** Selbsterhaltung Konsistenzprüfung
- **Session 74:** Backup-Pfad auf NAS aktualisiert
- **Session 75:** VM "Blue" (.139) für Simone, Frontend Case-Fix
- **Session 77:** VMs Projekt_15 (.186) + Projekt_18 (.100) deployed
- **Session 78:** RAM/Dienste-Anzeige Bugs behoben (Locale + Case)
- **Session 79-80:** Health-Check v2.2 mit 3x Retry-Logik

---
