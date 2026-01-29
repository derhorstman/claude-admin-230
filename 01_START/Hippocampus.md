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

## Session 99 - 2026-01-29

### Alle VMs ins Projekt-System aufgenommen

**Ziel:** Alle VMs im Admin-Portal unter "Konzepte" mit projekt.yaml und Code-Analyse

**Erledigt:**

1. **devoraxx Code-Analyse für alle VMs**
   - Workflow-Doku erstellt: `/opt/Claude/workflows/devoraxx-analyse.md`
   - 10+ Projekte parallel durch devoraxx analysiert
   - Code per tar/ssh auf devoraxx kopiert
   - API-Workflow: login → local repo → approve → wait → result

2. **22 VMs mit projekt.yaml ausgestattet**
   - Score B: cant, cant_DEV, openhab, Nextcloud, hugo, admin-portal
   - Score C: devoraxx, dns-portal, proxy-portal, Thea, marcel, milena, opsref, pedagogus, office
   - Score D: MIRA, edo, stefan, blue, tools
   - Ohne Score: inka, mogli (noch keine Analyse)
   - Simone (.213): SSH überlastet, ausgelassen

3. **Kritische Findings identifiziert**
   - Fast alle Projekte: Hardcoded Credentials
   - MIRA: API-Keys im Klartext, Score D
   - blue/tools: Command Injection, Score F/D
   - cant: Bestes Projekt mit Score B

4. **Admin-Portal Konzepte-Seite**
   - 24 VMs, 16 mit Projekt, 2 Score A/B, 23 Online
   - Alle Projekte mit Tech-Stack-Tags sichtbar

**Learnings:**
- devoraxx braucht PostgreSQL + Redis (docker-compose.dev.yml)
- API auf Port 3001, Analyse via `/analyses/:id/approve`
- projekt.yaml muss unter `/opt/Claude/projekt.yaml` liegen
- Windows SSH (Simone) überlastet bei vielen Verbindungen

---

## Session 98 - 2026-01-29

### Snippet-Kategorien nach Maschine filtern

**Ziel:** Snippets im Terminal automatisch nach verbundener Maschine anzeigen

**Erledigt:**

1. **Datenbank aktualisiert**
   - Alle 20 Snippet-Kategorien hatten `machine_id = NULL` (global)
   - SQL-Update: Jede Kategorie mit passender `machine_id` verknüpft
   - Mapping basierend auf IP im Kategorienamen (z.B. "office (.253)" → machine_id 111)

2. **Frontend-Logik angepasst** (`/terminals/+page.svelte`)
   - `loadSnippets()` filtert Kategorien: `machine_id === null OR machine_id === machineId`
   - Auto-Select: Beim Verbinden wird die Maschinen-Kategorie automatisch ausgewählt
   - Snippets werden direkt geladen - User muss nicht erst Kategorie wählen

3. **Sidebar-Experiment rückgängig gemacht**
   - Kurzer Test mit permanenter Sidebar rechts am Terminal
   - User wollte das alte Dropdown-UI behalten
   - Nur das Auto-Select-Feature beibehalten

**Learnings:**
- Snippet-Kategorien können per `machine_id` Maschinen zugeordnet werden
- Bei UI-Änderungen erst fragen, dann bauen
- Kleine Änderung (Auto-Select) > große UI-Umbauten

---

## Session 97 - 2026-01-28

### Frontend-Farbkontrast verbessern

**Ziel:** Bessere Lesbarkeit der Icon-Buttons im Admin-Portal

**Erledigt:**

1. **Globale CSS-Variablen angepasst** (`/opt/admin-portal/frontend/src/app.css`)
   - `--text-secondary`: #b3b3b3 → #d4d4d4 (heller)
   - `--text-muted`: #888888 → #a0a0a0 (heller)
   - `--border`: #404040 → #4a4a4a (heller)
   - Neue Variablen für Icon-Buttons: `--icon-btn-bg`, `--icon-btn-border`, `--icon-btn-color`

2. **Neue globale `.icon-btn` Klasse**
   - Hellerer Hintergrund (#2d2d2d)
   - Sichtbarer Rahmen (#505050)
   - Helle Icon-Farbe (#e8e8e8)
   - Varianten: `.danger` (rot), `.warning` (gelb), `.success` (grün), `.favorite` (Stern)
   - Hover-Effekte für alle Varianten

3. **Snippets-Seite aktualisiert**
   - Action-Buttons (Favorit, Kopieren, Bearbeiten, Löschen) nutzen jetzt `.icon-btn`
   - Kategorie-Chips oben beibehalten (kleine farbige Punkte - waren OK)

**Learnings:**
- CSS-Variablen in `app.css` wirken global auf alle Svelte-Komponenten
- Lokale Styles in `<style>` Blöcken können globale überschreiben
- Bei Dark-Mode: Kontrastverhältnis mindestens 4.5:1 für Text anstreben

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

### Zusammenfassung Sessions 81-95

- **Session 81-84:** DASBIEST Terminal-Integration (WSL-Wrapper, Sessions-Seite)
- **Session 83:** Templates aktualisiert, Server .110 deployed
- **Session 85:** Office-VM Datenrettung (LVM Mount in WSL)
- **Session 86-87:** Backup-API repariert (PowerShell NoProfile), Sessions-Erkennung False Positive Fix
- **Session 88-89:** Schnellreferenz ausgefüllt, Snippets-System neu aufgebaut (20 Kategorien)
- **Session 90:** Resonanz-System / Kollektiv-Hippocampus auf Office (.253)
- **Session 91:** Windows 11 Unattended Installation ISO-Builder
- **Session 92-93:** Terminal-Disconnect Debugging, SMB-Cleanup, Mac-Scripts
- **Session 94:** Office-Rettung, neue VM inka (.235)
- **Session 95:** Neue VM labor (.239) mit Audio-Labor Startprompt

### Zusammenfassung Sessions 63-80

- **Session 63-65:** Admin Portal iOS App erstellt
- **Session 66-80:** QNAP NAS, GPU-Passthrough Test, VM-Deployments, Health-Check v2.2

---
