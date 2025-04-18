#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
# This is generally safer for a generic script.
set -e

echo "--- General APT/DPKG Repair Script ---"
echo "This script runs common commands to fix broken dependencies and configuration issues."
echo "It may not solve all problems, especially those caused by specific package bugs."
echo "Please monitor the output carefully."
echo "----------------------------------------"
sleep 3

echo
echo "--- Step 1: Updating Package Lists ---"
echo "[INFO] Running apt update..."
sudo apt update

echo
echo "--- Step 2: Attempting to Fix Broken Dependencies ---"
echo "[INFO] Running apt --fix-broken install..."
# This tries to resolve unmet dependencies, download missing packages, etc.
sudo apt --fix-broken install -y

echo
echo "--- Step 3: Attempting to Configure Unconfigured Packages ---"
echo "[INFO] Running dpkg --configure -a..."
# This attempts to run configuration scripts for packages left partially installed.
sudo dpkg --configure -a

echo
echo "--- Step 4: Performing Standard Upgrade ---"
echo "[INFO] Running apt upgrade..."
# Ensures all installed packages are up to the latest version available.
sudo apt upgrade -y

echo
echo "--- Step 5: Removing Unused Packages ---"
echo "[INFO] Running apt autoremove..."
# Cleans up packages installed as dependencies but no longer needed.
sudo apt autoremove -y

echo
echo "--- Step 6: Cleaning Package Cache ---"
echo "[INFO] Running apt clean..."
# Removes downloaded .deb files from /var/cache/apt/archives/
sudo apt clean

echo
echo "--- Step 7: Refreshing Snap and Flatpak ---"
echo "[INFO] Refreshing Snaps..."
# Use || true here as snap/flatpak issues shouldn't halt the script
sudo snap refresh || echo "[WARN] snap refresh encountered an issue."
echo "[INFO] Updating Flatpaks..."
flatpak update -y || echo "[WARN] flatpak update encountered an issue."


echo
echo "--- General Repair Steps Completed ---"
echo "The script has finished. Review the output for any errors."
echo "If problems persist, specific error messages need investigation."

# Exit successfully if we reached here
exit 0

