# 🎧 Bluetooth Notification and volume OSD for GNOME

Un script Bash léger qui apporte une intégration "Premium" pour vos périphériques Bluetooth sous GNOME. 

Il surveille les connexions/déconnexions et affiche un **OSD (On-Screen Display)** dynamique avec le nom et l'icône réelle de votre appareil lors du changement de volume.

## ✨ Fonctionnalités
- **Notifications natives** : Affiche une notification lors de la connexion/déconnexion (avec icône de l'appareil).
- **OSD Dynamique** : Affiche une barre de volume personnalisée (Nom + Icône + Niveau).
- **Intelligent** : L'OSD ne s'active *que* si un appareil Bluetooth est connecté (évite les doublons avec le son système).
- **Service Utilisateur** : Géré par `systemd`, se lance automatiquement à l'ouverture de session.

## 🛠 Prérequis
- **GNOME Shell**
- **Extension Custom-OSD** : [neuromorph/custom-osd](https://github.com/neuromorph/custom-osd) (indispensable pour l'affichage visuel).
- **Dépendances** : `pactl` (PulseAudio/Pipewire), `bluetoothctl`, `bc`.

## 🚀 Installation rapide

1. Clonez le dépôt :
   ```bash
   git clone [https://github.com/ToFpon/bt-osd.git](https://github.com/ToFpon/bt-osd.git)
   cd bt-osd
   
2. Lancez l'installateur :
   ```bash
   chmod +x install.sh
   ./install.sh
