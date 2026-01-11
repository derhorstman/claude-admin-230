#!/bin/bash
# Terminal/Claude Glossar als PDF per Mail senden
# Usage: ./terminal-glossar-pdf.sh [email]

EMAIL="${1:-derhorst@me.com}"

cat << 'EOF' > /tmp/terminal-glossar.md
# TERMINAL & CLAUDE CODE GLOSSAR

## Englische Begriffe einfach erklärt

---

### GIT & VERSIONIERUNG

| Begriff | Bedeutung |
|---------|-----------|
| **commit** | Änderungen speichern/festschreiben |
| **push** | Änderungen zum Server hochladen |
| **pull** | Änderungen vom Server holen |
| **merge** | Zwei Versionen zusammenführen |
| **branch** | Arbeitszweig (parallele Version) |
| **repository (repo)** | Projektordner mit Versionshistorie |
| **clone** | Projekt kopieren/herunterladen |
| **checkout** | Zu anderem Branch wechseln |
| **stash** | Änderungen temporär beiseitelegen |

---

### BUILD & DEPLOY

| Begriff | Bedeutung |
|---------|-----------|
| **build** | Projekt zusammenbauen/kompilieren |
| **deploy** | Auf Server veröffentlichen/ausrollen |
| **install** | Abhängigkeiten installieren |
| **dependencies** | Benötigte Zusatzpakete |
| **compile** | Code in ausführbares Programm umwandeln |
| **bundle** | Dateien zusammenpacken |
| **minify** | Code verkleinern (für Produktion) |

---

### DOCKER & CONTAINER

| Begriff | Bedeutung |
|---------|-----------|
| **container** | Isolierte Laufzeitumgebung (wie Mini-VM) |
| **image** | Vorlage für Container |
| **volume** | Dauerhafter Speicher für Container |
| **compose** | Mehrere Container orchestrieren |
| **build** | Image erstellen |
| **up / down** | Container starten / stoppen |
| **logs** | Ausgaben/Protokolle anzeigen |
| **exec** | Befehl im Container ausführen |

---

### NETZWERK & SERVER

| Begriff | Bedeutung |
|---------|-----------|
| **SSH** | Sichere Fernverbindung (Secure Shell) |
| **port** | Netzwerk-Anschluss (z.B. 80=Web, 22=SSH) |
| **host** | Zielrechner/Server |
| **proxy** | Vermittler zwischen Client und Server |
| **API** | Programmierschnittstelle |
| **endpoint** | API-Adresse für bestimmte Funktion |
| **request** | Anfrage an Server |
| **response** | Antwort vom Server |
| **timeout** | Zeitüberschreitung |

---

### FEHLER & STATUS

| Begriff | Bedeutung |
|---------|-----------|
| **error** | Fehler (Programm stoppt) |
| **warning** | Warnung (läuft weiter) |
| **debug** | Fehlersuche/Entwicklermodus |
| **exception** | Ausnahmefehler |
| **stack trace** | Fehler-Rückverfolgung |
| **exit code 0** | Erfolgreich beendet |
| **exit code 1+** | Mit Fehler beendet |
| **deprecated** | Veraltet, bald entfernt |

---

### DATEIEN & VERZEICHNISSE

| Begriff | Bedeutung |
|---------|-----------|
| **directory (dir)** | Ordner/Verzeichnis |
| **path** | Pfad zur Datei |
| **file** | Datei |
| **read** | Lesen |
| **write** | Schreiben |
| **permission** | Berechtigung |
| **recursive** | Auch Unterordner einbeziehen |

---

### PROZESSE & SYSTEM

| Begriff | Bedeutung |
|---------|-----------|
| **process** | Laufendes Programm |
| **daemon** | Hintergrund-Dienst |
| **kill** | Programm beenden |
| **restart** | Neu starten |
| **status** | Aktueller Zustand |
| **running** | Läuft gerade |
| **stopped** | Gestoppt |
| **pending** | Wartend/ausstehend |

---

### CLAUDE CODE SPEZIFISCH

| Begriff | Bedeutung |
|---------|-----------|
| **tool** | Werkzeug (Bash, Read, Write, etc.) |
| **task** | Aufgabe/Unteragent starten |
| **glob** | Dateimuster-Suche (*.js) |
| **grep** | Textsuche in Dateien |
| **edit** | Datei bearbeiten |
| **snippet** | Befehlsvorlage |
| **session** | Sitzung/Arbeitssession |
| **context** | Gesprächsverlauf/Wissen |

---

### HÄUFIGE ABKÜRZUNGEN

| Abkürzung | Bedeutung |
|-----------|-----------|
| **npm** | Node Package Manager |
| **CLI** | Command Line Interface (Terminal) |
| **GUI** | Graphical User Interface (Fenster) |
| **VM** | Virtual Machine |
| **OS** | Operating System (Betriebssystem) |
| **DB** | Database (Datenbank) |
| **URL** | Web-Adresse |
| **JSON** | Datenformat (JavaScript Object Notation) |
| **YAML** | Konfigurationsformat |
| **SSL/TLS** | Verschlüsselung (HTTPS) |

---

*Stand: $(date +%d.%m.%Y)*
EOF

# PDF erstellen
pandoc /tmp/terminal-glossar.md -o /tmp/terminal-glossar.pdf --pdf-engine=pdflatex -V geometry:margin=2.5cm

# Per Mail senden
mpack -s "Terminal & Claude Code Glossar (PDF)" /tmp/terminal-glossar.pdf "$EMAIL"

echo "PDF gesendet an $EMAIL"
