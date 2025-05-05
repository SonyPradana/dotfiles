#!/data/data/com.termux/files/usr/bin/bash

echo "===> Setup PHP di Termux"
pkg install -y php composer

PHP_INI_SRC="$HOME/.config/php/php.ini"
PHP_INI_DST="$PREFIX/etc/php/php.ini"

mkdir -p "$(dirname "$PHP_INI_DST")"

if [ -f "$PHP_INI_SRC" ]; then
  cp "$PHP_INI_SRC" "$PHP_INI_DST"
  echo "php.ini copied to $PHP_INI_DST"
else
  cat >"$PHP_INI_DST" <<EOF
; Disable php deprecated message
display_errors = On
error_reporting = E_ALL & ~E_DEPRECATED & ~E_USER_DEPRECATED
EOF
fi