Konfigurasi Sistem

Status Instalasi

Saat ini instalasi masih dilakukan secara manual, menunggu keputusan apakah akan menggunakan manajer konfigurasi seperti chezmoi di masa depan.

Aplikasi yang Terinstal

1. ZeroTier

- Dokumentasi tersedia di website resmi

2. GitHub CLI (gh)

- Tersedia via package manager APT
- Instalasi:
  ```bash
  sudo apt install gh
  ```

3. Node.js

- Menggunakan NVM untuk manajemen versi
- Versi yang digunakan: Node.js 22 LTS
- Instalasi:
  ```bash
  nvm install 22
  nvm use 22
  ```

4. Package Managers

- pnpm - Package manager utama
- bun - Digunakan untuk proyek sehari-hari

5. Neovim

- Diinstal dari source (karena tidak tersedia di APT untuk arsitektur ini)
- Mengikuti script instalasi dari dokumentasi resmi

6. Lazygit

- Tidak tersedia untuk arsitektur Armbian
- Menggunakan custom bash script (termasuk dalam .bashrc)

7. Tree-sitter CLI

- Dikompilasi dari source menggunakan Cargo
- Prasyarat dan instalasi:
  ```bash
  sudo apt-get install libclang-dev
  cargo install --locked tree-sitter-cli
  ```

8. Utilities

- fzf - Fuzzy finder
- ripgrep - Fast text search
- fd - User-friendly find alternative

9. Docker & Docker Compose

- Instalasi Docker:
  ```bash
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo usermod -aG docker $USER
  ```
- Instalasi Docker Compose:
  ```bash
  sudo apt update
  sudo apt install docker-compose
  ```

10. Shell & Terminal

- Fish shell (opsional)

Catatan Konfigurasi

- Konfigurasi Neovim akan diatur terpisah
- Semua tools tersedia dengan dokumentasi masing-masing
- Arsitektur sistem: Armbian (ARM-based)

TODO / Pending

- Setup konfigurasi Neovim lengkap
- Evaluasi penggunaan chezmoi untuk manajemen konfigurasi
- Setup otomatisasi instalasi
- Setup docker: nextcloud 
