#!/bin/sh
set -e

echo "Installing dependencies..."
if [ -x "$(command -v apt-get)" ]; then
    apt-get update && apt-get install -y curl ca-certificates tar
elif [ -x "$(command -v apk)" ]; then
    apk add --no-cache curl ca-certificates tar
fi

VERSION=${VERSION:-"latest"}

architecture=$(uname -m)
case ${architecture} in
    x86_64)  arch="x86_64" ;;
    aarch64|arm64) arch="aarch64" ;;
    *) echo "Architecture ${architecture} not supported"; exit 1 ;;
esac

if [ "${VERSION}" = "latest" ]; then
    URL="https://github.com/lycheeverse/lychee/releases/latest/download/lychee-${arch}-unknown-linux-gnu.tar.gz"
else
    URL="https://github.com/lycheeverse/lychee/releases/download/${VERSION}/lychee-${arch}-unknown-linux-gnu.tar.gz"
fi

echo "Downloading Lychee from ${URL}..."
TMP_DIR=$(mktemp -d)
curl -sSL "${URL}" | tar -xz -C "${TMP_DIR}"

if [ -f "${TMP_DIR}/lychee" ]; then
    mv "${TMP_DIR}/lychee" /usr/local/bin/
else
    find "${TMP_DIR}" -name "lychee" -type f -exec mv {} /usr/local/bin/ \;
fi

rm -rf "${TMP_DIR}"

chmod +x /usr/local/bin/lychee
echo "Lychee $(/usr/local/bin/lychee --version) installed!"
