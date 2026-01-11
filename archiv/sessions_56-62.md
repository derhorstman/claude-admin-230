# Archiv: Sessions 56-62

**Archiviert am:** 2026-01-05 (Session 72)
**Zeitraum:** 2025-12-28 bis 2026-01-01

---

## Zusammenfassung

- **Session 56:** Claude Code 2.0.76 Bug gefunden → Downgrade auf 2.0.65, Ticket-System aufgebaut
- **Session 57:** Z-Button für Zwischenspeichern, Passwort geändert, .174 eingerichtet
- **Session 58:** Konzepte-Seite: Löschen + Neu-Erstellen
- **Session 59:** Docker-Container Rebuild-Bug, Claude Code Auto-Updates deaktiviert
- **Session 60:** Sync-Feature für Konzepte
- **Session 61:** Server-Liste aktualisiert, Feierabend-Prompts vereinheitlicht, Pre-Session Backup
- **Session 62:** Context-Warning Hook, Git-Workflow für cant, SMB-Shares

---

## Session 62 - 2026-01-01

### Ziel
Context-Warning Hook auf alle VMs + Git-Workflow für cant + SMB-Shares

### Erledigt

1. **Context-Warning Hook implementiert**
   - Script: `/opt/Claude/hooks/context-warning.sh`
   - Warnt bei 70%, 80%, 90% Context-Füllstand
   - Empfiehlt Feierabend-Routine bei 70%+
   - PreCompact Hook für 95%+ (Auto-Compact)
   - Auf alle 12 VMs deployed (inkl. .230)
   - jq auf allen VMs installiert

2. **Git-Workflow für cant eingerichtet**
   - .166 (Produktion): Git-Repo initialisiert, Initial commit
   - .174 (Dev): SSH-Key erstellt, Repo geclont
   - SSH-Key von .174 auf .166 hinterlegt
   - Workflow: Dev auf .174 → Push → Pull auf .166

3. **.174 als cant-dev Server konfiguriert**
   - Praefrontaler_Cortex.md angepasst (Dev-Server für cant)
   - Beziehung zu .166 dokumentiert

4. **.166 Produktions-Warnung eingebaut**
   - Praefrontaler_Cortex.md mit WARNUNG-Box
   - VERBOTEN: Code-Änderungen, DB-Migrationen, Container-Neustarts
   - Stefan nutzt das System 24/7

5. **SMB-Shares bereinigt + Mac konfiguriert**
   - [homes] Share auf allen VMs entfernt
   - Samba auf 6 VMs nachinstalliert (.252, .128, .150, .166, .174, .216)
   - FreeBSD Firewall: Ports 139/445 geöffnet
   - Mac /etc/hosts mit allen Servernamen
   - Mac ~/mount-all-shares.sh Script erstellt
   - Alle 13 Shares mit Hostnamen statt IPs
   - Passwörter im macOS-Schlüsselbund
   - .246: `dieterhorst` → `edo` umbenannt

---

## Session 61 - 2025-12-31

### Ziel
Server-Liste aktualisieren + Feierabend-Prompts vereinheitlichen + Pre-Session Backup

### Erledigt

1. **Server-Liste aktualisiert**
   - PEDAGOGUS (.128) entdeckt und dokumentiert - Voting-Plattform
   - OpsRef (.150) korrekt benannt - Aviation Reference
   - Thea (.252) Funktion ergänzt - Pflege-Assistent
   - edo (.246) Funktion ergänzt - Email-Dienst
   - SYSTEMHAUS-004 (.205) entfernt - nicht erreichbar
   - Mac Pro korrigiert: .17 statt .144
   - Praefrontaler_Cortex.md: Funktion-Spalte hinzugefügt

2. **Feierabend-Prompts vereinheitlicht**
   - Alle 11 VMs haben jetzt identische feierabend.md
   - Archiv-Pfad: einheitlich `/opt/Claude/archiv/`
   - Git-Backup + Screenshots löschen überall

3. **Pre-Session Backup implementiert**
   - Script: `/opt/Claude/scripts/pre-session-backup.sh`
   - Auf alle 11 VMs verteilt
   - Erstellt `/opt/Claude/backups/pre-session-DATUM.tar.gz`
   - Behält letzte 5 Backups automatisch

4. **Start-Button (S) verbessert**
   - Führt jetzt erst Backup aus, dann Claude
   - Befehl: `pre-session-backup.sh && claude "lies ..."`
   - Frontend neu gebaut

5. **Alle SSH-Zugänge geprüft**
   - 17/18 erreichbar (Mac war auf falscher IP dokumentiert)

---

## Session 60 - 2025-12-31

### Ziel
Sync-Feature für Konzepte + Backups

### Erledigt
- Backups erstellt (Selbsterhaltung + Admin-Portal)
- Sync-Feature: Konzept → Markdown auf Ziel-VM
- Container neu gebaut

---

## Session 59 - 2025-12-31

### Ziel
Wartung: Bugs von heute Morgen beheben

### Erledigt

1. **Frontend-Bug behoben**
   - Lösch-Button war verschwunden
   - Ursache: Container vor Code-Änderung gebaut
   - Fix: `docker compose build --no-cache frontend`

2. **Claude Code Auto-Update Bug**
   - Version automatisch auf 2.0.76 aktualisiert (buggy)
   - Fix: Downgrade auf 0.2.65
   - Auto-Updates deaktiviert (`autoUpdates: false`)

3. **Alle 11 Server abgesichert**
   - Version geprüft: alle auf 2.0.65
   - Auto-Updates auf allen deaktiviert
   - .230, .15, .214, .216, .254, .252, .253, .246, .166, .150, .174

4. **Selbsterhaltung erweitert**
   - Docker-Architektur dokumentiert
   - Container-Rebuild Anleitung
   - Claude Code Wartung Abschnitt

### Lessons Learned
- Docker-Container enthalten Code-Kopie vom Build-Zeitpunkt
- Nach Code-Änderungen IMMER Container neu bauen
- Claude Code Auto-Updates sind gefährlich bei buggy Versionen

---

## Session 58 - 2025-12-30

### Ziel
Konzepte-Seite: Löschen und Neu-Erstellen ermöglichen

### Erledigt

1. **Löschen-Funktion implementiert**
   - `deleteConcept()` Funktion im Frontend
   - Roter Mülleimer-Button im Detail-Modal
   - Bestätigungsdialog vor dem Löschen
   - CSS: Roter Kreis mit Hover-Effekt

2. **Neues Konzept erstellen implementiert**
   - `createConcept()` Funktion im Frontend
   - Grüner "Neu"-Button im Header (neben Sync)
   - Modal mit allen Feldern

3. **Frontend neu gebaut und deployed**

---

## Session 57 - 2025-12-29

### Ziel
Kleinere Verbesserungen + Sicherheit

### Erledigt

1. **Z-Button für "Session Zwischenspeichern"**
   - Neuer türkiser Button im Terminal-Header
   - Zeigt `/opt/Claude/01_START/zwischenspeichern.md` an

2. **Admin-Portal Passwort geändert**
   - Alt: admin123 (unsicher!)
   - Neu: Biest2025!Portal

3. **Neuer Kollege .174 eingerichtet**
   - IP: 192.168.42.174
   - Hostname: systemhaus
   - OS: Debian 13 (trixie)
   - Claude Code: 2.0.65

---

## Session 56 - 2025-12-28

### Ziel
Claude Code Bug fixen + Ticket-System aufbauen

### Erledigt

1. **Kritischer Bug in Claude Code 2.0.76 gefunden**
   - Problem: Claude schreibt automatisch Text ins Terminal ohne User-Eingabe
   - Ursache: Bug in CLI-Version 2.0.76
   - Workaround: Downgrade auf 2.0.65

2. **Alle 9 Linux-VMs downgraded**

3. **Bug-Report an Anthropic**
   - E-Mail an support@anthropic.com gesendet
   - Bug-Report via /bug Befehl abgeschickt

4. **Ticket-System aufgebaut**
   - Akte BUG-2025-001 angelegt unter /opt/Claude/akten/
   - INDEX.md für Ticket-Übersicht

5. **Mail-Integration via AppleScript**
   - Kann Mails auf Mac lesen
   - Kann Mail-Entwürfe erstellen via osascript

6. **Ticket-System an Office (.253) übergeben**

### Lessons Learned
- Claude Code CLI-Version kann Bugs haben, Modell (Opus 4.5) ist nicht betroffen
- AppleScript kann von SSH aus Mail.app steuern
- Downgrade ist manchmal der beste Fix
