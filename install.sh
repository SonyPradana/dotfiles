#!/bin/bash

set -e
source ./config.sh

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

LOCAL_IP=$(hostname -I | awk '{print $1}')

echo -e "${GREEN}Nextcloud Installer${NC}"
echo "Zerotier: $ZEROTIER_IP | Local: $LOCAL_IP"

read -p "Continue? (y/n): " -n 1 -r
echo
[[ ! $REPLY =~ ^[Yy]$ ]] && exit 1

# Clean old
[ -d "$DOCKER_BASE_DIR" ] && {
    cd $DOCKER_BASE_DIR/mariadb 2>/dev/null && docker-compose down 2>/dev/null || true
    cd $DOCKER_BASE_DIR/nextcloud 2>/dev/null && docker-compose down 2>/dev/null || true
    read -p "Delete old data? (y/n): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && sudo rm -rf $DOCKER_BASE_DIR || mv $DOCKER_BASE_DIR ${DOCKER_BASE_DIR}_backup_$(date +%Y%m%d)
}

# Create dirs
echo -e "${YELLOW}Creating directories...${NC}"
mkdir -p $DOCKER_BASE_DIR/{mariadb,nextcloud/ssl}

# MariaDB
echo -e "${YELLOW}Setting up MariaDB...${NC}"
sed "s/MARIADB_ROOT_PASSWORD_PLACEHOLDER/$MARIADB_ROOT_PASSWORD/g" templates/mariadb-compose.yml > $DOCKER_BASE_DIR/mariadb/docker-compose.yml
cd $DOCKER_BASE_DIR/mariadb && docker-compose up -d
echo "Waiting 30s for MariaDB..."
sleep 30

# Create DB
docker exec -i mariadb-shared mysql -u root -p$MARIADB_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
CREATE USER IF NOT EXISTS 'nextcloud'@'%' IDENTIFIED BY '$NEXTCLOUD_DB_PASSWORD';
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'%';
FLUSH PRIVILEGES;
EOF

# SSL
echo -e "${YELLOW}Generating SSL...${NC}"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout $DOCKER_BASE_DIR/nextcloud/ssl/nextcloud.key \
  -out $DOCKER_BASE_DIR/nextcloud/ssl/nextcloud.crt \
  -subj "/C=ID/ST=Jakarta/L=Jakarta/O=Personal/CN=nextcloud.local" \
  -addext "subjectAltName=DNS:localhost,IP:$LOCAL_IP,IP:$ZEROTIER_IP" 2>/dev/null

chmod 600 $DOCKER_BASE_DIR/nextcloud/ssl/nextcloud.key

# Nextcloud
echo -e "${YELLOW}Setting up Nextcloud...${NC}"
cp templates/Dockerfile $DOCKER_BASE_DIR/nextcloud/
cp templates/apache-config.conf $DOCKER_BASE_DIR/nextcloud/
sed -e "s/NEXTCLOUD_DB_PASSWORD_PLACEHOLDER/$NEXTCLOUD_DB_PASSWORD/g" \
    -e "s/ZEROTIER_IP_PLACEHOLDER/$ZEROTIER_IP/g" \
    templates/nextcloud-compose.yml > $DOCKER_BASE_DIR/nextcloud/docker-compose.yml

cd $DOCKER_BASE_DIR/nextcloud
docker-compose build --no-cache
docker-compose up -d

# Backup script
sed "s/RootPassword123!GantiIni/$MARIADB_ROOT_PASSWORD/g" scripts/backup.sh > $DOCKER_BASE_DIR/mariadb/backup.sh
chmod +x $DOCKER_BASE_DIR/mariadb/backup.sh

echo -e "${GREEN}✅ Done!${NC}"
echo "Access: https://$LOCAL_IP or https://$ZEROTIER_IP"
echo "DB Password: $NEXTCLOUD_DB_PASSWORD"