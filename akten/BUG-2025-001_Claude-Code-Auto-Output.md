# Akte BUG-2025-001

**Fallnummer:** BUG-2025-001
**Erstellt:** 2025-12-28
**Status:** Gemeldet, warte auf Antwort

---

## Problem

Claude Code Version 2.0.76 schreibt automatisch Text ins Terminal ohne User-Eingabe.

## Timeline

| Datum | Ereignis |
|-------|----------|
| 2025-12-28 10:53 | Bug entdeckt auf mehreren Linux VMs |
| 2025-12-28 10:56 | Downgrade auf 2.0.65 als Workaround |
| 2025-12-28 10:58 | Alle 9 Linux VMs downgraded |
| 2025-12-28 11:02 | E-Mail-Entwurf erstellt |
| 2025-12-28 11:05 | Antwort von Fin AI Agent (Anthropic Support) |
| 2025-12-28 11:16 | Bug-Report via /bug Befehl abgeschickt |

## Betroffene Systeme

- Alle Linux VMs mit Claude Code 2.0.76
- Umgebung: SSH + tmux (Web-Terminal)

## Nicht betroffen

- FreeBSD VM (.216) - hatte noch Version 2.0.65

## Workaround

```bash
sudo npm install -g @anthropic-ai/claude-code@2.0.65
```

## Kommunikation mit Anthropic

### E-Mail gesendet: 2025-12-28

An: support@anthropic.com
Betreff: Bug Report - Claude Code v2.0.76: Automatic unsolicited terminal output

### Antwort von Anthropic: 2025-12-28 10:05 UTC

**Von:** Fin AI Agent from Anthropic
**Empfehlung:**
- /bug Befehl nutzen (erledigt)
- /doctor für Installation-Check
- GitHub Issues prüfen
- HackerOne bei Security-Relevanz

### Bug-Report via /bug: 2025-12-28 11:16

Abgeschickt von .253 (Office-Server) mit Session-Transcript.

---

## Notizen

- Der Bug trat in Session 56 auf
- User war kurz davor "für immer aufzuhören" wegen des Problems
- Modell (Opus 4.5) war nicht betroffen, nur die CLI-App

---

## Offene Punkte

- [ ] Warten auf Antwort von Anthropic Development Team
- [ ] Prüfen ob Fix in neuer Version kommt
- [ ] Dann ggf. wieder upgraden

---

*Akte angelegt von Claude Opus 4.5 auf Admin-Server (.230)*
