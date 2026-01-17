# Konfigurasi Sistem

## Status Instalasi

Saat ini, sebagian besar instalasi aplikasi yang tercantum di bawah ini dapat diotomatisasi menggunakan skrip `setup_armbian.sh`. Manajer konfigurasi seperti chezmoi masih dalam evaluasi untuk manajemen konfigurasi yang lebih luas di masa mendatang.

## Setup Otomatis

Untuk menginstal sebagian besar aplikasi yang dibutuhkan secara otomatis, Anda dapat menggunakan skrip `setup_armbian.sh`.

**Langkah-langkah penggunaan:**

1.  **Berikan izin eksekusi pada skrip:**
    ```bash
    chmod +x setup_armbian.sh
    ```

2.  **Jalankan skrip:**
    ```bash
    ./setup_armbian.sh
    ```

**Catatan Penting Setelah Menjalankan Skrip:**
*   Setelah skrip selesai, Anda mungkin perlu **logout dan login kembali** agar perubahan pada grup Docker (untuk user) dan `PATH` (untuk NVM dan `~/.local/bin/fd`) diterapkan sepenuhnya.
*   Untuk menggunakan fungsi `update-lazygit` yang ditambahkan ke `~/.bashrc`, Anda perlu menjalankan `source ~/.bashrc` di terminal yang sedang berjalan, atau cukup buka sesi terminal baru.

## Aplikasi yang Terinstal

1. ZeroTier
  - Dokumentasi tersedia di website resmi
  - Instalasi:
    ```bash
    curl -s https://install.zerotier.com | sudo bash
    ```

2. GitHub CLI (gh)
  - Tersedia via package manager APT
  - Instalasi:
    ```bash
    sudo apt install gh
    ```

3. Node.js
  - Menggunakan NVM untuk manajemen versi Versi yang digunakan: Node.js 22 LTS
  - Instalasi:
    ```bash
    # Download and install nvm:
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
    # in lieu of restarting the shell
    \. "$HOME/.nvm/nvm.sh"
    # Download and install Node.js:
    nvm install 22
    # Verify the Node.js version:
    node -v # Should print "v22.21.1".
    ```

4. Package Managers
  - pnpm - Package manager utama
  - bun - Digunakan untuk proyek sehari-hari
  - Instalasi:
  ```bash
    # Download and install pnpm:
    corepack enable pnpm
    # Verify pnpm version:
    pnpm -v
```
```
```

5. Neovim
  - Diinstal dari source (karena tidak tersedia di APT untuk arsitektur ini)
  - Mengikuti script instalasi dari dokumentasi resmi
  - Instalasi:
    ```bash
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
    sudo tar -C /opt -xzf nvim-linux-arm64.tar.gz
    sudo ln -s /opt/nvim-linux-arm64/bin/nvim /usr/local/bin/nvim
    ```

6. Lazygit
  - Tidak tersedia untuk arsitektur Armbian
  - Menggunakan custom bash script.
  - Copy paste ke `.bashrc` dan panggil dengan `update-lazygit`
    ```bash
    # lazy git update script
    # because lazygit package not support for this arch
    update-lazygit() {
      echo "Memeriksa versi terbaru Lazygit..."
      local VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
      local CURRENT_VERSION=$(lazygit --version | grep -oP 'version=\K[^,]*' | sed 's/v//')

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
    ```
```
```

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

## Instalasi Nextcloud (Docker)

Repositori ini menyertakan skrip untuk menginstal Nextcloud secara otomatis menggunakan Docker dan Docker Compose.

**Prasyarat:**

Sebelum menjalankan skrip, Anda harus membuat file konfigurasi `docker/config.sh`.

1.  Buka direktori `docker`:
    ```bash
    cd docker
    ```

2.  Buat file bernama `config.sh`. Anda bisa menggunakan editor teks seperti `nano` atau `vim`.

3.  Isi file tersebut dengan variabel berikut. **Ganti nilai-nilai di bawah ini dengan nilai Anda sendiri yang aman.**

    ```bash
    #!/bin/bash
    # Ganti dengan alamat IP ZeroTier Anda
    ZEROTIER_IP="10.10.10.1"

    # Direktori dasar untuk data Docker (Nextcloud dan MariaDB)
    DOCKER_BASE_DIR="$HOME/docker-data"

    # Ganti dengan password root MariaDB yang kuat
    MARIADB_ROOT_PASSWORD="ganti_dengan_password_root_yang_aman"

    # Ganti dengan password untuk user database Nextcloud yang kuat
    NEXTCLOUD_DB_PASSWORD="ganti_dengan_password_db_nextcloud_yang_aman"
    ```

**Menjalankan Skrip Instalasi:**

Setelah `config.sh` dibuat dan disimpan, Anda dapat menjalankan skrip instalasi dari dalam direktori `docker`:

```bash
./install.sh
```

Skrip akan mengatur kontainer MariaDB dan Nextcloud, menghasilkan sertifikat SSL self-signed, dan memulai layanan.

## Catatan Konfigurasi

- Konfigurasi Neovim akan diatur terpisah
- Semua tools tersedia dengan dokumentasi masing-masing
- Arsitektur sistem: Armbian (ARM-based)

## TODO / Pending

- Setup konfigurasi Neovim lengkap
- Evaluasi penggunaan chezmoi untuk manajemen konfigurasi
- Setup otomatisasi instalasi
- Setup docker: nextcloud 
