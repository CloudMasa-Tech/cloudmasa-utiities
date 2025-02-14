#!/bin/bash

# Define package names
PACKAGES=("terraform" "awscli" "gitbash" "terragrunt" "opa" "python" "checkov" "vscode" "helm" "kubectl" "rsync" "zip" "unzip" "pre-commit")

detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS_TYPE="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS_TYPE="macos"
    elif [[ "$OS" =~ ^Windows || "$OS" =~ ^MINGW || "$OS" =~ ^CYGWIN ]]; then
        OS_TYPE="windows"
    else
        OS_TYPE="unknown"
    fi
}

auto_install_packages() {
    for package in "${PACKAGES[@]}"; do
        install_package "$package"
    done
    show_installed_versions
}

install_package() {
    case "$OS_TYPE" in
        linux)
            sudo apt-get update -y
            case "$1" in
                terraform)
                    echo "Installing Terraform..."
                    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
                    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
                    sudo apt-get install -y terraform
                    ;;
                awscli)
                    echo "Installing AWS CLI..."
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                    unzip -o awscliv2.zip
                    sudo ./aws/install
                    rm -rf awscliv2.zip aws/
                    ;;
                gitbash)
                    echo "Installing Git..."
                    sudo apt install -y git
                    ;;
                terragrunt)
                    echo "Installing Terragrunt..."
                    curl -LO https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64
                    sudo install -m 755 terragrunt_linux_amd64 /usr/local/bin/terragrunt
                    ;;
                opa)
                    echo "Installing OPA..."
                    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64
                    sudo install -m 755 opa /usr/local/bin/opa
                    ;;
                python)
                    echo "Installing Python..."
                    sudo apt install -y python3 python3-pip python3-venv
                    ;;
                checkov)
                    echo "Installing Checkov in a virtual environment..."
                    python3 -m venv checkov-env
                    source checkov-env/bin/activate
                    pip install -q checkov
                    deactivate
                    ;;
                pre-commit)
                    echo "Installing pre-commit in a virtual environment..."
                    python3 -m venv venv
                    source venv/bin/activate
                    pip install -q pre-commit
                    deactivate
                    ;;
                vscode)
                    echo "Installing VS Code..."
                    sudo apt install -y code
                    ;;
                helm)
                    echo "Installing Helm..."
                    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
                    ;;
                kubectl)
                    echo "Installing kubectl..."
                    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
                    sudo install -m 755 kubectl /usr/local/bin/kubectl
                    ;;
                rsync)
                    echo "Installing rsync..."
                    sudo apt install -y rsync
                    ;;
                zip)
                    echo "Installing zip..."
                    sudo apt install -y zip
                    ;;
                unzip)
                    echo "Installing unzip..."
                    sudo apt install -y unzip
                    ;;
                *)
                    echo "Unknown package: $1"
                    ;;
            esac
            ;;
        macos)
            echo "Installing $1 on macOS..."
            brew install "$1"
            ;;
        windows)
            echo "Installing $1 on Windows..."
            choco install "$1" -y --no-progress
            ;;
        *)
            echo "Unsupported OS: $OS_TYPE"
            ;;
    esac
}

uninstall_package() {
    case "$OS_TYPE" in
        linux)
            case "$1" in
                terraform) sudo apt remove -y terraform ;;
                awscli) sudo rm -rf /usr/local/aws-cli /usr/bin/aws ;;
                gitbash) sudo apt remove -y git ;;
                terragrunt) sudo rm -rf /usr/local/bin/terragrunt ;;
                opa) sudo rm -rf /usr/local/bin/opa ;;
                python) sudo apt remove -y python3 python3-pip python3-venv ;;
                checkov) rm -rf checkov-env ;;
                pre-commit) rm -rf venv ;;
                vscode) sudo apt remove -y code ;;
                helm) sudo rm -rf /usr/local/bin/helm ;;
                kubectl) sudo rm -rf /usr/local/bin/kubectl ;;
                rsync) sudo apt remove -y rsync ;;
                zip) sudo apt remove -y zip ;;
                unzip) sudo apt remove -y unzip ;;
                *) echo "Unknown package: $1" ;;
            esac
            ;;
        macos)
            echo "Uninstalling $1 on macOS..."
            brew uninstall "$1"
            ;;
        windows)
            echo "Uninstalling $1 on Windows..."
            choco uninstall "$1" -y --no-progress
            ;;
        *)
            echo "Unsupported OS: $OS_TYPE"
            ;;
    esac
}

show_installed_versions() {
    echo -e "\nInstalled Versions:"
    for package in "${PACKAGES[@]}"; do
        case "$package" in
            terraform) terraform -version 2>/dev/null || echo "$package not found" ;;
            awscli) aws --version 2>/dev/null || echo "$package not found" ;;
            gitbash) git --version 2>/dev/null || echo "$package not found" ;;
            terragrunt) terragrunt --version 2>/dev/null || echo "$package not found" ;;
            opa) opa version 2>/dev/null || echo "$package not found" ;;
            python) python3 --version 2>/dev/null || echo "$package not found" ;;
            checkov) source checkov-env/bin/activate && checkov --version 2>/dev/null || echo "$package not found" ;;
            pre-commit) source venv/bin/activate && pre-commit --version 2>/dev/null || echo "$package not found" ;;
            vscode) code --version 2>/dev/null || echo "$package not found" ;;
            helm) helm version 2>/dev/null || echo "$package not found" ;;
            kubectl) kubectl version --client 2>/dev/null || echo "$package not found" ;;
            rsync) rsync --version 2>/dev/null || echo "$package not found" ;;
            zip) zip --version 2>/dev/null || echo "$package not found" ;;
            unzip) unzip -v 2>/dev/null || echo "$package not found" ;;
            *) echo "No version command for $package" ;;
        esac
    done
}

# Detect OS
detect_os

echo "Detected OS: $OS_TYPE"

echo "Choose an option:"
echo "1) Install packages"
echo "2) Uninstall packages"
read -p "Enter your choice: " CHOICE

case $CHOICE in
    1) auto_install_packages ;;
    2)
        for package in "${PACKAGES[@]}"; do
            uninstall_package "$package"
        done
        echo "Uninstallation complete!"
        ;;
    *)
        echo "Invalid option. Exiting..."
        exit 1
        ;;
esac
