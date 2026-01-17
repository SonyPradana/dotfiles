#!/bin/bash

echo "Memulai setup Armbian..."

# Memperbarui daftar paket APT sekali di awal
echo "Memperbarui daftar paket APT..."
sudo apt update
echo "Daftar paket APT diperbarui."
echo

# 1. Instalasi ZeroTier
echo "Langkah 1: Instalasi ZeroTier..."
curl -s https://install.zerotier.com | sudo bash
echo "Instalasi ZeroTier selesai."
echo

# 2. Instalasi GitHub CLI (gh)
echo "Langkah 2: Instalasi GitHub CLI (gh)..."
sudo apt install -y gh
echo "Instalasi GitHub CLI selesai."
echo

# 3. Instalasi Node.js (via NVM)
echo "Langkah 3: Instalasi Node.js versi 22 menggunakan NVM..."
# Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# Source NVM for the current script session
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Install Node.js 22 LTS
nvm install 22
nvm use 22
nvm alias default 22
echo "Node.js $(node -v) terinstal."
echo

# 4. Instalasi Package Managers (pnpm)
echo "Langkah 4: Mengaktifkan pnpm..."
# Pastikan NVM/Node sudah aktif di environment skrip
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

corepack enable pnpm
pnpm -v
echo "pnpm telah diaktifkan."
echo

# 5. Instalasi Neovim
echo "Langkah 5: Instalasi Neovim dari source..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
sudo ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim
rm nvim-linux-arm64.tar.gz
echo "Instalasi Neovim selesai."
echo

# 6. Setup Lazygit
echo "Langkah 6: Menambahkan fungsi update-lazygit ke ~/.bashrc..."
cat <<'EOF' >> "$HOME/.bashrc"

# lazy git update script
# because lazygit package not support for this arch
update-lazygit() {
  echo "Memeriksa versi terbaru Lazygit..."
  local VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
  # Ditambahkan '2>/dev/null' untuk menekan error jika lazygit belum terinstal
  local CURRENT_VERSION=$(lazygit --version 2>/dev/null | grep -oP 'version=\K[^,]*' | sed 's/v//')

  if [ "$VERSION" = "$CURRENT_VERSION" ]; then
      echo "Lazygit sudah versi terbaru ($VERSION)."
  else
      echo "Update tersedia: $CURRENT_VERSION -> $VERSION. Sedang mengunduh..."
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_arm64.tar.gz"
      tar xf lazygit.tar.gz lazygit
      sudo install lazygit -D -t /usr/local/bin/
      rm lazygit.tar.gz lazygit
      echo "Lazygit berhasil diperbarui ke versi $VERSION!"
  fi
}
EOF
echo "Fungsi update-lazygit telah ditambahkan ke ~/.bashrc. Harap 'source ~/.bashrc' atau buka sesi terminal baru untuk menggunakannya."
echo

# 7. Instalasi Tree-sitter CLI
echo "Langkah 7: Instalasi Tree-sitter CLI..."
# Periksa apakah Cargo sudah ada, jika tidak, instal Rust
if ! command -v cargo &> /dev/null
then
    echo "Cargo tidak ditemukan. Memulai instalasi Rust..."
    # Menginstal Rust/Cargo secara non-interaktif
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    # Menambahkan Cargo ke PATH untuk sesi ini
    source "$HOME/.cargo/env"
    echo "Rust berhasil diinstal."
else
    echo "Rust (Cargo) sudah terinstal."
fi

echo "Installing Tree-sitter dependencies (libclang-dev)..."
sudo apt install -y libclang-dev

echo "Installing tree-sitter-cli via cargo..."
cargo install --locked tree-sitter-cli
echo "Instalasi Tree-sitter CLI selesai."
echo

# 8. Instalasi Utilities (fzf, ripgrep, fd)
echo "Langkah 8: Instalasi Utilities (fzf, ripgrep, fd-find)..."
sudo apt install -y fzf ripgrep fd-find

# Membuat symlink agar 'fdfind' bisa dipanggil dengan 'fd'
echo "Creating symlink for 'fd' from 'fdfind'..."
mkdir -p "$HOME/.local/bin"
ln -sf "$(which fdfind)" "$HOME/.local/bin/fd"
echo "Symlink 'fd' telah dibuat di ~/.local/bin/. Pastikan direktori ini ada di dalam PATH Anda."
echo "Instalasi Utilities selesai."
echo

# 9. Instalasi Docker & Docker Compose
echo "Langkah 9: Instalasi Docker & Docker Compose..."

# Instalasi Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh # Membersihkan script installer
sudo usermod -aG docker $USER
echo "Docker berhasil diinstal. Anda mungkin perlu logout dan login kembali agar perubahan grup Docker diterapkan."

# Instalasi Docker Compose
sudo apt install -y docker-compose
echo "Docker Compose berhasil diinstal."
echo

echo "Setup Armbian selesai!"
echo "Beberapa instalasi mungkin memerlukan restart shell atau logout/login untuk berfungsi dengan benar (misalnya NVM, Docker, dan Lazygit function)."
echo "Untuk menggunakan fungsi 'update-lazygit', jalankan 'source ~/.bashrc' atau buka terminal baru."