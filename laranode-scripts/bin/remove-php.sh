#!/bin/bash
# Script: remove-php.sh
# Usage: ./remove-php.sh <version>

VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "Usage: $0 <php-version>"
  exit 1
fi

echo "[PHP Manager] Removing PHP version $VERSION..."
# Ví dụ gỡ bỏ PHP bằng apt (Debian/Ubuntu)
# sudo apt-get remove -y php$VERSION php$VERSION-fpm php$VERSION-cli
# Hoặc gỡ bỏ theo cách phù hợp với hệ thống của bạn

echo "[PHP Manager] PHP $VERSION removed! (mocked)"
exit 0
