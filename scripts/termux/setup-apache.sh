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

if [ -f "$APACHE_CONF" ]; then
  cp "$APACHE_CONF" "$PREFIX/etc/apache2/httpd.conf"
  echo "Apache configuration copied to $PREFIX/etc/apache2/httpd.conf"
fi

apachectl restart

echo "Apache berhasil diinstal dan dikonfigurasi."