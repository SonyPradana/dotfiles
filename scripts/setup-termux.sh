#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "===> Setup storage access..."
termux-setup-storage

echo "===> Updating packages..."
pkg up -y

echo "===> Installing tools..."
pkg install -y which openssh git htop neofetch gh \
    make cmake fzf ripgrep fd lazygit neovim \
    nodejs-lts composer

echo "===> Setting up SSH (port 2222)..."
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
fi

echo "===> Generating SSH host keys..."
ssh-keygen -A || echo "Failed to generate SSH host keys, continuing script..."

SSHD_CONFIG="$HOME/.config/ssh/sshd_config"
if [ -f "$SSHD_CONFIG" ]; then
  mkdir -p ~/.ssh
  cp "$SSHD_CONFIG" ~/.ssh/sshd_config
else
  cat >~/.ssh/sshd_config <<EOF
Port 2222
PasswordAuthentication yes
Subsystem sftp /data/data/com.termux/files/usr/libexec/sftp-server
EOF
fi

echo "===> Change your password now:"
passwd || echo "Password change failed, continuing..."

sshd -f ~/.ssh/sshd_config

echo "===> Installing LazyVim..."
NVIM_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_DIR" ]; then
  mv "$NVIM_DIR" "${NVIM_DIR}_backup_$(date +%s)"
fi
git clone https://github.com/LazyVim/starter "$NVIM_DIR"
cd "$NVIM_DIR" && rm -rf .git

echo "===> All done! SSH server running on port 2222.\n"