#!/bin/bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZZ_BIN="$SCRIPTS_DIR/7zz"

if [ "$(whoami)" != "root" ]; then
    echo "You have to run as Superuser!"
    exit 1
fi

if [[ ! -e "$ZZ_BIN" ]]; then
    echo "7zz is missing from $SCRIPTS_DIR."
    exit 1
fi

# Check for .list files
shopt -s nullglob  # Avoid issues with empty glob results
list_files=("$SCRIPTS_DIR"/Install.list)

if [[ ${#list_files[@]} -eq 0 ]]; then
    echo "E: No List Files found in $SCRIPTS_DIR."
    exit 1
fi

for list_file in "${list_files[@]}"; do
    if [[ ! -s "$list_file" ]]; then
        echo "E: List file $list_file is empty."
        continue
    fi

    INSTALL_FILE=""
    INSTALL_COMMAND_FILE=""
    INSTALL_NAME_FILE=""

    while IFS= read -r line; do
        case "$line" in
            Install=*)
                INSTALL_FILE="${line#Install=}"
                ;;
            Install_Command=*)
                INSTALL_COMMAND_FILE="${line#Install_Command=}"
                ;;
            Install_Name=*)
                INSTALL_NAME_FILE="${line#Install_Name=}"
                ;;
        esac
    done < "$list_file"

    echo "Setting up $INSTALL_NAME_FILE..."

    # Remove files if variables are set

    if [[ -n "$INSTALL_COMMAND_FILE" ]]; then
        rm -rf "$INSTALL_COMMAND_FILE"
    fi

    if $ZZ_BIN x "$SCRIPTS_DIR"/*.7z -O"/" -y > /dev/null; then
        echo "Setup Package successful."
    else
        echo "E: Setup Package failed."
        exit 1
    fi
done
