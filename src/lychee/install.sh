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
    # This finds the redirect URL and extracts the tag (e.g., v0.15.1)
    VERSION=$(curl -sI https://github.com/lycheeverse/lychee/releases/latest | grep -i location | sed 's/.*\/tag\/\(.*\)/\1/' | tr -d '\r')
fi

URL="https://github.com/lycheeverse/lychee/releases/download/${VERSION}/lychee-${VERSION}-${arch}-unknown-linux-gnu.tar.gz"

echo "Downloading Lychee ${VERSION} from ${URL}..."

TMP_DIR=$(mktemp -d)
curl -sSLf "${URL}" | tar -xz -C "${TMP_DIR}"

BIN_PATH=$(find "${TMP_DIR}" -name "lychee" -type f -executable | head -n 1)

if [ -n "${BIN_PATH}" ]; then
    mv "${BIN_PATH}" /usr/local/bin/lychee
    chmod +x /usr/local/bin/lychee
else
    echo "ERROR: Could not find lychee binary in archive"
    exit 1
fi

rm -rf "${TMP_DIR}"
/usr/local/bin/lychee --version
