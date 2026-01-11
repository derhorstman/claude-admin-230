# Archiv: Sessions 11-21

Archiviert am: 2025-12-17

---

## Session 21 - 2025-12-14

### Ziel
Terminal Mobile-Support (iPad/Handy)

### Erledigt
1. **Mobile-Input für virtuelle Tastatur**
   - Verstecktes Input-Feld das Tastatur öffnet
   - Spezial-Tasten Leiste: ESC, TAB, CTRL+C, CTRL+D, ↑, ↓
   - Font-Size 16px verhindert iOS Zoom

2. **Touch-freundliche Anpassungen**
   - Größere Buttons bei `pointer: coarse`
   - Snippets auf Mobile standardmäßig ausgeblendet
   - Fullscreen-Layout auf kleinen Bildschirmen

3. **Snippet-Fix**
   - "Start Admin" Pfad korrigiert in DB
   - `/opt/Claude/Admin/01_START/` → `/opt/Claude/01_START/`

### Geänderte Dateien
- `/opt/admin-portal/frontend/src/lib/components/Terminal.svelte`

---

## Session 20 - 2025-12-14

### Ziel
Live-Terminal + Snippets-Verwaltung im Admin-Portal

### Erledigt
1. **Live-Terminal im Admin-Portal**
   - WebSocket-Backend (`terminal.py`) mit paramiko für SSH
   - xterm.js Frontend (`Terminal.svelte`) mit dynamischem Import (SSR-Fix)
   - nginx WebSocket-Proxy konfiguriert (`proxy_set_header Upgrade`)
   - Terminal-Button auf VM-Detailseite

2. **Snippets-Verwaltung**
   - Backend: `snippets.py` API + `Snippet`/`SnippetCategory` Models
   - Frontend: Snippets-Panel im Terminal-Modal
   - Klickbare Snippets → direktes Einfügen ins Terminal
   - CRUD für Snippets und Kategorien

3. **Claude Start Snippets erstellt**
   - Kategorie "Claude Start" (grün)
   - Start-Snippets: Admin, MIRA, DevoraXx, DHCP, Proxy
   - Feierabend-Snippets: Admin, MIRA, DevoraXx, DHCP, Proxy
   - Alle lesen lokale `/opt/Claude/01_START/` Dateien

4. **Selbsterhaltung reorganisiert**
   - Daten von Admin-Server auf einzelne Maschinen verteilt
   - Jede Maschine hat jetzt `/opt/Claude/01_START/`
   - Duplikate auf Admin-Server entfernt (Admin/, MIRA/, etc.)
   - `screenshots/` + `screenshot.sh` auf alle Maschinen kopiert

### Geänderte Dateien
- `/opt/admin-portal/backend/app/api/terminal.py` (neu)
- `/opt/admin-portal/backend/app/api/snippets.py` (neu)
- `/opt/admin-portal/backend/app/models/snippet.py` (neu)
- `/opt/admin-portal/frontend/src/lib/components/Terminal.svelte` (neu)
- `/opt/admin-portal/nginx.conf` (WebSocket Support)

### Maschinen mit Selbsterhaltung
| Maschine | IP | Status |
|----------|-----|--------|
| Admin | .230 | ✅ |
| MIRA | .15 | ✅ |
| DevoraXx | .214 | ✅ |
| DHCP | .216 | ✅ |
| Proxy | .254 | ✅ |

---

## Session 19 - 2025-12-13

### Ziel
Neue VM (192.168.42.254) als Reverse Proxy vorbereiten

### Erledigt
1. **SSH-Zugriff eingerichtet**
   - SSH-Key kopiert
   - Statische IP: 192.168.42.254
   - SSH Port auf 2222 umgestellt

2. **Selbsterhaltung auf neuer VM eingerichtet**
   - `/opt/Claude/` Ordnerstruktur erstellt
   - Template-Dateien (aktuell.md, Praefrontaler_Cortex.md, Hippocampus.md)
   - startprompt.txt + feierabend.md (Routinen)
   - screenshot.sh angepasst

3. **Dokumentation für Kollegen**
   - Admin-Portal Tech-Stack dokumentiert (SvelteKit, FastAPI, Docker)
   - Aufgabe: Reverse Proxy Portal bauen
   - Domains zum Umziehen dokumentiert (8 Stück)
   - **WICHTIG:** Regel "NIEMALS /home - immer /opt/" dokumentiert

4. **SMB-Freigabe eingerichtet**
   - `\\192.168.42.254\dieterhorst`
   - Root-Zugriff (/)
   - User: dieterhorst / Fantasy+

5. **Claude Code installiert**
   - Node.js 22 + Claude Code v2.0.69

### Neue VM
| Info | Wert |
|------|------|
| Name | systemhaus |
| IP | 192.168.42.254 |
| SSH | Port 2222 |
| SMB | `\\192.168.42.254\dieterhorst` |
| Rolle | Reverse Proxy (künftig) |

---

## Session 18 - 2025-12-12

### Ziel
Funktionshandbücher für alle VMs erstellen + Selbsterhaltung reparieren

### Erledigt
1. **Funktionshandbücher für 7 VMs erstellt**
   - Struktur: `/opt/admin-portal/docs/{IP}/HANDBUCH.md`
   - Per SSH System-Info gesammelt, Markdown geschrieben
   - IPs: .10, .12, .13, .15, .214, .216, .230

2. **Frontend-Anpassungen**
   - Handbuch-Kachel auf VM-Übersicht (IP-basiert)
   - Settings: Doppelte Hosts-Sektion entfernt

3. **Selbsterhaltung repariert**
   - 3x feierabend.md → 1x (Duplikat in 05_ONBOARDING gelöscht)
   - Alle Doku-Pfade korrigiert
   - macOS ._ Dateien gelöscht
   - Leere Ordner entfernt

---

## Session 17 - 2025-12-11

### Ziel
FreeBSD DNS/DHCP Server aufsetzen + Web-Portal bauen

### Erledigt
1. **DNS/DHCP Server auf FreeBSD 14.2**
   - VM: 192.168.42.216 (auf DASBIEST)
   - Unbound DNS + ISC DHCP installiert
   - 153 Geräte aus Fritzbox TR-064 API importiert

2. **Web-Portal gebaut**
   - Flask + Gunicorn + Jinja2 + Tailwind CSS
   - Glass-morphism Dark Theme ("besser als Admin-Portal")
   - Full CRUD: Geräte hinzufügen/bearbeiten/löschen
   - Auto-Regenerierung DNS/DHCP Configs bei Änderungen
   - Responsive mit Hamburger-Menü
   - URL: http://192.168.42.216

3. **Shelly-Namen aus OpenHAB geholt**
   - Fritzbox hatte nur technische Namen ("shelly1-98CDAC2E28DA")
   - OpenHAB JSON-Datenbank geparst
   - 68 Geräte mit echten Namen ("Lampe Küche", "Jalousie Badezimmer")

4. **Fritzbox DHCP deaktiviert**
   - FreeBSD ist jetzt alleiniger DNS/DHCP-Server
   - Alle neuen Leases kommen vom FreeBSD-Server

---

## Session 16 - 2025-12-11

### Ziel
VM-Erstellung: Doppelter Unterordner-Bug fixen

### Erledigt
1. **Doppelter Ordner bei VM-Erstellung behoben**
   - Problem: `D:\Hyper-V\VMs\{VM-Name}\{VM-Name}\`
   - Ursache: Backend erstellte manuell Ordner, Hyper-V nochmal automatisch
   - Fix in `/opt/admin-portal/backend/app/api/vms.py`:
     - Manuellen `New-Item` Schritt entfernt
     - `-Path` auf `D:\Hyper-V\VMs` (Basis) statt `D:\Hyper-V\VMs\{VM-Name}`
   - Hyper-V erstellt den VM-Ordner jetzt automatisch

2. **Lesson Learned:** `docker compose restart` lädt Code NICHT neu!
   - Container startet nur neu mit altem Image
   - Für Code-Änderungen: `docker compose up -d --build backend`

---

## Session 15 - 2025-12-11

### Ziel
Windows-Dienste für DASBIEST anzeigen (waren leer)

### Erledigt
1. **UTF-8/CP1252 Encoding-Problem gelöst**
   - Problem: Services-Endpoint gab leere Liste zurück
   - Debug zeigte: `code=-1`, `'utf-8' codec can't decode byte 0x84`
   - Windows PowerShell gibt CP1252-kodierte Ausgabe
   - Lösung in `/opt/admin-portal/backend/app/core/ssh.py`:
     - Multi-Encoding Support: UTF-8 → CP1252 → latin-1 → ignore
   - 50 Windows-Dienste werden jetzt korrekt angezeigt

2. **Auto-Module bei VM-Import** (aus vorheriger Session)
   - Passende Module werden automatisch aktiviert
   - Basiert auf Typ und OS

3. **Multi-Disk für Windows Health** (aus vorheriger Session)
   - DASBIEST zeigt alle 4 Platten (C:, D:, E:, H:)

---

## Session 14 - 2025-12-11

### Ziel
VM-Backup Feature im Admin-Portal implementieren.

### Erledigt
1. **VM-Backup Frontend-Seite erstellt**
   - Neue Route `/backups` mit Svelte-Komponente
   - VM-Auswahl, Backup-Liste, Löschen-Modal, Live-Log

2. **Navigation erweitert**
   - Neuer "Backups" Tab (zwischen Server und Settings)

3. **Backend-Fixes**
   - Zeitzone korrigiert: `get_local_time()` für CET/CEST
   - VM-Name Validierung erweitert: `015_SYSTEMHAUS-TEST_VM_001`

### WARNUNG - Fast-Crash!
- Versuch VM-001 Ordner umzubenennen schlug fehl
- `Remove-VM` hat VM-Konfiguration gelöscht
- **Backup hat gerettet!**
- **Lesson Learned:** NIE VM-Ordner umbenennen ohne vollständige Sicherung!

---

## Session 13 - 2025-12-11

### Ziel
Auto-Install ISOs für Hyper-V VMs erstellen + ISO-Auswahl im Frontend.

### Erledigt
1. **ISO-Auswahl im Frontend**
   - Backend: `/api/vms/isos` Endpoint
   - Frontend: ISO-Grid in VM-Erstellung
   - `iso_path` Parameter in VMCreateRequest

2. **FreeBSD 14.2 Auto-Install ISO erstellt**
   - Automatische Installation ohne User-Interaktion
   - User: dieterhorst, Passwort: Fantasy+, SSH-Key Auth

3. **Boot-Order Fix für Gen2 VMs**
   - DVD → HDD (kein PXE mehr)

---

## Session 12 - 2025-12-10

### Ziel
Kleinere UI-Anpassung.

### Erledigt
- Settings-Seite: "Server"-Karte entfernt
- Version nur noch im Footer

---

## Session 11 - 2025-12-10

### Ziel
UI-Verbesserungen: Modul-Seiten, API-Docs Dark Theme, Settings.

### Erledigt
1. **Backend-Fixes**
   - `/api/machines/{id}/status` Endpoint
   - Cronjob-Templates erweitert
   - Module für alle Maschinen aktiviert

2. **Services-Seite neu gebaut** (Stats-Grid, Filter, Cards)

3. **Logs-Seite neu gebaut** (Zeilenanzahl-Selector, Bottom-Sheet)

4. **Settings-Seite überarbeitet** (Host-Cards mit Modul-Buttons)

5. **API Docs Dark Theme** (HTMLResponse mit inline CSS)

### Lessons Learned
- `docker compose restart` lädt Code nicht neu → `build --no-cache` nötig
- In Python f-strings: geschweifte Klammern verdoppeln `{{` `}}`
