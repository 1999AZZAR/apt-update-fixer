#!/bin/bash

# --- Installation Script for APT/DPKG Repair Tools ---

# Exit immediately if a command exits with a non-zero status.
set -e

# Define script names and target directory
TARGET_DIR="/usr/local/sbin"
SCRIPT1_SRC="general-apt-repair.sh"
SCRIPT2_SRC="repair_system.sh" # This is the targeted one (v2)

# Define the desired names for the commands once installed
# (Typically without .sh extension for system commands)
SCRIPT1_DEST="general-apt-repair"
SCRIPT2_DEST="apt-dpkg-repair" # The name we used before for the targeted script

# --- Check for root privileges ---
if [[ $EUID -ne 0 ]]; then
   echo "[ERROR] This script must be run as root (e.g., using sudo)."
   echo "        sudo ./install.sh"
   exit 1
fi

# --- Determine Script Directory ---
# Get the absolute path of the directory containing this install.sh script
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "[INFO] Locating scripts in: $SCRIPT_DIR"

# --- Check if source scripts exist ---
if [ ! -f "$SCRIPT_DIR/$SCRIPT1_SRC" ]; then
    echo "[ERROR] Source script not found: $SCRIPT_DIR/$SCRIPT1_SRC"
    exit 1
fi
if [ ! -f "$SCRIPT_DIR/$SCRIPT2_SRC" ]; then
    echo "[ERROR] Source script not found: $SCRIPT_DIR/$SCRIPT2_SRC"
    exit 1
fi

# --- Create target directory if it doesn't exist (unlikely but safe) ---
mkdir -p "$TARGET_DIR"
echo "[INFO] Ensuring target directory exists: $TARGET_DIR"

# --- Install General Repair Script ---
echo "[INFO] Installing $SCRIPT1_SRC as $TARGET_DIR/$SCRIPT1_DEST ..."
cp "$SCRIPT_DIR/$SCRIPT1_SRC" "$TARGET_DIR/$SCRIPT1_DEST"
chown root:root "$TARGET_DIR/$SCRIPT1_DEST"
chmod 755 "$TARGET_DIR/$SCRIPT1_DEST"
echo "[INFO] $SCRIPT1_DEST installed successfully."

# --- Install Targeted Repair Script ---
echo "[INFO] Installing $SCRIPT2_SRC as $TARGET_DIR/$SCRIPT2_DEST ..."
cp "$SCRIPT_DIR/$SCRIPT2_SRC" "$TARGET_DIR/$SCRIPT2_DEST"
chown root:root "$TARGET_DIR/$SCRIPT2_DEST"
chmod 755 "$TARGET_DIR/$SCRIPT2_DEST"
echo "[INFO] $SCRIPT2_DEST installed successfully."

echo
echo "--- Installation Complete ---"
echo "You can now run the repair scripts from anywhere using sudo:"
echo "  sudo $SCRIPT1_DEST  (For general APT/DPKG issues)"
echo "  sudo $SCRIPT2_DEST  (Specifically targets python3/py3clean issues)"
echo "-----------------------------"

exit 0

