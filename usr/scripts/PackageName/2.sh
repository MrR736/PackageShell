#!/bin/bash

Scripts_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$(whoami)" != "root" ]
then
  echo "You have to run as Superuser!"
  exit 1
fi

# Check for required binaries
for cmd in echo; do
  if ! command -v "$cmd" &> /dev/null; then
    echo "$cmd is missing!"
    exit 1
  fi
done

echo "2"
