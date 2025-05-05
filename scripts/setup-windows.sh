# this is experimental and not fully tested

# Install Chocolatey
if ! choco -v > /dev/null 2>&1; then
    echo "Installing Chocolatey..."
    powershell -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command \
        "Set-ExecutionPolicy Bypass -Scope Process -Force; \
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; \
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
else
    echo "Chocolatey is already installed."
fi

# Install applications using Chocolatey
echo "Installing applications with Chocolatey..."
choco install -y nodejs-lts git gh lazygit llvm fzf ripgrep fd neovim vscode librewolf

# Install Bun.js
if ! bun -v > /dev/null 2>&1; then
    echo "Installing Bun.js..."
    curl -fsSL https://bun.sh/install | bash
else
    echo "Bun.js is already installed."
fi

echo "Setup complete!"
