#!/bin/sh
set -e

INSTALL_TEMP_DIR="/tmp/lychee-installer"
mkdir -p "${INSTALL_TEMP_DIR}"
cd "${INSTALL_TEMP_DIR}"

if ! type curl > /dev/null 2>&1; then
    apt-get update && apt-get install -y curl ca-certificates
fi

echo "Downloading and installing Lychee..."
curl -sSfL https://raw.githubusercontent.com/lycheeverse/lychee/master/scripts/get-lychee.sh | sh -s -- --dest /usr/local/bin

rm -rf "${INSTALL_TEMP_DIR}"

echo "Lychee installed successfully to /usr/local/bin"