#!/bin/sh
set -e

echo "Checking for curl and tar..."
if [ -x "$(command -v apt-get)" ]; then
    apt-get update && apt-get install -y curl ca-certificates tar
elif [ -x "$(command -v apk)" ]; then
    apk add --no-cache curl ca-certificates tar
fi

architecture=$(uname -m)
case ${architecture} in
    x86_64)  arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    *) echo "Architecture ${architecture} not supported"; exit 1 ;;
esac

VERSION=${VERSION:-"latest"}
if [ "${VERSION}" = "latest" ]; then
    URL="https://github.com/lycheeverse/lychee/releases/latest/download/lychee-${arch}-unknown-linux-gnu.tar.gz"
else
    URL="https://github.com/lycheeverse/lychee/releases/download/${VERSION}/lychee-${arch}-unknown-linux-gnu.tar.gz"
fi

echo "Downloading Lychee from ${URL}..."

TMP_DIR=$(mktemp -d)

curl -sSLf "${URL}" | tar -xz -C "${TMP_DIR}"

BIN_PATH=$(find "${TMP_DIR}" -name "lychee" -type f | head -n 1)

if [ -n "${BIN_PATH}" ]; then
    echo "Found binary at ${BIN_PATH}, moving to /usr/local/bin"
    mv "${BIN_PATH}" /usr/local/bin/lychee
    chmod +x /usr/local/bin/lychee
else
    echo "ERROR: Could not find lychee binary in the downloaded archive."
    # List files to debug if it fails again
    ls -R "${TMP_DIR}"
    exit 1
fi

rm -rf "${TMP_DIR}"
echo "Verifying installation..."
/usr/local/bin/lychee --version
echo "Lychee installation complete!"
