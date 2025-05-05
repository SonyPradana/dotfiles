#!/bin/bash

set -e

# Update package list
sudo apt update

# Install packages from apt
sudo apt install -y which openssh-client htop neofetch \
    make cmake fzf ripgrep fd-find neovim

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_linux_amd64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm -rf lazygit lazygit.tar.gz

# install bunjs
curl -fsSL https://bun.sh/install | bash

echo "All tools installed successfully."