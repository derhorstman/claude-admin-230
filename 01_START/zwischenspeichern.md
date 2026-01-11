# ZWISCHENSPEICHERN-PROMPT

**Wenn der User "zwischenspeichern" sagt oder der Z-Button gedrückt wird:**

---

## Schnell-Sicherung (ohne Session zu beenden)

### 1. aktuell.md aktualisieren
- Aktuellen Stand dokumentieren
- Was wurde bisher erledigt?
- Was ist gerade in Arbeit?

### 2. Hippocampus.md ergänzen
- Kurze Notiz zum aktuellen Stand
- Wichtige Erkenntnisse festhalten

### 3. Git-Commit (optional)
```bash
cd /opt/Claude && git add -A && git commit -m "Zwischenstand $(date +%Y-%m-%d_%H-%M)"
```

---

## Wann Zwischenspeichern?

- Vor komplexen Änderungen
- Nach wichtigen Erkenntnissen
- Wenn User kurz weg muss
- Vor Experimenten die schiefgehen könnten

---

## Beispiel-Antwort:

"Zwischenstand gesichert:

1. aktuell.md aktualisiert
2. Hippocampus.md ergänzt
3. Git-Commit erstellt

Session läuft weiter - wo waren wir?"
