# Archiv: Sessions 22-30

Archiviert am: 2025-12-20

---

## Session 30 - 2025-12-18

### Ziel
Raspberry Pi Terminal zum Laufen bringen

### Erledigt
1. **SSH-Verbindungsfehler diagnostiziert**
   - Fehlermeldung: "Connection reset by peer" im Admin-Portal Terminal
   - Ping OK, Port 2222 offen
   - Problem: SSH-Key fehlte auf dem Raspberry Pi

2. **SSH-Key auf Raspberry Pi kopiert**
   - `ssh-copy-id -p 2222 dieterhorst@192.168.42.11`
   - Passwort: Fantasy+
   - SSH funktioniert jetzt ohne Passwort

3. **Raspberry Pi Info ermittelt**
   - Hostname: `zigbee2mqtt`
   - OS: Debian Bookworm (Linux 6.12.47)
   - Arch: aarch64 (64-bit ARM)

### Lessons Learned
- "Connection reset by peer" bei SSH kann auch fehlendes Host-Key-Trust oder fehlende Key-Auth bedeuten

---

## Session 29 - 2025-12-18

### Ziel
Raspberry Pi als Standalone-Gerät ins Admin-Portal aufnehmen

### Erledigt
1. **Raspberry Pi (.11) als Standalone angelegt**
   - Neuer Typ `standalone` (nicht unter Host gruppiert)
   - IP: 192.168.42.11, SSH Port 2222
   - Funktion: Smart Home
   - Via API: `POST /api/machines/` mit `type: "standalone"`

2. **Frontend: Standalone-Sektion implementiert**
   - Neue Sektion "Standalone Geräte" in `/routes/servers/+page.svelte`
   - Variable `standalone` aus `data.grouped.standalone` geladen
   - Eigenes lila Icon (unterscheidet sich von VMs)
   - Klickbar zur Detail-Ansicht, Löschen-Button

3. **Terminal + Handbuch für Standalone aktiviert**
   - `/routes/machines/[id]/+layout.svelte` Zeile 211
   - Bedingung von `machine.type === 'vm'` auf `(vm || standalone)` erweitert

### Geänderte Dateien
- `/opt/admin-portal/frontend/src/routes/servers/+page.svelte` (Standalone-Sektion + CSS)
- `/opt/admin-portal/frontend/src/routes/machines/[id]/+layout.svelte` (Terminal-Bedingung)

---

## Session 28 - 2025-12-17

### Ziel
Session 27 Probleme fixen + Terminal-Stabilität verbessern

### Erledigt
1. **Funktionsname-Feature komplett:**
   - Editierbar in Detail-Ansicht (Klick auf "Funktion")
   - Anzeige in Server-Übersicht + Terminal-Header
   - User trägt manuell ein was die VM macht

2. **DELETE-Bug gefixt:**
   - Problem: Foreign Key Constraint bei Snippets/SnippetCategories
   - Lösung: Löscht jetzt zuerst Snippets, SnippetCategories, MachineModule
   - `/opt/admin-portal/backend/app/api/machines.py` angepasst

3. **WebSocket Heartbeat implementiert:**
   - Server sendet alle 25 Sek `{"type": "ping"}`
   - Client antwortet mit `{"type": "pong"}`
   - Stabilisiert Terminal-Verbindungen gegen Timeout
   - `/opt/admin-portal/backend/app/api/terminal.py`
   - `/opt/admin-portal/frontend/src/lib/components/Terminal.svelte`

4. **Dashboard-Route gelöscht** (unfertig/Schrott)

### Geänderte Dateien
- `/opt/admin-portal/backend/app/api/machines.py` (DELETE fix)
- `/opt/admin-portal/backend/app/api/terminal.py` (Heartbeat)
- `/opt/admin-portal/frontend/src/lib/components/Terminal.svelte` (Pong)
- `/opt/admin-portal/frontend/src/routes/dashboard/` (gelöscht)

---

## Session 27 - 2025-12-17

### Ziel
Funktionsname-Feld für Server im Admin-Portal implementieren

### Erledigt
1. **Backend: function_name Feld implementiert**
   - `/opt/admin-portal/backend/app/models/machine.py` - Neue Spalte
   - `/opt/admin-portal/backend/app/api/machines.py` - Schemas + Response angepasst
   - DB-Migration: `ALTER TABLE machines ADD COLUMN function_name VARCHAR(100)`

2. **Frontend: Anzeige + Bearbeitung**
   - `/opt/admin-portal/frontend/src/lib/api.ts` - Machine Interface erweitert
   - `/opt/admin-portal/frontend/src/routes/machines/[id]/+layout.svelte` - Editierbares Feld

3. **Testdaten gesetzt** (via API zum Testen)

---

## Session 26 - 2025-12-17

### Ziel
Neue VM Thea deployen + Snippets organisieren

### Erledigt
1. **Neue VM Thea (192.168.42.252) deployed**
   - Debian 13 (trixie), Node.js 22, Claude Code 2.0.71
   - SSH Port 2222, Selbsterhaltung eingerichtet
   - Hostname auf "thea" gesetzt

2. **Deploy-Script verbessert (`/opt/Claude/deploy-selbsterhaltung.sh`)**
   - Port-Erkennung: Testet Port 2222, dann 22
   - sed mit `#` statt `/` als Delimiter (OS-String mit Slashes)
   - Automatische SSH-Port-Umstellung auf 2222
   - Jetzt 8 Schritte statt 7

3. **Snippet-Kategorien erstellt**
   - Admin Server (blau, machine_id=42) - 8 Snippets
   - Thea (lila, machine_id=66) - 5 Snippets
   - Office Server hatte sich selbst bereits eine erstellt (rot, machine_id=65)

4. **feierabend.md angepasst**
   - Office-spezifisches Zeug entfernt (Alexa, Office-Handbuch)
   - Admin-Portal-Check hinzugefügt

### Geänderte Dateien
- `/opt/Claude/deploy-selbsterhaltung.sh` (verbessert)
- `/opt/Claude/01_START/feierabend.md` (Admin-Portal statt Office)

### Neue Maschine
| Info | Wert |
|------|------|
| Name | Thea |
| IP | 192.168.42.252 |
| OS | Debian 13 (trixie) |
| SSH | Port 2222 |
| Claude Code | 2.0.71 |

---

## Session 25 - 2025-12-15

### Ziel
tmux-Session-Test + Close-Button für Claude-Prozesse

### Erledigt
1. **tmux-Session-Übernahme getestet**
   - Claude läuft jetzt in tmux (`tmux new -s claude`)
   - Session-Übernahme mit `tmux attach -t claude` funktioniert

2. **Close-Button für Claude-Prozesse**
   - Backend: `DELETE /api/sessions/{machine_id}/process/{pid}`
   - Frontend: X-Button bei jedem Claude-Prozess
   - Bestätigungsdialog vor dem Beenden

### Geänderte Dateien
- `/opt/admin-portal/backend/app/api/sessions.py` (kill_claude_process Endpoint)
- `/opt/admin-portal/frontend/src/routes/sessions/+page.svelte` (killClaudeProcess + Button)

---

## Session 24 - 2025-12-15

### Ziel
Session-API bauen - Sessions aufrechterhalten wenn Browser verlassen wird

### Erledigt
1. **Backend: Session-API (`/opt/admin-portal/backend/app/api/sessions.py`)**
   - `GET /api/sessions` - alle Claude-Prozesse auf allen VMs
   - `GET /api/sessions/{machine_id}` - Sessions einer VM
   - `POST /api/sessions/{machine_id}/start-tmux` - tmux mit Claude starten
   - `DELETE /api/sessions/{machine_id}/tmux/{name}` - tmux beenden

2. **Frontend: Sessions-Seite (`/sessions`)**
   - Live-Übersicht aller Claude-Prozesse (Auto-Refresh 10 Sek)
   - tmux-Sessions anzeigen und beenden
   - Klick auf VM öffnet Terminal
   - Stats: Claude aktiv, tmux Sessions, Online VMs

3. **Navigation erweitert**
   - Neuer Tab "Sessions" zwischen Server und Backups

4. **Verlassen-Warnung**
   - `beforeunload` Event in Terminal.svelte
   - Warnt wenn Terminal aktiv ist und Seite verlassen wird

### Hintergrund
User hat sich versehentlich aus Claude Code Session rausgeschmissen. Session-API ermöglicht Übersicht über alle laufenden Sessions und warnt vor dem Verlassen.

---

## Session 23 - 2025-12-15

### Ziel
TODO-Ordner vom Mac einbinden + Backup-Fehler untersuchen

### Erledigt
1. **TODO-Ordner vom Mac (192.168.42.17) eingebunden**
   - SSH-Key auf Mac kopiert
   - Ordner: `~/Documents/todo_dh/`
   - Startroutine in `startprompt.txt` erweitert
   - Liest alle Dateien inkl. PDFs, .eml

2. **Backup-Fehler auf DASBIEST behoben**
   - Mail analysiert: 5/6 VMs OK, SYSTEMHAUS-001 fehlgeschlagen
   - Ursache: Zwei Backup-Jobs um 03:00 (Windows Task + Admin-Portal Cron)
   - Konflikt: Checkpoint-Erstellung blockierte Export
   - Lösung: Alten `MIRA-VM-Backup` Windows Task deaktiviert
   - Backup war trotzdem erfolgreich (128 GB, Retry nach 2 Min)

3. **Alle Claudes informiert (.214, .216, .253, .254)**
   - Anleitung für TODO-Ordner in deren aktuell.md eingefügt

### Neuer Zugang
- Mac (192.168.42.17): SSH-Key eingerichtet, TODO-Ordner lesbar

---

## Session 22 - 2025-12-14

### Ziel
Neue VM einrichten + Deploy-Template erstellen

### Erledigt
1. **Neue VM 192.168.42.253 eingerichtet**
   - SSH-Key kopiert
   - SSH-Port auf 2222 umgestellt
   - Statische IP konfiguriert
   - Node.js 22 + Claude Code 2.0.69 installiert

2. **Selbsterhaltung mit Netzwerk-Kontext deployed**
   - Alle Nachbar-Server dokumentiert
   - Fragt bei "start" nach Funktion
   - Chef-Info: Dieter mag kurze Antworten

3. **Deploy-Template für neue VMs erstellt**
   - `/opt/Claude/templates/01_START/` - Schablonen
   - Platzhalter: `{{IP}}`, `{{HOSTNAME}}`, `{{OS}}`, `{{DATUM}}`
   - `/opt/Claude/deploy-selbsterhaltung.sh` - Automatisches Deployment
   - Installiert: SSH-Key, Node.js, Claude Code, Selbsterhaltung

### Neue Dateien
- `/opt/Claude/templates/01_START/*.md` (5 Templates)
- `/opt/Claude/deploy-selbsterhaltung.sh`
