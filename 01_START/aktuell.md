# Aktuelle Aufgabe

**Stand:** 2026-01-22 (Session 94 - Feierabend)

---

## JETZT

**Status:** Feierabend

---

### Session 94 Ergebnisse

- **Office (.253) gerettet:**
  - Claude-Prozess hing seit ~1:40h (44% CPU, 41% RAM)
  - Kompletten tmux-Buffer ausgelesen (Session 102 Dialog)
  - Wichtige Inhalte gesichert: Nuki-Mail, Buch "Normen brechen", Inka-Projekt
  - Prozess mit kill -9 beendet, neue tmux-Session gestartet

- **Neue VM inka (.235) eingerichtet:**
  - Debian 13, SSH Port 2222, Hostname: inka
  - SSH-Keys deployed (admin-portal + office)
  - Selbsterhaltung in /opt/Claude/01_START/
  - SMB-Share "inka" mit Root-Zugriff
  - Statische IP 192.168.42.235
  - tmux + Claude Code 2.0.65 installiert
  - Zweck: Website oldenburger-digitalservices.de

- **Mac aktualisiert:**
  - /etc/hosts: inka (.235) hinzugefügt
  - mount-all-shares.command: inka Share hinzugefügt

- **Fehler gemacht:**
  - sed-Befehl für SSH-Port doppelt ausgeführt → Port 222222 statt 2222
  - VM musste neu installiert werden
  - Lesson: Bei Systemkonfig immer Anker verwenden: `s/^#\?Port 22$/Port 2222/`

---

## Arbeitskontext

**Claude läuft auf:** 192.168.42.230 (Admin-Server) - LOKAL

---

## TODO: Nächste Schritte

- [ ] inka (.235) in Admin-Portal DB hinzufügen
- [ ] Website für Inka aufsetzen
- [ ] Beobachten ob Terminal-Disconnects weiterhin auftreten

