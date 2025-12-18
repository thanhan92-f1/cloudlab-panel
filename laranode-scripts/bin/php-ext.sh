#!/bin/bash
# Script: php-ext.sh
# Usage:
#   ./php-ext.sh <version> list
#   ./php-ext.sh <version> install <extname>
#   ./php-ext.sh <version> remove <extname>

VERSION="$1"
ACTION="$2"
EXTNAME="$3"

if [ -z "$VERSION" ] || [ -z "$ACTION" ]; then
  echo "Usage: $0 <php-version> <list|install|remove> [extension]"
  exit 1
fi

PHP_BIN="php$VERSION"

case "$ACTION" in
  list)
    echo "[PHP Manager] Listing extensions for PHP $VERSION..."
    $PHP_BIN -m
    ;;
  install)
    if [ -z "$EXTNAME" ]; then
      echo "Extension name required for install"
      exit 2
    fi
    echo "[PHP Manager] Installing extension $EXTNAME for PHP $VERSION..."
    # Ví dụ với pecl hoặc apt
    # sudo apt-get install -y php$VERSION-$EXTNAME
    # hoặc sudo $PHP_BIN -d detect_unicode=0 pecl install $EXTNAME
    echo "[PHP Manager] Extension $EXTNAME installed for PHP $VERSION! (mocked)"
    ;;
  remove)
    if [ -z "$EXTNAME" ]; then
      echo "Extension name required for remove"
      exit 2
    fi
    echo "[PHP Manager] Removing extension $EXTNAME for PHP $VERSION..."
    # sudo apt-get remove -y php$VERSION-$EXTNAME
    echo "[PHP Manager] Extension $EXTNAME removed for PHP $VERSION! (mocked)"
    ;;
  *)
    echo "Unknown action: $ACTION"
    exit 3
    ;;
esac
exit 0