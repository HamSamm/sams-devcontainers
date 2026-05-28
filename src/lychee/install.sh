#!/bin/sh
set -e

echo "Installing dependencies..."
if [ -x "$(command -v apt-get)" ]; then
    apt-get update && apt-get install -y curl ca-certificates tar
elif [ -x "$(command -v apk)" ]; then
    apk add --no-cache curl ca-certificates tar
fi

# Get version from options (defined in devcontainer-feature.json)
VERSION=${VERSION:-"latest"}

# Detect architecture
architecture=$(uname -m)
case ${architecture} in
    x86_64)  arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    *) echo "Architecture ${architecture} not supported"; exit 1 ;;
esac

# Download URL
if [ "${VERSION}" = "latest" ]; then
    URL="https://github.com/lycheeverse/lychee/releases/latest/download/lychee-${arch}-unknown-linux-gnu.tar.gz"
else
    URL="https://github.com/lycheeverse/lychee/releases/download/${VERSION}/lychee-${arch}-unknown-linux-gnu.tar.gz"
fi

echo "Downloading Lychee from ${URL}..."
curl -sSL "${URL}" | tar -xz
mv lychee /usr/local/bin/
chmod +x /usr/local/bin/lychee

echo "Lychee $(lychee --version) installed!"
