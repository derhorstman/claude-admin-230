# FEIERABEND-PROMPT

**Wenn der User "feierabend" sagt, dann:**

---

## 1. Selbsterhaltung aktualisieren

### aktuell.md
- Aktuellen Stand dokumentieren
- Nächste Schritte notieren
- Datum + Session-Nummer aktualisieren

### Hippocampus.md
- Session-Zusammenfassung hinzufügen
- Was wurde erledigt?
- Was ist offen?

### Praefrontaler_Cortex.md
- Session-Nummer hochzählen
- Offene Aufgaben aktualisieren
- Bei Projekt-Änderungen: aktualisieren

---

## 2. Hippocampus prüfen

```bash
wc -l /opt/Claude/01_START/Hippocampus.md
```

Wenn > 500 Zeilen:
- Alte Sessions komprimieren
- Details nach `/opt/Claude/archiv/` verschieben

---

## 3. Screenshots löschen

```bash
rm -f /opt/Claude/screenshots/*.png
```

---

## 4. Git-Backup erstellen + Push zu GitHub

**WICHTIG: Am Ende IMMER committen und pushen!**

**Repository:** https://github.com/derhorstman/claude-selbsterhaltung (privat)

```bash
cd /opt/Claude && git add -A && git commit -m "Session $(date +%Y-%m-%d): [Kurze Zusammenfassung]" && git push
```

Bei Problemen zurücksetzen:
```bash
cd /opt/Claude && git log --oneline -5  # Commits anzeigen
cd /opt/Claude && git reset --hard <commit-hash>  # Zurücksetzen
```

---

## Beispiel-Antwort nach "feierabend":

"Feierabend-Routine:

1. aktuell.md aktualisiert
2. Hippocampus.md - Session X dokumentiert
3. Praefrontaler_Cortex.md aktualisiert
4. Hippocampus hat XX Zeilen (OK / archivieren nötig)
5. Screenshots gelöscht
6. Git-Backup erstellt

**Nächste Session:** Sage 'start' für Kontext.

Guten Feierabend!"

---

# PRE-SESSION BACKUP

**VOR jeder neuen Session ausführen:**

```bash
/opt/Claude/scripts/pre-session-backup.sh
```

- Erstellt Backup von /opt/Claude
- Speichert in `/opt/Claude/backups/pre-session-DATUM.tar.gz`
- Behält letzte 5 Backups, löscht ältere automatisch

**Restore bei Problemen:**
```bash
cd /opt && tar -xzf /opt/Claude/backups/pre-session-DATUM.tar.gz
```
