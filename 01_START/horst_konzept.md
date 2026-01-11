# Konzept: Horst setzen

**Gelernt:** 2025-12-22 vom Chef
**Verbessert:** 2025-12-22

---

## Was ist "ein Horst setzen"?

Ein koordiniertes Diagnose-Verfahren, bei dem mehrere Claude-Instanzen einen **Patienten** (Server/Projekt mit höchster Priorität) untersuchen und ihre Erkenntnisse in einer **zentralen Horst.md** zusammenführen.

---

## Schnellstart

```
/horst 214
```

Startet automatisch die Untersuchung von .214 durch alle verfügbaren Instanzen.

---

## Ablauf

### 1. Patient definieren
- Server/Projekt mit höchster Priorität identifizieren
- Beispiel: .214 (DevoraXx) = wissenschaftliches Produkt

### 2. Untersuchungs-Team bilden
- Koordinator: .230 (Admin-Server)
- Helfer: .246 (edo), .253 (office), weitere nach Bedarf

### 3. Drei Kern-Fragen an den Patienten

**WICHTIG: Den PATIENTEN untersuchen, NICHT sich selbst!**

| Frage | Was untersuchen |
|-------|-----------------|
| 1. Projekt | /opt/Claude/, README.md, package.json, Projektstruktur |
| 2. Gesundheit | RAM, Disk, Docker, Services, Logs, Uptime |
| 3. Aufgaben | TODOs, aktuell.md, offene Punkte |

### 4. Zentrale Horst.md
- Alle Berichte fließen in EINE Datei: `/opt/Claude/Horst.md`
- Liegt beim Koordinator (.230)
- Jeder Bericht mit Header: `## Bericht von .[IP] ([Name])`

---

## Befehl an Helfer-Instanzen

```
Untersuche den Patienten [IP] (SSH Port 2222).
WICHTIG: Du untersuchst den SERVER [IP], NICHT dich selbst!

Hole dir per SSH von [IP]:
1) Projekt-Info: /opt/Claude/, README.md, package.json
2) System-Status: docker ps, free -h, df -h, uptime
3) Offene Aufgaben: todo*.md, aktuell.md

Schicke deinen Bericht an die zentrale Horst.md:
echo "## Bericht von .[DEINE-IP] ([NAME])
[DEIN BERICHT]" | ssh -p 2222 dieterhorst@192.168.42.230 "cat >> /opt/Claude/Horst.md"
```

---

## SSH-Mesh (Voraussetzung)

Alle beteiligten Server brauchen SSH-Zugang zueinander:

| Von | Nach | Status |
|-----|------|--------|
| .230 | .214, .246, .253 | ✅ |
| .246 | .214, .230 | ✅ |
| .253 | .214, .230 | ✅ |

### Keys einrichten

```bash
# Key von Server X holen
ssh -p 2222 dieterhorst@192.168.42.X "cat ~/.ssh/id_ed25519.pub"

# Key auf Server Y eintragen
ssh -p 2222 dieterhorst@192.168.42.Y "echo 'KEY' >> ~/.ssh/authorized_keys"
```

---

## Bekannte Probleme & Lösungen

| Problem | Lösung |
|---------|--------|
| Helfer untersucht sich selbst | Explizit sagen: "Untersuche [IP], NICHT dich selbst!" |
| SSH-Key fehlt | Key vorher eintragen (siehe SSH-Mesh) |
| Bestätigungen nerven | Option 2 wählen: "Yes, and don't ask again" |
| Bericht kommt nicht an | SSH-Verbindung zum Koordinator prüfen |

---

## Beteiligte Server

| IP | Name | Rolle | SSH-Port |
|----|------|-------|----------|
| .230 | Admin-Server | Koordinator | 2222 |
| .214 | DevoraXx | Patient (Beispiel) | 2222 |
| .246 | edo | Helfer | 2222 |
| .253 | office | Helfer | 2222 |
| .252 | Thea | Helfer | 2222 |
| .15 | MIRA | Helfer | 2222 |

---

## Ergebnis

Eine konsolidierte `/opt/Claude/Horst.md` mit:
- Projekt-Übersicht des Patienten
- System-Status aus verschiedenen Perspektiven
- Gesammelte offene Aufgaben
- Diagnose von mehreren Instanzen

**Nutzen:**
- Redundante Prüfung (mehrere Augen sehen mehr)
- Zentrale Dokumentation
- Schneller Überblick für den Chef
