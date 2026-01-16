# this is experimental and not fully tested

Write-Host "=== Install PHP 8.1 & Composer (Chocolatey) ==="

# Check Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey not found. Please install Chocolatey first."
    exit 1
}

# Install PHP 8.1
if (-not (Get-Command php -ErrorAction SilentlyContinue)) {
    Write-Host "Installing PHP 8.1..."
    choco install -y php --version="8.1.30"
} else {
    Write-Host "PHP is already installed."
}

# Refresh environment so php is available immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

# Install Composer
if (-not (Get-Command composer -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Composer..."
    choco install -y composer
} else {
    Write-Host "Composer is already installed."
}

# Validate installation
Write-Host "`\n=== Versions ==="
php -v
composer --version

Write-Host "`\nPHP & Composer setup complete!"
