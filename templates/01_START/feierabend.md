# FEIERABEND-PROMPT

**Wenn der User "feierabend" sagt, dann:**

---

## 1. Selbsterhaltung aktualisieren

### aktuell.md
- Aktuellen Stand dokumentieren
- Nächste Schritte notieren
- Datum aktualisieren

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

## Beispiel-Antwort nach "feierabend":

"Feierabend-Routine:

1. aktuell.md aktualisiert
2. Hippocampus.md - Session X dokumentiert
3. Praefrontaler_Cortex.md aktualisiert
4. Hippocampus hat XX Zeilen (OK / archivieren nötig)

**Nächste Session:** Sage das Startwort für Kontext.

Guten Feierabend!"
