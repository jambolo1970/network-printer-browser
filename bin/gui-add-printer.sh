#!/usr/bin/env bash
# gui-add-printer.sh
# Apre il gestore stampanti corretto in base al DE presente.

set -e

detect_de() {
    # Rileva Desktop Environment da variabili comuni
    if [[ $XDG_CURRENT_DESKTOP =~ KDE|KDE5|PLASMA ]]; then
        echo kde
    elif [[ $XDG_CURRENT_DESKTOP =~ GNOME|UNITY ]]; then
        echo gnome
    elif [[ $XDG_CURRENT_DESKTOP =~ MATE ]]; then
        echo mate
    elif [[ $XDG_CURRENT_DESKTOP =~ Cinnamon ]]; then
        echo cinnamon
    else
        echo unknown
    fi
}

open_kde() {
    if command -v systemsettings5 >/dev/null; then
        systemsettings5 kcm_printer_manager &
    elif command -v systemsettings >/dev/null; then
        systemsettings kcm_printer_manager &
    else
        return 1
    fi
}

open_system_config_printer() {
    if command -v system-config-printer >/dev/null; then
        system-config-printer &
    else
        return 1
    fi
}

open_fallback() {
zenity --info \
--title="Aggiunta Stampante" \
--text="Nessun gestore di stampanti è presente nel sistema.\n\n\
Puoi aggiungere una stampante tramite:\n\
1) http://localhost:631/admin  (interfaccia CUPS)\n\
2) Oppure configurazione manuale IPP/LPD/SMB."

}

main() {
    local de
    de=$(detect_de)

    case "$de" in
        kde)
            open_kde && exit 0
            ;;
        gnome|mate|cinnamon)
            open_system_config_printer && exit 0
            ;;
    esac

    # Fallback
    open_fallback
}

main "$@"
