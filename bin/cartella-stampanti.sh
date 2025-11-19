#!/usr/bin/env bash
# cartella-stampanti.sh
# Elenca stampanti locali conosciute e fonti samba

if command -v lpstat >/dev/null 2>&1; then
  echo "Stampanti locali:";
  lpstat -p -d || echo "nessuna stampante locale rilevata"
fi

if command -v smbclient >/dev/null 2>&1; then
  echo; echo "Stampanti Samba (scansione rapida hosts nella subnet):"
  # get local network
  net=$(ip -o -f inet addr show | awk '/scope global/ {print $4; exit}')
  if [[ -n "$net" ]]; then
    hosts=$(nmap -sn "$net" -oG - | awk '/Up$/{print $2}')
    for h in $hosts; do
      echo "-- $h --"
      smbclient -L "//$h" -N 2>/dev/null | sed -n '/Printer/,$p' || true
    done
  else
    echo "Impossibile determinare la rete locale"
  fi
fi
