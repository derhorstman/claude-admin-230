# Projekt-Kontext

**Letzte Aktualisierung:** {{DATUM}} (Session 1)

---

## Dieser Server

| Info | Wert |
|------|------|
| Hostname | {{HOSTNAME}} |
| IP | {{IP}} |
| OS | {{OS}} |
| SSH | Port 2222 |
| Funktion | **NOCH NICHT DEFINIERT** |

---

## Netzwerk-Umgebung

Du bist Teil eines Heimnetzwerks mit mehreren Servern. Hier ist deine Nachbarschaft:

### Hyper-V Hosts (Windows)

| Host | IP | Beschreibung |
|------|-----|--------------|
| DASBIEST | 192.168.42.16 | Haupt-Hypervisor, 128 GB RAM |
| kleinerHund | 192.168.42.231 | Zweiter Hypervisor |

### Linux VMs (SSH Port 2222)

| Name | IP | Funktion |
|------|-----|----------|
| Admin-Server | .230 | Zentrales Admin-Portal (FastAPI + SvelteKit) |
| SYSTEMHAUS-001 | .15 | EVY/MIRA AI-System |
| DevoraXx | .214 | Next.js + NestJS Projekt |
| Reverse-Proxy | .254 | Reverse Proxy |
| Webserver | .13 | Apache2, 10+ Domains |
| OpenHAB | .10 | Smart Home |
| Nextcloud | .12 | Cloud + Home Assistant |

### FreeBSD VM

| Name | IP | Funktion |
|------|-----|----------|
| DNS-Server | .216 | Unbound DNS + ISC DHCP für ganzes Netzwerk |

### Netzwerk-Infrastruktur

- **Gateway:** 192.168.42.1 (Fritzbox)
- **DNS/DHCP:** 192.168.42.216 (FreeBSD)
- **Admin-Portal:** http://192.168.42.230

---

## Der Chef

Der User heißt **Dieter** (dieterhorst). Er mag kurze, direkte Antworten ohne Gelaber.

---

## Selbsterhaltung (Gedächtnis-Management)

### Regel: Hippocampus überschaubar halten

Wenn `Hippocampus.md` **> 500 Zeilen** wird:

1. **Komprimieren:** Abgeschlossene Sessions auf 5-10 Zeilen zusammenfassen
2. **Archivieren:** Details nach `/opt/Claude/archiv/` verschieben
3. **Behalten:** Nur die letzten 2-3 Sessions vollständig
4. **Bewahren:** Offene Punkte und Lessons Learned nie löschen

---

## Wichtige Pfade

```
/opt/Claude/                    # Selbsterhaltung & Dokumentation
/opt/Claude/01_START/           # Immer zuerst lesen
```

**REGEL:** Projekte IMMER unter `/opt/` anlegen, NIE unter `/home/`!

---

## SSH zu Nachbarn

```bash
ssh -p 2222 dieterhorst@192.168.42.230  # Admin-Server
ssh -p 2222 dieterhorst@192.168.42.15   # MIRA
ssh -p 2222 dieterhorst@192.168.42.214  # DevoraXx
ssh -p 2222 dieterhorst@192.168.42.254  # Reverse-Proxy
ssh -p 2222 dieterhorst@192.168.42.216  # DNS-Server
```
