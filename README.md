# Panduan Menggunakan Dotfiles SonyPradana

🚀 Setup cepat untuk konfigurasi development environment di Windows dan Termux Android!

## 📱 Untuk Pengguna Termux Android

1. Buka aplikasi Termux
2. Install Chezmoi dengan perintah:

```bash
pkg up -y && pkg install chezmoi -y
```

3. Setup dotfiles dengan satu baris perintah:

```bash
chezmoi init --branch termux SonyPradana/dotfiles --apply
```

## 🪟 Untuk Pengguna Windows

1. Buka PowerShell sebagai Administrator
2. Install Chezmoi menggunakan scoop:

```powershell
choco install chezmoi
```

3. Setup dotfiles dengan branch windows:

```powershell
chezmoi init --branch windows SonyPradana/dotfiles --apply
```

## ℹ️ Informasi Tambahan

- Dokumentasi lengkap: [Chezmoi Documentation](https://www.chezmoi.io/)