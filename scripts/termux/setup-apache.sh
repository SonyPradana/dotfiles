#!/data/data/com.termux/files/usr/bin/bash

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

# Add ServerName localhost to Apache configuration
if ! grep -q "^ServerName localhost" "$APACHE_CONF"; then
  echo "ServerName localhost" >> "$APACHE_CONF"
fi

# Restart Apache to apply changes
apachectl restart

echo "Apache berhasil diinstal dan dikonfigurasi. Webroot disetel ke $WEBROOT dan dapat diakses di port 8000."