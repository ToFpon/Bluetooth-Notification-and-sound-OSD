# 🎧 Bluetooth Notification and Volume OSD for GNOME

A lightweight Bash script that provides "Premium" integration for your Bluetooth devices under GNOME. 

It monitors connections/disconnections and displays a dynamic **OSD (On-Screen Display)** with the name and actual icon of your device when changing volume.

## ✨ Features
- **Native notifications**: Shows notification when connecting/disconnecting (with device icon).
- **Dynamic OSD**: Displays a custom volume bar (Name + Icon + Level).
- **Smart**: OSD only activates if a Bluetooth device is connected (avoids duplication with system sound).
- **User Service**: Managed by `systemd`, launches automatically upon login.

## 🛠 Prerequisites
- **GNOME Shell**
- **Custom-OSD extension**: [neuromorph/custom-osd](https://github.com/neuromorph/custom-osd) (essential for visual display).
- **Dependencies**: 
   ```bash
   sudo apt install pulseaudio-utils bluetoothctl bc
   ```
## 🚀 Quick installation

1. Clone the repository:
   ```bash
   git clone [https://github.com/ToFpon/bt-osd.git](https://github.com/ToFpon/bt-osd.git)
   cd bt-osd

2. Lancez l'installateur :
   ```bash
   chmod +x install.sh
   ./install.sh
