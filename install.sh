#!/usr/bin/env bash

# Couleurs pour le terminal
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Installation de BT-OSD (Lola)...${NC}"

# 1. Création des dossiers si nécessaire
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/systemd/user"

# 2. Copie du script principal
cp btnot.sh "$HOME/.local/bin/btnot.sh"
chmod +x "$HOME/.local/bin/btnot.sh"
echo -e "${GREEN} -> Script copié dans ~/.local/bin/${NC}"

# 3. Création du fichier service systemd
cat <<EOF > "$HOME/.config/systemd/user/btnot.service"
[Unit]
Description=Service de notification Bluetooth et OSD Volume (Lola)
After=bluetooth.target

[Service]
ExecStart=$HOME/.local/bin/btnot.sh
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

echo -e "${GREEN} -> Service systemd créé.${NC}"

# 4. Activation du service
systemctl --user daemon-reload
systemctl --user enable btnot.service
systemctl --user restart btnot.service

echo -e "${BLUE}Installation terminée ! Lola surveille maintenant tes périphériques.${NC}"
