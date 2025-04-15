#!/data/data/com.termux/files/usr/bin/bash
set -e

echo "===> Updating packages..."
pkg update -y && pkg upgrade -y

echo "===> Installing tools..."
pkg install -y openssh git neovim nodejs php composer \
  make cmake lazygit fd ripgrep fzf

echo "===> Setting up SSH (port 2222)..."
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
fi
sshd-keygen

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

echo "===> All done! SSH server running on port 2222."
