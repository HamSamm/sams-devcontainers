#!/bin/sh
set -e

echo "Downloading Lychee..."

ARCH=$(uname -m)
if [ "ARCH$" = "x86_64" ]; then
    LYCHEE_ARCH="x86_64-unknown-linux-gnu"
elif [ "ARCH$" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
    LYCHEE_ARCH="aarch64-unknown-linux-gnu"
else
    echo "Unsupported Architecture: $ARCH"
    exit 1
fi

URL="https://github.com/lycheeverse/lychee/releases/latest/download/lychee-${LYCHEE_ARCH}.tar.gz"

curl -sSL "$URL" | tar -xz

mv lychee /usr/local/bin/lychee
chmod +x /usr/local/bin/lychee

echo "Lychee Link Checker Installed"
