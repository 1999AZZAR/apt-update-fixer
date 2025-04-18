# APT/DPKG Repair Scripts

A collection of scripts designed to help resolve common and specific issues with the APT and DPKG package management system on Debian/Ubuntu-based Linux distributions. These can be useful when encountering errors during `apt update`, `apt upgrade`, or when packages are left in a broken or unconfigured state.

## Scripts Included

1.  **`general-apt-repair`** (Installed from `general-apt-repair.sh`)
    *   **Purpose:** Runs a standard sequence of commands (`apt update`, `apt --fix-broken install`, `dpkg --configure -a`, `apt upgrade`, `apt autoremove`, `apt clean`) to attempt fixing common package management problems like broken dependencies or partially configured packages.
    *   **When to use:** **This is usually the first script to try** when you encounter general `apt` or `dpkg` errors.

2.  **`apt-dpkg-repair`** (Installed from `repair_system.sh`)
    *   **Purpose:** A more **targeted** script designed to fix a *specific* issue where the `python3` package fails to configure due to `py3clean` hook errors (often showing "cannot get content of ..." messages for specific packages like `dput`, `gobject-introspection-bin`, etc.). It does this by forcing the reinstallation of `python3` and the packages known to cause issues with that specific hook.
    *   **When to use:** **Only use this script if you encounter the specific `python3` post-installation configuration errors mentioned above.** Using it for unrelated problems is unlikely to help and might perform unnecessary reinstalls.

## Prerequisites

*   A Debian or Ubuntu-based Linux distribution (e.g., Debian, Ubuntu, Mint, Pop!\_OS).
*   `sudo` privileges are required to run the installation and the repair scripts.
*   `git` installed (to clone this repository).

## Installation

The included `install.sh` script will copy the repair scripts to `/usr/local/sbin`, making them available system-wide when run with `sudo`.

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/1999AZZAR/apt-update-fixer.git apt-update-fixer
    ```

2.  **Navigate into the directory:**
    ```bash
    cd apt-update-fixer
    ```

3.  **Run the installation script:**
    ```bash
    sudo ./install.sh
    ```

The installer will copy the scripts, set appropriate ownership (root:root), and make them executable.

## Usage

After successful installation, you can run the scripts from any terminal location using `sudo`:

*   **For general APT/DPKG issues:**
    ```bash
    sudo general-apt-repair
    ```

*   **For the specific `python3`/`py3clean` configuration error:**
    ```bash
    sudo apt-dpkg-repair
    ```

Monitor the output of the scripts carefully for any errors or warnings.

## Disclaimer

⚠️ **Use these scripts with caution!** ⚠️

*   These scripts execute system commands with `sudo` privileges and directly interact with your system's package manager.
*   While designed to fix common problems, there's always a risk when modifying system configurations. Incorrect use or unforeseen circumstances could potentially lead to further issues.
*   Always ensure you have **backups of important data** before running system repair tools.
*   Understand the difference between the `general-apt-repair` and the targeted `apt-dpkg-repair` script and use them appropriately.

These scripts are provided "as is" without warranty of any kind. The authors or contributors are not responsible for any damage caused by their use.
