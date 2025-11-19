# network-printer-browser
Network Printer Browser v1.0

# 🖨️ Stampanti di Rete – Scanner & Integration per Linux
Scanner avanzato per stampanti di rete (Samba, IPP, LPD, JetDirect) con integrazione nei Desktop Environment Linux
(KDE Plasma, GNOME, Cinnamon, MATE) e strumenti di aggiunta stampanti tramite GUI.

Compatibile con:
- **OpenSUSE (Leap/Tumbleweed)**
- **Linux Mint / Ubuntu / Debian**

---

## ✨ Funzionalità principali

### 🔍 Scansione di rete
- Rilevamento automatico di **tutte le sottoreti attive** della macchina (anche VLAN o reti interne senza accesso Internet).
- Scansione porte comuni di stampa:
  - **631** (IPP)
  - **515** (LPD)
  - **9100** (JetDirect)
- Individuazione stampanti **Samba** tramite `smbclient`.

### ⚡ Modalità “Fast”
Scanner leggero che usa `nmap -sn` + controllo porte, utile in reti grandi.

### 🖥️ Integrazione nei Desktop Environment
- Aggiunge voce **“Stampanti di Rete”** nel menu applicazioni.
- Usa le **icone di sistema** (`printer-network`, `printer`, ecc.).
- In base al DE lancia automaticamente:
  - **KDE Plasma:** `systemsettings5 kcm_printer_manager`
  - **GNOME / Mint Cinnamon / MATE:** `system-config-printer`
  - Se il DE non ha un gestore proprio → apre la GUI Zenity del progetto.

### 🖱️ Aggiunta stampanti con 1 click
Un helper (`gui-add-printer.sh`) permette:
- aggiunta stampante IPP/LPD/Samba tramite GUI nativa,
- oppure aggiunta tramite `lpadmin` (previa conferma).

### 📦 Installer dipendenze
Automatizza l’installazione delle dipendenze:
- `nmap`, `smbclient`, `cups-bsd`, `cups-client`, `zenity`, `netcat`, ecc.

### 🔄 (Opzionale) Aggiornamento periodico
Timer systemd user-level per aggiornare la cache locale delle stampanti.

---

## 📁 Struttura del progetto

network-printer-browser/

├── bin/

│ ├── network-printer-scanner.sh

│ ├── network-printer-scanner-fast.sh

│ ├── network-printers-gui.sh

│ ├── cartella-stampanti.sh

│ ├── gui-add-printer.sh

│ ├── network-printers-launcher.sh

│ └── install-deps.sh

│

├── desktop/

│ └── network-printers.desktop

│

├── systemd/

│ └── user/

│ ├── network-printers-refresh.service

│ └── network-printers-refresh.timer

│

├── docs/

│ └── USAGE.md

│

├── LICENSE

└── README.md

---

## 🚀 Installazione

### 1️⃣ Installare le dipendenze
sudo ./bin/install-deps.sh

---

## 2️⃣ Installare la voce nel menu (consigliato)

### Installazione per utente:
./bin/network-printers-integration.sh user

### Installazione di sistema:
sudo ./bin/network-printers-integration.sh system

Dopo l’installazione troverai una nuova voce nel menu:

**🖨️ Stampanti di Rete**

---

## 🏃‍♂️ Uso da terminale

### Scansione standard:
./bin/network-printer-scanner.sh

### Scansione veloce:
./bin/network-printer-scanner-fast.sh

### Scansione di una rete specifica:
./bin/network-printer-scanner.sh --range 10.0.0.0/24

### Esportazione CSV:
./bin/network-printer-scanner.sh --export csv

---

## 🖥️ Uso tramite GUI


Permette di:
- inserire range
- avviare scansione
- vedere risultati
- cliccare “Aggiungi stampante” → apertura GUI nativa

---

## 🧠 Funzionamento tecnico (in breve)

- Individuazione subnet tramite:
ip -o -f inet addr show | awk '/scope global/ {print $4}'
- Scansione con `nmap`:
- modalità completa: porte 631, 515, 9100
- modalità veloce: solo host attivi
- Rilevamento stampanti Samba:
smbclient -L //IP -N
- Verifica IPP via HTTP:
curl http://IP:631/printers/

---

## 🔄 (Opzionale) Attivare timer systemd user

systemctl --user enable --now network-printers-refresh.timer

Aggiorna periodicamente:
`~/.cache/network-printers/last-scan.txt`

---

## 📝 Licenza
Questo progetto è rilasciato sotto licenza **MIT**.
Puoi modificarlo, integrarlo ed estenderlo liberamente.

---

## 🙌 Contributi
Pull request e miglioramenti sono benvenuti!
Particolarmente utili:
- nuove GUI,
- supporto per XFCE, LXDE, Enlightenment,
- supporto Bonjour/mDNS (Avahi).

---

## 🇮🇹 Autore
Progetto creato per semplificare la vita agli utenti Linux
che usano stampanti in rete miste (Windows/Samba, Linux, dispositivi embedded).

Se avete consigli o modifiche da proporre al codice, sono ben accetti, migliorare è sempre una buona cosa.
