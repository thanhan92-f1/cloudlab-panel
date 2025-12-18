#!/bin/bash
# Script: install-php.sh
# Usage: ./install-php.sh <version>

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <php-version>"
  exit 1
fi

echo "[PHP Manager] Installing PHP version $VERSION..."
# Ví dụ cài đặt PHP bằng apt (Debian/Ubuntu)
# sudo apt-get update
# sudo apt-get install -y php$VERSION php$VERSION-fpm php$VERSION-cli
# Hoặc cài đặt theo cách phù hợp với hệ thống của bạn

echo "[PHP Manager] PHP $VERSION installed! (mocked)"
exit 0
