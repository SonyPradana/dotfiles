# Panduan Menggunakan Dotfiles SonyPradana di Termux Android

Berikut adalah panduan cara menjalankan script dotfiles dari repositori SonyPradana/dotfiles dengan branch termux di Termux Android:

## Cara 1: Instalasi dan Setup dengan Curl

1. Buka aplikasi Termux di Android Anda
2. Jalankan perintah berikut untuk menginstal dan mengaplikasikan dotfiles dari repositori SonyPradana/dotfiles (branch termux) dalam satu langkah:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --branch termux SonyPradana/dotfiles --apply
```

Perintah ini akan mengunduh Chezmoi, menginisialisasi repositori dari branch termux, dan langsung mengaplikasikan konfigurasi dotfiles.

## Cara 2: Instalasi Chezmoi Terlebih Dahulu

1. Buka aplikasi Termux di Android Anda
2. Instal Chezmoi:

```bash
pkg update
pkg install chezmoi
```

3. Inisialisasi repositori dotfiles SonyPradana dengan branch termux dan langsung terapkan:

```bash
chezmoi init --branch termux SonyPradana/dotfiles --apply
```

4. Atau, jika ingin melihat perubahan terlebih dahulu sebelum menerapkan:

```bash
chezmoi init --branch termux SonyPradana/dotfiles
chezmoi diff
chezmoi apply
```

## Perintah Penting Lainnya

- **Update dotfiles**: `chezmoi update`
- **Edit file dotfiles**: `chezmoi edit <namafile>`
- **Status perubahan**: `chezmoi status`
- **Tambahkan file baru**: `chezmoi add ~/.namafile`

## Catatan Penting untuk Termux

- Pastikan Termux sudah diperbarui dengan menjalankan `pkg update` terlebih dahulu
- Pastikan Anda memiliki git terinstal: `pkg install git`
- Repositori akan diunduh ke `~/.local/share/chezmoi`