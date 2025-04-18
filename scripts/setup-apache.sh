#!/bin/bash

# Update and upgrade packages
pkg up -y

# Install Apache
pkg install apache2 -y

# Start Apache service
apachectl start

# Enable Apache to start on boot
if [ ! -d "$PREFIX/etc/init.d" ]; then
  mkdir -p "$PREFIX/etc/init.d"
fi
ln -sf "$PREFIX/bin/apachectl" "$PREFIX/etc/init.d/apache2"

# Set up webroot directory
WEBROOT="$HOME/www"
if [ ! -d "$WEBROOT" ]; then
  mkdir -p "$WEBROOT"
fi

# Update Apache configuration to use custom webroot and port
APACHE_CONF="$PREFIX/etc/apache2/httpd.conf"
sed -i 's|^DocumentRoot ".*"|DocumentRoot "$WEBROOT"|' "$APACHE_CONF"
sed -i 's|^<Directory ".*">|<Directory "$WEBROOT">|' "$APACHE_CONF"
sed -i 's|^Listen 80|Listen 8000|' "$APACHE_CONF"

# Restart Apache to apply changes
apachectl restart

echo "Apache berhasil diinstal dan dikonfigurasi. Webroot disetel ke $WEBROOT dan dapat diakses di port 8000."