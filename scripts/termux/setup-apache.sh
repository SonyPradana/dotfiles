#!/data/data/com.termux/files/usr/bin/bash

pkg up -y
pkg install apache2 -y

apachectl start

# Enable Apache to start on boot
if [ ! -d "$PREFIX/etc/init.d" ]; then
  mkdir -p "$PREFIX/etc/init.d"
fi
ln -sf "$PREFIX/bin/apachectl" "$PREFIX/etc/init.d/apache2"

mkdir -p "$HOME/www"

APACHE_CONF="$HOME/.config/apache/termux_httpd.conf"
TARGET_CONF="$PREFIX/etc/apache2/httpd.conf"
BACKUP_CONF="$PREFIX/etc/apache2/backup_httpd.conf"

if [ -f "$APACHE_CONF" ]; then
  if [ -f "$TARGET_CONF" ]; then
    cp "$TARGET_CONF" "$BACKUP_CONF"
    echo "Backup konfigurasi asli disimpan di: $BACKUP_CONF"
  fi

  cp "$APACHE_CONF" "$TARGET_CONF"
  echo "Konfigurasi baru disalin ke: $TARGET_CONF"
fi

apachectl restart

echo "Apache berhasil diinstal, dikonfigurasi, dan dijalankan.\n"