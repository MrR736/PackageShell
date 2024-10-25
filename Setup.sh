#!/bin/bash

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZZ_BIN="$SCRIPTS_DIR/7zz"
Zips_DIR=$SCRIPTS_DIR/*.7z

if [[ ! -e "$SCRIPTS_DIR/Install.list" ]]; then
    echo -e "\e[31mE: Not Found Install.list\e[0m"
    exit 1
fi

if ! command -v $ZZ_BIN &> /dev/null; then
    echo -e "\e[31mE: 7zz Is Not Installed.\e[0m"
    exit 1
fi

if [[ ${#Zips_DIR[@]} -eq 0 ]]; then
    echo -e "\e[31mE: Not Found .7z Files\e[0m"
    exit 1
fi

if [ "$(whoami)" != "root" ]; then
    echo -e "\e[31mE: You have to run as Superuser\e[0m"
    exit 1
fi

# Check for .list files
shopt -s nullglob  # Avoid issues with empty glob results
list_files=($SCRIPTS_DIR/Install.list)

for list_file in "${list_files[@]}"; do
    if [[ ! -s "$list_file" ]]; then
        echo -e "\e[31mE: List File Install.list Is Empty.\e[0m"
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

    echo "Processe Package..."

    for zip_file in $Zips_DIR; do
        Install_Zips="${zip_file#$SCRIPTS_DIR/}"
        if $ZZ_BIN x "$zip_file" -O"/" -y > /dev/null; then
           echo "Extract $Install_Zips Successfully."
        else
           echo -e "\e[31mE: Extract $Install_Zips Is Failed."
           exit 1
        fi
    done

    echo "Setting up $INSTALL_NAME_FILE Is Successfully."
done
