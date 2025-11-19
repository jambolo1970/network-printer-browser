# 📜 CHANGELOG — Stampanti di Rete

Tutte le modifiche al progetto sono elencate in ordine cronologico inverso.

---

## [1.0.0] – 2025-01-01
### Added
- Rilevamento automatico di tutte le subnet tramite `ip -o addr`.
- Scansione IPP/LPD/JetDirect con nmap.
- Rilevamento stampanti Samba via `smbclient`.
- Modalità “fast” per reti grandi (solo host attivi).
- Interfaccia grafica Zenity.
- Script GUI per aggiunta stampanti (supporto KDE/GNOME/MATE/Cinnamon).
- Launcher intelligente basato su Desktop Environment.
- File desktop `network-printers.desktop` per integrazione menu.
- Installer di dipendenze per OpenSUSE e Linux Mint.
- Timer systemd user-level per aggiornamento periodico.
- Export CSV e JSON.
- Messaggi formattati migliorati (colori, sezioni).
- Gestione errori più robusta (IP mancanti, Samba down, etc.)
- Documentazione:
  - README.md completo
  - USAGE.md
  - CHANGELOG.md

### Changed
- Rimosso range IP hardcoded (192.168.1.0/24).
- Migliorata compatibilità tra distro e DE.
- Unified logging e output coerente tra gli script.
- Ottimizzata scansione LPD/IPP (ridotti timeout).
- Refactoring generale per struttura modulare.

### Fixed
- Funzione `detect_range()` ora funziona con più interfacce e VLAN.
- Corretto parsing output nmap su sistemi non-italiani.
- Fix per `smbclient` che restituiva errori silenziosi.
- Corretta icona del launcher su Mint Cinnamon.

---

## [0.9.0] – 2024
Versione prototipo (non pubblica):
- primi script bash indipendenti
- scansione base con `nmap`
- rilevamento Samba minimale
- primi tentativi GUI
- versione separata per OpenSUSE e Linux Mint

---

## Formato
Seguendo le linee guida “Keep a Changelog”:
<https://keepachangelog.com/en/1.1.0/>


