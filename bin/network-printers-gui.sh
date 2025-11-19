#!/usr/bin/env bash
# GUI semplice con zenity

if ! command -v zenity >/dev/null 2>&1; then
  echo "Zenity non installato. Avviare versione CLI: ./network-printer-scanner.sh"
  exit 1
fi

RANGE=$(zenity --entry --title="Intervallo di rete" --text="Inserisci CIDR (es. 192.168.1.0/24)" --entry-text="192.168.1.0/24")
if [[ -z "$RANGE" ]]; then
  zenity --error --text="Intervallo non valido"
  exit 1
fi

# Avvia la scansione in background e mostra un progress dialog semplice
( sleep 0.2
  network-printer-scanner.sh --range "$RANGE" --export txt > /tmp/scan_printers.txt
  echo 100
) | zenity --progress --pulsate --auto-close --title="Scansione stampanti" --text="Scansione in corso..."

if [[ -s /tmp/scan_printers.txt ]]; then
  zenity --text-info --filename=/tmp/scan_printers.txt --width=800 --height=600 --title="Risultati"
else
  zenity --info --text="Nessuna stampante trovata"
fi
