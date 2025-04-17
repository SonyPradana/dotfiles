#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "===> Setup storage access..."
termux-setup-storage

echo "===> Updating packages..."
pkg up -y

echo "===> Installing tools..."
pkg install -y which make cmake openssh git \
    fzf ripgrep fd htop neofetch \
    nodejs php composer lazygit neovim gh

echo "===> Setting up SSH (port 2222)..."
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
fi

echo "===> Generating SSH host keys..."
ssh-keygen -A || echo "Failed to generate SSH host keys, continuing script..."

SSHD_CONFIG="$HOME/.dotfiles/.local/config/sshd/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
  mkdir -p ~/.ssh
  cp "$SSHD_CONFIG" ~/.ssh/sshd_config
else
  cat >~/.ssh/sshd_config <<EOF
Port 2222
PasswordAuthentication yes
Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server
EOF

echo "===> Change your password now:"
passwd

sshd -f ~/.ssh/sshd_config

echo "===> Installing LazyVim..."
NVIM_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_DIR" ]; then
  mv "$NVIM_DIR" "${NVIM_DIR}_backup_$(date +%s)"
fi
git clone https://github.com/LazyVim/starter "$NVIM_DIR"
cd "$NVIM_DIR" && rm -rf .git

echo "===> Setting custom php.ini..."
PHP_INI_SRC="$HOME/php/php.ini"
PHP_INI_DST="$PREFIX/etc/php/php.ini"

mkdir -p "$(dirname "$PHP_INI_DST")"

if [ -f "$PHP_INI_SRC" ]; then
  cp "$PHP_INI_SRC" "$PHP_INI_DST"
  echo "php.ini copied to $PHP_INI_DST"
else
  echo "WARNING: $PHP_INI_SRC not found, skipping..."
fi

echo "===> All done! SSH server running on port 2222."