#!/usr/bin/env bash
# network-printer-scanner.sh
# Scanner completo per stampanti di rete (Samba / IPP / LPD)
# Usage: network-printer-scanner.sh [--range 192.168.1.0/24] [--export csv]

set -u

PROG=$(basename "$0")
RANGE=""
EXPORT=""
TIMEOUT=3

usage(){
  cat <<EOF
Usage: $PROG [--range CIDR] [--export csv|txt] [--fast]

Options:
  --range CIDR   Intervallo da scansionare (es. 192.168.1.0/24). Default: rilevamento interfaccia attiva.
  --export fmt   Esporta risultati in csv o txt
  --fast         Usa la modalità rapida (meno probe)
  -h,--help      Mostra questo aiuto
EOF
}

# Simple distro helper to find commands
cmd_exists(){ command -v "$1" >/dev/null 2>&1; }

# Default range: try to detect local network via ip route
detect_range(){
  # Rileva TUTTE le interfacce con IP globali e restituisce una lista CIDR
  mapfile -t cidrs < <(ip -o -f inet addr show | awk '/scope global/ {print $4}')
  if [[ ${#cidrs[@]} -eq 0 ]]; then
    echo "192.168.1.0/24"   # fallback
  else
    printf "%s
" "${cidrs[@]}"
  fi
}
}

# scan hosts with nmap for ports 631 (IPP), 515 (LPD), 9100 (JetDirect)
scan_with_nmap(){
  local range=$1
  local fast=$2
  local ports
  ports="-p 631,515,9100"
  if [[ "$fast" == "1" ]]; then
    nmap -sn "$range" -oG - | awk '/Up$/{print $2}'
  else
    nmap $ports --open -oG - "$range" | awk '/Ports:/{print $2" " $0}'
  fi
}

# Query samba shares/printers using smbclient
query_samba(){
  local host=$1
  if cmd_exists smbclient; then
    smbclient -L "//$host" -N 2>/dev/null | sed -n '/Printer/,$p'
  fi
}

# Check IPP/LPD via curl or netcat
check_ipp(){
  local host=$1
  if cmd_exists curl; then
    curl -s --connect-timeout $TIMEOUT "http://$host:631/printers/" 2>/dev/null | head -n1
  fi
}

# Main
main(){
  local fast=0
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --range) RANGE="$2"; shift 2;;
      --export) EXPORT="$2"; shift 2;;
      --fast) fast=1; shift;;
      -h|--help) usage; exit 0;;
      *) echo "Unknown: $1"; usage; exit 1;;
    esac
  done

  if [[ -z "$RANGE" ]]; then
    RANGE=$(detect_range)
    echo "Intervallo rilevato: $RANGE"
  fi

  if ! cmd_exists nmap; then
    echo "Errore: nmap non è installato. Esegui install-deps.sh o installa nmap." >&2
    exit 2
  fi

  echo "Eseguo la scansione (this may take a while)..."
  mapfile -t hosts < <(scan_with_nmap "$RANGE" "$fast")

  results=()
  for line in "${hosts[@]}"; do
    # line may contain IP or more info
    ip=$(echo "$line" | awk '{print $1}')
    if [[ -z "$ip" ]]; then
      continue
    fi
    samba=$(query_samba "$ip" 2>/dev/null)
    ipp=$(check_ipp "$ip" 2>/dev/null)
    results+=("$ip|$samba|$ipp")
  done

  # Output
  if [[ "$EXPORT" == "csv" ]]; then
    outfile="printers-$(date +%F_%H%M).csv"
    printf 'ip,samba,ipp\n' > "$outfile"
    for r in "${results[@]}"; do
      IFS='|' read -r ip samba ipp <<< "$r"
      echo "\"$ip\",\"${samba//\"/'}\",\"${ipp//\"/'}\"" >> "$outfile"
    done
    echo "Esportato in $outfile"
  else
    printf "%s\n" "${results[@]}"
  fi
}

main "$@"
