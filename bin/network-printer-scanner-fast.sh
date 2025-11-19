#!/usr/bin/env bash
# network-printer-scanner-fast.sh
# Scansione rapida: nmap -sn (host up) + porta probe

set -u

RANGE="${1:-}"
if [[ -z "$RANGE" ]]; then
  RANGE="$(ip -o -f inet addr show | awk '/scope global/ {print $4; exit}')"
  : ${RANGE:=192.168.1.0/24}
fi

if ! command -v nmap >/dev/null 2>&1; then
  echo "nmap non trovato. Installa nmap." >&2
  exit 1
fi

nmap -sn "$RANGE" -oG - | awk '/Up$/{print $2}' | while read -r ip; do
  # quick port check
  nc -z -w2 "$ip" 631 515 9100 2>/dev/null && echo "$ip: possibile servizio di stampa"
done
