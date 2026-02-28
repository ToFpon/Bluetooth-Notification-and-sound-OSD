#!/usr/bin/env bash

# Fichiers temporaires pour partager les infos entre les boucles
BT_NAME_FILE="/tmp/current_bt_name"
BT_ICON_FILE="/tmp/current_bt_icon"
# Chemin des schémas pour ton extension custom-osd
SCHEMA_PATH="$HOME/.local/share/gnome-shell/extensions/custom-osd@neuromorph/schemas"

# Nettoyage au démarrage
rm -f "$BT_NAME_FILE" "$BT_ICON_FILE"

# --- 1. SURVEILLANCE DU VOLUME (OSD Dynamique avec filtre anti-flood) ---
(
    LAST_VOL="-1" # Mémoire pour éviter le flood
    pactl subscribe | while read -r event; do
        if [[ -f "$BT_NAME_FILE" ]]; then
            if echo "$event" | grep -Ei -q "changement|change" && echo "$event" | grep -Ei -q "destination|sink|carte|card"; then
                
                # Récupération du volume actuel
                vol_percent=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '[0-9]+(?=% )' | head -1)
                [[ -z "$vol_percent" ]] && vol_percent=0
                
                # --- LE FILTRE : On n'affiche QUE si le volume a vraiment changé ---
                if [[ "$vol_percent" != "$LAST_VOL" ]]; then
                    level=$(echo "scale=2; $vol_percent / 100" | bc)
                    
                    display_name=$(cat "$BT_NAME_FILE" 2>/dev/null || echo "Volume")
                    display_icon=$(cat "$BT_ICON_FILE" 2>/dev/null || echo "audio-volume-medium-symbolic")
                    
                    GSETTINGS_SCHEMA_DIR="$SCHEMA_PATH" gsettings set org.gnome.shell.extensions.custom-osd showosd \
                        "$RANDOM,$display_icon,$display_name,$level"
                    
                    # On met à jour la mémoire
                    LAST_VOL="$vol_percent"
                fi
            fi
        fi
    done
) &

# --- 2. SURVEILLANCE BLUETOOTH (Lola) ---
LAST_STATE=""

echo "Lola surveille tes périphériques... (Même les parapluies !)"

while true; do
    current_list=$(bluetoothctl devices Connected 2>/dev/null | sed -re 's/^Device ([^ ]+) (.*)$/\1|\2/')
    
    if [[ "$current_list" != "$LAST_STATE" ]]; then
        
        while read -r line; do
            [[ -z "$line" ]] && continue
            mac="${line%%|*}"
            name="${line#*|}"
            
            if [[ "$LAST_STATE" != *"$mac"* ]]; then
                # Extraction de l'icône du périphérique
                icon_name=$(bluetoothctl info "$mac" | awk -F': ' '/Icon:/ {print $2}')
                [[ -z "$icon_name" ]] && icon_name="bluetooth"
                
                # On enregistre les infos pour l'OSD
                echo "$name" > "$BT_NAME_FILE"
                echo "$icon_name-symbolic" > "$BT_ICON_FILE" # On ajoute -symbolic pour le look GNOME

                notify-send --icon="$icon_name" "Bluetooth" "<b>$name</b>\nConnecté" -a Bluetooth -e -u normal
            fi
        done <<< "$current_list"

        while read -r line; do
            [[ -z "$line" ]] && continue
            mac="${line%%|*}"
            name="${line#*|}"
            
            if [[ "$current_list" != *"$mac"* ]]; then
                # On nettoie tout
                rm -f "$BT_NAME_FILE" "$BT_ICON_FILE"
                
                notify-send --icon=bluetooth-disabled "Bluetooth" "<b>$name</b>\nDéconnecté" -a Bluetooth -e -u normal
            fi
        done <<< "$LAST_STATE"

        LAST_STATE="$current_list"
    fi

    sleep 1
done
