# this is experimental and not fully tested

Write-Host "=== Setup Environment (PowerShell) ==="

# Check Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = `
        [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

    Invoke-Expression (
        (New-Object System.Net.WebClient).DownloadString(
            "https://chocolatey.org/install.ps1"
        )
    )
} else {
    Write-Host "Chocolatey is already installed."
}

# Install applications using Chocolatey
Write-Host "Installing applications with Chocolatey..."
choco install -y `
    nodejs-lts `
    git `
    gh `
    lazygit `
    zig `
    fzf `
    ripgrep `
    fd `
    neovim `

# Enable Corepack & install pnpm
if (Get-Command corepack -ErrorAction SilentlyContinue) {
    Write-Host "Enabling Corepack..."
    corepack enable

    if (-not (Get-Command pnpm -ErrorAction SilentlyContinue)) {
        Write-Host "Installing pnpm via Corepack..."
        corepack prepare pnpm@latest --activate
    } else {
        Write-Host "pnpm is already installed."
    }
} else {
    Write-Host "Corepack not found (Node.js version too old?)."
}

# Install Tree-sitter CLI (only if npm exists)
if (Get-Command npm -ErrorAction SilentlyContinue) {
    if (-not (Get-Command tree-sitter -ErrorAction SilentlyContinue)) {
        Write-Host "Installing tree-sitter-cli via npm..."
        npm install -g tree-sitter-cli
    } else {
        Write-Host "tree-sitter is already installed."
    }
} else {
    Write-Host "npm not found, skipping tree-sitter installation."
}

# Check Bun.js
if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Bun.js..."
    Invoke-Expression (
        Invoke-RestMethod "https://bun.sh/install"
    )
} else {
    Write-Host "Bun.js is already installed."
}

Write-Host "Setup complete!"