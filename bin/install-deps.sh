#!/usr/bin/env bash
# install-deps.sh
# Installa le dipendenze su Debian/Ubuntu (Mint) o OpenSUSE

set -e

if [[ $EUID -ne 0 ]]; then
  echo "Esegui come root o con sudo: sudo $0"
  exit 1
fi

. /etc/os-release || true
if [[ "$ID_LIKE" == *"debian"* || "$ID" == "debian" || "$ID" == "ubuntu" || "$ID" == "linuxmint" ]]; then
  apt update
  apt install -y nmap smbclient cups-bsd zenity iproute2 netcat-openbsd
  echo "Installazione completata su Debian/Ubuntu-based"
elif [[ "$ID_LIKE" == *"suse"* || "$ID" == "opensuse" ]]; then
  zypper refresh
  zypper install -y nmap samba-client cups-client zenity iproute2 netcat
  echo "Installazione completata su OpenSUSE"
else
  echo "Distribuzione non riconosciuta. Installa manualmente: nmap, smbclient, cups-client, zenity"
fi
