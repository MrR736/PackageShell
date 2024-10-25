#!/bin/bash

COMMAND_NAME="Package Name"
SCRIPTS_BIN="/usr/bin/pn"
SCRIPTS_FOLDER="/usr/scripts/PackageName"

if [ "$(whoami)" != "root" ]; then
    echo -e "\e[31mE: You have to run as Superuser\e[0m"
    exit 1
fi

if [[ ! -e "$SCRIPTS_BIN" ]]; then
    echo "$COMMAND_NAME is Not Install, so Cancelling Removed."
    exit 1
else
    if ! command -v rm &> /dev/null; then
        echo -e "\e[31mE: rm Is Not Installed.\e[0m"
        exit 1
    else
        echo "Remove $COMMAND_NAME..."
        rm -rf "$SCRIPTS_BIN" "$SCRIPTS_FOLDER"
    fi
fi
