#!/data/data/com.termux/files/usr/bin/bash

echo "===> Setup MariaDB di Termux"
pkg install -y mariadb

echo "===> Periksa perintah mana yang tersedia 1/2"
if command -v mariadbd-safe &>/dev/null; then
    DB_SAFE_CMD="mariadbd-safe"
elif command -v mysqld_safe &>/dev/null; then
    DB_SAFE_CMD="mysqld_safe"
else
    echo "Error: Tidak dapat menemukan perintah mariadbd-safe atau mysqld_safe"
    echo "Periksa apakah MariaDB terinstal dengan benar."
    exit 1
fi

echo "===> Periksa perintah mana yang tersedia 2/2"
if command -v mariadb &>/dev/null; then
    DB_CLIENT_CMD="mariadb"
elif command -v mysql &>/dev/null; then
    DB_CLIENT_CMD="mysql"
else
    echo "Error: Tidak dapat menemukan perintah mariadb atau mysql"
    echo "Periksa apakah MariaDB terinstal dengan benar."
    exit 1
fi

echo "===> Upgrade database jika perlu"
if command -v mariadb-upgrade &>/dev/null; then
    DB_UPGRADE_CMD="mariadb-upgrade"
elif command -v mysql_upgrade &>/dev/null; then
    DB_UPGRADE_CMD="mysql_upgrade"
else
    DB_UPGRADE_CMD="echo 'Perintah upgrade tidak ditemukan, melewati...'"
fi

echo "[info] Menggunakan perintah: $DB_SAFE_CMD, $DB_CLIENT_CMD, $DB_UPGRADE_CMD"

echo "===> Membersihkan proses MariaDB sebelumnya... [1/7]"
pkill -f mariadbd 2>/dev/null || true
pkill -f mysqld 2>/dev/null || true
sleep 3

echo "===> Mengatur direktori socket... [2/7]"
SOCKET_DIR="/data/data/com.termux/files/usr/var/run/mysqld"
mkdir -p $SOCKET_DIR
chmod 777 $SOCKET_DIR

echo "===> Memeriksa database... [3/7]"
$DB_UPGRADE_CMD --force 2>/dev/null || echo "Database baru atau sudah up-to-date"

echo "===> Memulai server MariaDB... [4/7]"
$DB_SAFE_CMD --user=root --skip-grant-tables --socket=$SOCKET_DIR/mysqld.sock &

echo "==> Menunggu server siap... [5/7]"
sleep 10

echo "===> Mengatur password root kosong... [6/7]"
$DB_CLIENT_CMD -u root 2>/dev/null << EOF || echo "Tidak dapat mengakses server, melanjutkan..."
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '';
FLUSH PRIVILEGES;
EOF

echo "===> Memulai ulang server dalam mode normal... [7/7]"
pkill -f mariadbd 2>/dev/null || true
pkill -f mysqld 2>/dev/null || true
sleep 3
$DB_SAFE_CMD --user=root --socket=$SOCKET_DIR/mysqld.sock &
sleep 5

echo "======================================"
echo "    MariaDB berhasil dikonfigurasi!   "
echo "======================================"
echo "Koneksi: $DB_CLIENT_CMD -u root"
echo "Server berjalan pada port default: 3306"
echo "======================================"
echo "Untuk memulai server: $DB_SAFE_CMD --user=root &"
echo "Untuk menghentikan server: pkill -f mysqld"
echo "Untuk mengatur MariaDB mulai otomatis saat login:"
echo "echo '$DB_SAFE_CMD --user=root &' >> ~/.profile"
echo "======================================"

if $DB_CLIENT_CMD -u root -e "SELECT 'Connection successful!' as Status;" 2>/dev/null; then
    echo "✓ Koneksi berhasil diverifikasi!"
else
    echo "⚠ Tidak dapat terkoneksi ke server."
    echo "Coba jalankan perintah berikut untuk memulai server secara manual:"
    echo "$DB_SAFE_CMD --user=root &"
    echo "Lalu tunggu beberapa detik dan coba koneksi dengan: $DB_CLIENT_CMD -u root"
fi