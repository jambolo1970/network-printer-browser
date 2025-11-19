# 📘 USAGE — Stampanti di Rete per Linux

Questo documento descrive come utilizzare tutti gli strumenti del progetto
“Stampanti di Rete”, sia da terminale che da interfaccia grafica.

---

# 🖨️ 1. Scansione della rete

Il comando principale è:

./bin/network-printer-scanner.sh

Il programma:
- rileva automaticamente tutte le subnet del sistema,
- analizza IPP, LPD, JetDirect,
- rileva stampanti Samba,
- genera una lista formattata.

---

## 1.1 Opzioni disponibili

### Scansionare una subnet specifica
./bin/network-printer-scanner.sh --range 192.168.10.0/24

### Esportazione risultati
CSV:
./bin/network-printer-scanner.sh --export csv

JSON:
./bin/network-printer-scanner.sh --export json

### Aumentare verbosità
./bin/network-printer-scanner.sh --verbose

### Usare solo nmap fast (senza scansione porte)
./bin/network-printer-scanner-fast.sh

---

# 🖥️ 2. Interfaccia grafica

Avviare la GUI Zenity:

./bin/network-printers-gui.sh

Permette:
- inserimento range manuale
- scansione completa o veloce
- visualizzazione risultati
- aggiunta stampanti tramite gestore di sistema

---

# ➕ 3. Aggiungere una stampante

Il file helper:

./bin/gui-add-printer.sh

Funziona così:
- rileva automaticamente il Desktop Environment
- apre il tool di gestione stampanti nativo:
  - KDE: **System Settings – Printers**
  - GNOME/MATE/Cinnamon: **system-config-printer**
- se nessun gestore è presente → usa Zenity per configurazione IPP/LPD/Samba

---

# 🔧 4. Installare integrazione con il menu di sistema

Installazione utente:

./bin/network-printers-integration.sh user

Installazione globale:

sudo ./bin/network-printers-integration.sh system

Questo crea:
- file `.desktop`
- icona nel menu (“Stampanti di Rete”)
- launcher DE-aware

---

# 🔄 5. Abilitare timer systemd (opzionale)

Abilitazione:

systemctl --user enable --now network-printers-refresh.timer

Aggiorna periodicamente:

~/.cache/network-printers/last-scan.txt

---

# 🧹 6. Disinstallazione

### Rimuovere integrazione:
./bin/network-printers-integration.sh remove

### Disabilitare timer:
systemctl --user disable --now network-printers-refresh.timer

---

# 📎 7. Note

- Funziona anche su reti interne senza Internet.
- Supporta SMBv1 e SMBv2 (a seconda della configurazione Samba locale).
- Compatibile con firewall locali se si permettono:
  - 631 TCP
  - 515 TCP
  - 9100 TCP
  - SMB TCP/UDP 137–139, 445

---

# 🆘 8. Problemi comuni

### 🔸 Nessuna stampante trovata
Probabile firewall attivo:

sudo ufw allow 631
sudo ufw allow 515
sudo ufw allow 9100

### 🔸 Samba non rileva stampanti Windows
Verificare manualmente:

smbclient -L //IP-DELLA-STAMPANTE -N

### 🔸 Nessuna GUI si apre
Installare Zenity:

sudo zypper install zenity
sudo apt install zenity

---

# ✔️ Fine
Per maggiori dettagli consultare `README.md`.

