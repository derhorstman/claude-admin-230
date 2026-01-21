# Aktuelle Aufgabe

**Stand:** 2026-01-21 (Session 93 - Feierabend)

---

## JETZT

**Status:** Feierabend

---

### Session 93 Ergebnisse

- **Infrastruktur-Abgleich:**
  - Admin-Portal DB mit Praefrontaler_Cortex verglichen
  - WIN11EP Simone (.213) fehlte - hinzugefügt (VM 21)

- **SSH-Keys auf alle Server deployed:**
  - 4 Server fehlten: stefan (.116), jascha (.150), DASBIEST (.16), kleinerHund (.231)
  - Alle 22 Server jetzt mit Key-Auth erreichbar
  - Office (.253) Key auf alle Server deployed

- **SMB-Shares bereinigt:**
  - Alle 21 Linux-Server geprüft
  - Doppelte Shares entfernt (printers, print$, alte Namen)
  - dns-portal (.216) Pfad von /opt auf / korrigiert
  - Jeder Server hat jetzt nur noch [hostname] Share

- **Mac /etc/hosts aktualisiert:**
  - Fehlende Einträge: tools (.110), simone (.213), kleinerhund (.231), hugo (.248)
  - projekt-15 umbenannt zu manni

- **Mac mount-all-shares.command überarbeitet:**
  - Fehlende Shares hinzugefügt
  - Kaputte Shares entfernt (box_dh, scan_in, simone)
  - dasbiest auf iCloudDrive Share geändert
  - Passwortloses sudo eingerichtet
  - Case-insensitive grep für Mount-Check

- **Avahi auf devoraxx/office konfiguriert** (Kleinschreibung in Finder-Seitenleiste nicht möglich - NetBIOS-Limitation)

---

## Arbeitskontext

**Claude läuft auf:** 192.168.42.230 (Admin-Server) - LOKAL

---

## TODO: Nächste Schritte

- [ ] Beobachten ob Terminal-Disconnects weiterhin auftreten
- [ ] Nächste Windows VM testen ob alles automatisch läuft
- [ ] API Key automatisch auf neue Windows VMs deployen

