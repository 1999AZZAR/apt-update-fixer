#!/bin/bash

# Removed set -e to allow continuing past initial errors

echo "--- APT/DPKG Repair Script (v2) ---"
echo "This script will attempt to fix configuration issues, focusing on python3."
echo "Allowing initial configuration steps to fail to proceed with reinstallations."
echo "Please monitor the output carefully."
echo "---------------------------------"
sleep 3

echo
echo "--- Step 1: Attempting standard fixes (again) ---"
echo "[INFO] Running apt update..."
sudo apt update || echo "[WARN] apt update failed, continuing..."
echo "[INFO] Running apt --fix-broken install (will likely fail, continuing)..."
sudo apt --fix-broken install -y || echo "[WARN] apt --fix-broken install failed as expected, continuing..."

echo
echo "--- Step 2: Attempting configuration run (will likely fail, continuing) ---"
echo "[INFO] Running dpkg --configure -a..."
sudo dpkg --configure -a || echo "[WARN] dpkg configure failed as expected, proceeding..."

echo
echo "--- Step 3: Force Reinstalling packages mentioned in py3clean errors ---"
echo "[INFO] Reinstalling dput, gobject-introspection-bin, python3-intelhex, rhythmbox-plugin-alternative-toolbar..."
# Force reinstall these packages which might fix their dpkg file lists (.list files)
sudo apt install --reinstall dput gobject-introspection-bin python3-intelhex rhythmbox-plugin-alternative-toolbar -y || echo "[WARN] Failed to reinstall one or more packages in Step 3, continuing..."

echo
echo "--- Step 4: Force Reinstalling python3 ---"
echo "[INFO] Reinstalling the main python3 package..."
# Reinstalling python3 after hopefully fixing the hook packages might allow its postinst to succeed.
sudo apt install --reinstall python3 -y || echo "[WARN] Failed to reinstall python3 in Step 4. If this failed, the core issue likely persists."

echo
echo "--- Step 5: Final Configuration Attempt ---"
echo "[INFO] Running dpkg --configure -a again. This *needs* to work now."
# This is the crucial test after the reinstallations.
sudo dpkg --configure -a
DPKG_EXIT_CODE=$? # Capture the exit code

if [ $DPKG_EXIT_CODE -eq 0 ]; then
    echo "[SUCCESS] dpkg configure completed successfully in Step 5!"
else
    echo "[ERROR] dpkg configure failed again in Step 5 (Exit Code: $DPKG_EXIT_CODE). The python3 issue persists."
    echo "[INFO] This indicates a deeper problem, possibly needing manual debug of /var/lib/dpkg/info/python3.postinst or a bug report."
    # We'll continue to cleanup steps anyway, but the core issue remains.
fi

echo
echo "--- Step 6: Final System Update and Cleanup (Attempting regardless of Step 5 outcome) ---"
echo "[INFO] Running full system upgrade..."
sudo apt upgrade -y || echo "[WARN] apt upgrade failed."
echo "[INFO] Running autoremove to clean up dependencies..."
sudo apt autoremove -y || echo "[WARN] apt autoremove failed."

echo
echo "--- Step 7: Snap and Flatpak Refresh ---"
echo "[INFO] Refreshing Snaps..."
sudo snap refresh || echo "[WARN] snap refresh failed."
echo "[INFO] Updating Flatpaks..."
flatpak update -y || echo "[WARN] flatpak update failed."

echo
echo "--- All Steps Completed ---"
echo "The repair script (v2) has finished. Please review the output above carefully."
if [ $DPKG_EXIT_CODE -ne 0 ]; then
    echo "[FINAL STATUS: FAILED] The core python3 configuration issue likely remains unresolved after forced reinstalls."
else
    echo "[FINAL STATUS: SUCCESS] It appears the configuration issues were resolved."
fi
echo "Also, remember to address the libXm errors later if they persist:"
echo "  Find package: dpkg -S /lib/x86_64-linux-gnu/libXm.so.4"
echo "  Reinstall: sudo apt install --reinstall <package_name>"

# Exit with the status of the critical configuration step
exit $DPKG_EXIT_CODE
