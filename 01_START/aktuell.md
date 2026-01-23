# Aktuelle Aufgabe

**Stand:** 2026-01-23 (Session 95 - Feierabend)

---

## JETZT

**Status:** Feierabend

---

### Session 95 Ergebnisse

- **Neue VM labor (.239) eingerichtet:**
  - Debian 13, SSH Port 2222, Hostname: labor
  - SSH-Key deployed
  - Selbsterhaltung in /opt/Claude/01_START/
  - SMB-Share "labor" mit Root-Zugriff
  - Statische IP 192.168.42.239 konfiguriert
  - tmux + Claude Code 2.0.65 installiert (Auto-Updates aus)
  - In Admin-Portal DB eingetragen (ID 168)
  - Mac /etc/hosts aktualisiert

- **Zweck labor VM:**
  - Audio-Labor für Ton- und Klangentwicklung
  - Umfangreicher Startprompt mit Projekt-Spezifikation:
    - Web-Synthesizer mit React/Vue + Node.js Backend
    - Oszillatoren, Filter, ADSR, Effekte, LFO
    - Sample-Import, MIDI-Support
    - Step-Sequenzer, Piano-Roll
    - Export nach WAV/MP3/FLAC
  - Ziel: Klangfarben und Tonmuster für neue Instrumentalwerke

---

## Arbeitskontext

**Claude läuft auf:** 192.168.42.230 (Admin-Server) - LOKAL

---

## TODO: Nächste Schritte

- [ ] Website für Inka (.235) aufsetzen
- [ ] Beobachten ob Terminal-Disconnects weiterhin auftreten
- [ ] labor (.239) - Claude starten und Klang-Synthesizer entwickeln lassen

