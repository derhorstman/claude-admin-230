# Archiv: Sessions 53-55

**Archiviert:** 2026-01-02 (Session 66)

---

## Session 55 - 2025-12-28

### Ziel
Prompt-Hilfe Workflow für Kollegen implementieren

### Erledigt

1. **Remote-Terminal Workflow getestet**
   - Per SSH + tmux in Terminal eines Kollegen schreiben
   - Funktioniert: Text erscheint im Split-Terminal

2. **Helper-Scripts erstellt**
   - `/opt/Claude/scripts/kollege-kontext.sh` - liest aktuell.md vom Kollegen
   - `/opt/Claude/scripts/kollege-schreiben.sh` - schreibt ins Terminal (findet tmux-Session automatisch)

3. **H-Button im Split-Terminal**
   - Neuer lila Button zwischen B und K
   - Funktion `promptHilfe()` sendet PROMPT_HILFE Trigger
   - CSS: Lila Gradient (#a855f7)

4. **Snippet "Prompt-Hilfe für Kollegen"**
   - Kategorie "Claude Workflows" erstellt
   - Content: PROMPT_HILFE Trigger mit Kollegen-Liste

5. **Snippets-Seite Bugs gefixt**
   - Doppelte Kategorie "Claude Workflows" (ID 15) gelöscht
   - Maschinen-Dropdown leer → API trailing slash + `machines` statt `all` + `name` statt `hostname`

6. **Sessions-Seite gefixt**
   - kill-btn funktionierte nicht (CSS: border: none + cursor: pointer fehlten)

7. **Terminal-Komponente erweitert**
   - H-Button für Prompt-Hilfe auch in Server-Detail-Ansicht
   - War vorher nur auf /terminals Seite

---

## Session 54 - 2025-12-27

### Ziel
Neuer Kollege für Chor-Software deployen

### Erledigt

1. **Deploy-Script geprüft**
   - tmux wird bereits installiert (Zeile 53)
   - Script ist vollständig

2. **Neuer Kollege "cant" auf .166 deployed**
   - OS: Debian 13 (trixie)
   - Node.js: v22.21.0
   - Claude Code: 2.0.76
   - tmux installiert
   - SSH auf Port 2222
   - Im Portal eingetragen
   - Funktion: Chor-Software

---

## Session 53 - 2025-12-27

### Ziel
VM .253 (office) - Claude funktioniert nicht mehr

### Erledigt

1. **OAuth-Token abgelaufen**
   - Fehler: "OAuth token has expired. Please obtain a new token"
   - Selbst `/login` gab denselben Fehler

2. **Credentials gelöscht**
   - `rm ~/.claude/.credentials.json`
   - Login-Flow startete trotzdem nicht

3. **Claude Code neu installiert**
   - `sudo npm install -g @anthropic-ai/claude-code`
   - Version 2.0.76 installiert

4. **Settings.json Syntax gefixt**
   - Neuer Fehler: "Bash(*)" nicht mehr gültig
   - Geändert zu "Bash" (ohne Klammern)

5. **Credentials kopiert**
   - Von .230 nach .253 kopiert
   - `scp ~/.claude/.credentials.json dieterhorst@192.168.42.253:~/.claude/`
   - Claude läuft wieder!

### Lessons Learned
- OAuth-Tokens können ablaufen und Login-Flow startet nicht automatisch
- Workaround: Credentials von funktionierendem Server kopieren
- Claude Code Settings-Syntax hat sich geändert: `Bash(*)` → `Bash`
