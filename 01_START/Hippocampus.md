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

## Session 82 - 2026-01-13

### Ziel
DASBIEST auch auf Sessions-Seite anzeigen

### Erledigt

1. **Sessions-API um DASBIEST erweitert**
   - HOST-Typ mit .16 IP wird jetzt abgefragt (war vorher ausgeschlossen)
   - WSL-Wrapper für ps/tmux-Befehle: `wsl -d Ubuntu -- bash -c "..."`
   - Datei: `/opt/admin-portal/backend/app/api/sessions.py`

2. **Kill-Funktionen für DASBIEST gefixt**
   - `kill_tmux_session()` + `kill_claude_process()` mit WSL-Wrapper
   - X-Button funktioniert jetzt auch für DASBIEST

3. **Backend neu gebaut**

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

## Archivierte Sessions

| Sessions | Zeitraum | Archiv |
|----------|----------|--------|
| 56-62 | 2025-12-28 bis 2026-01-01 | `/opt/Claude/archiv/sessions_56-62.md` |

---
