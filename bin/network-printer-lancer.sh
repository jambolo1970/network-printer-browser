#!/usr/bin/env bash
# network-printers-launcher.sh
# Controlla dipendenze, prepara il sistema, e lancia la GUI.

set -e

PROJECT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

check_dep() {
    local pkg="$1"
    if ! command -v "$pkg" >/dev/null 2>&1; then
        echo "$pkg MANCANTE"
        return 1
    fi
    return 0
}

install_dep() {
    local pkg="$1"

    # OpenSUSE
    if command -v zypper >/dev/null; then
        sudo zypper install -y "$pkg" || true
        return
    fi

    # Mint/Ubuntu/Debian
    if command -v apt >/dev/null; then
        sudo apt install -y "$pkg" || true
        return
    fi

    # No installer found
    echo "⚠️  Non posso installare automaticamente $pkg – installalo manualmente."
}

ensure_dependencies() {
    local deps=( nmap smbclient zenity awk ip )

    echo "🔍 Controllo dipendenze…"
    for d in "${deps[@]}"; do
        if ! check_dep "$d"; then
            echo "➡️ Installazione di $d…"
            install_dep "$d"
        fi
    done

    echo "✓ Dipendenze verificate."
}

prepare_cache() {
    mkdir -p "$HOME/.cache/network-printers"
    touch "$HOME/.cache/network-printers/last-scan.txt"
}

launch_gui() {
    if [[ -x "$PROJECT_DIR/bin/network-printers-gui.sh" ]]; then
        "$PROJECT_DIR/bin/network-printers-gui.sh"
    else
        echo "❌ GUI non trovata: $PROJECT_DIR/bin/network-printers-gui.sh"
        exit 1
    fi
}

main() {
    ensure_dependencies
    prepare_cache
    launch_gui
}

main "$@"
