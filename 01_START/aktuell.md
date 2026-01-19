# Aktuelle Aufgabe

**Stand:** 2026-01-19 (Session 91 - Feierabend)

---

## JETZT

**Status:** Feierabend

---

### Session 91 Ergebnisse

- **Windows 11 Unattended Installation gebaut:**
  - ISO-Builder Script: `/opt/Claude/scripts/build-windows-iso.sh`
  - autounattend.xml mit TPM/SecureBoot/RAM-Bypass
  - Windows 11 Pro (nicht Enterprise - ISO hatte kein Enterprise)
  - Automatische Installation: Node.js, Git, OpenSSH, Claude Code
  - SSH Port 2222 (statt 22)

- **Erste Windows VM erfolgreich deployed:**
  - VM: `015_SYSTEMHAUS-051_VM_001`
  - IP: 192.168.42.213
  - SSH: Port 2222, User dieterhorst/Fantasy+
  - Claude Code läuft

- **Frontend erweitert:**
  - OS-Typ Auswahl (Linux/Windows) im "Neue VM erstellen" Modal
  - ISOs werden nach OS-Typ gefiltert
  - "autounattend.xml einbauen" Button für Windows ISOs

- **Backend angepasst:**
  - Secure Boot immer AUS (xorriso-ISOs nicht signiert)
  - TPM aktiviert für Windows 11

- **Selbsterhaltung auf Windows:**
  - `C:\Claude\01_START\` mit aktuell.md und Praefrontaler_Cortex.md

---

## Arbeitskontext

**Claude läuft auf:** 192.168.42.230 (Admin-Server) - LOKAL

**Neue Windows VM:** 192.168.42.213 (SSH Port 2222)

---

## TODO: Nächste Schritte

- [ ] Nächste Windows VM testen ob alles automatisch läuft
- [ ] API Key automatisch auf neue Windows VMs deployen
- [ ] Terminal-Scroll in Safari/macOS fixen (xterm.js Problem)

