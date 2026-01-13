# Schnellreferenz

Kurzübersicht für häufige Aufgaben.

---

## SSH-Kurzform

```bash
# Linux VMs (Port 2222)
ssh -p 2222 dieterhorst@192.168.42.XXX

# Windows/Mac (Port 22)
ssh dieterhorst@192.168.42.XXX
```

---

## Wichtige IPs

| IP | Name | Funktion |
|----|------|----------|
| .1 | Gateway | Fritzbox |
| .10 | openhab | Smart Home |
| .12 | Nextcloud | Cloud + Home Assistant |
| .15 | MIRA/EVY | AI-System |
| .16 | DASBIEST | Hyper-V Host |
| .17 | Mac Pro | Dieters Rechner |
| .100 | Projekt_18 | Neues Projekt |
| .116 | stefan | Stefans Portal |
| .126 | NASHORST | QNAP NAS |
| .128 | PEDAGOGUS | Voting |
| .139 | Blue | Simones KI |
| .150 | Jascha | OpsRef |
| .166 | cant | Chor-Software |
| .174 | cant_DEV | Cant Entwicklung |
| .186 | Projekt_15 | Neues Projekt |
| .195 | Marcel | Marcels Portal |
| .214 | devoraxx | Next.js + NestJS |
| .216 | dns-portal | DNS/DHCP (FreeBSD) |
| .230 | admin-portal | Admin-Portal |
| .246 | edo | Email-Dienst |
| .252 | thea | Pflegedoku |
| .253 | office | Office-Server |
| .254 | proxy-portal | Reverse Proxy |

---

## Service-Befehle

```bash
sudo systemctl status DIENST
sudo systemctl restart DIENST
sudo systemctl enable DIENST
journalctl -u DIENST -n 50
```

---

## Datei auf Mac Desktop zeigen

```bash
scp /pfad/zur/datei dieterhorst@192.168.42.17:~/Desktop/
```

---

## Claude reinprompten

```bash
# Session-Name prüfen
ssh -p 2222 dieterhorst@192.168.42.XXX "tmux list-sessions"

# Nachricht senden
ssh -p 2222 dieterhorst@192.168.42.XXX "tmux send-keys -t claude 'Nachricht' Enter"
```

---

## Selbsterhaltung

| Datei | Zweck |
|-------|-------|
| aktuell.md | Aktuelle Aufgabe + Regeln |
| Praefrontaler_Cortex.md | Netzwerk-Kontext |
| Hippocampus.md | Arbeitslog |
| Schnellreferenz.md | Diese Datei |
| feierabend.md | Feierabend-Routine |

---

## Bei Session-Start

1. `lies /opt/Claude/01_START/aktuell.md und Praefrontaler_Cortex.md`
2. Fragen: "Was steht an?"

## Bei Feierabend

1. aktuell.md aktualisieren
2. Hippocampus.md Session dokumentieren
3. Screenshots löschen
4. Git-Backup erstellen
5. Bei >500 Zeilen: archivieren
